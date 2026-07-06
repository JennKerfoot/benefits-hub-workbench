/* Benefits Hub — Carrier Pack authoring logic (pure; no DOM).
   Loadable in the browser (<script>) and headlessly (new Function shim) for tests. */
(function () {
  "use strict";

  function contractsFor(C, carrier) {
    return Object.keys(C.registry.contracts || {}).filter(h => C.registry.contracts[h] === carrier);
  }

  function boardStatus(C, carrier) {
    const hnums = contractsFor(C, carrier);
    return (C.taxonomy.cards || []).map(card => {
      const key = card.key;
      const hasCarrierPack = !!((C.carriers[carrier] || {})[key]);
      let overrides = 0;
      hnums.forEach(h => { if ((C.contracts && C.contracts[h] || {})[key]) overrides++; });
      Object.keys(C.plans || {}).forEach(pid => {
        const m = /^([HRES]\d{4})_/.exec(pid);   // valid plan id -> capture the contract H#
        if (!m) return;
        if (hnums.includes(m[1]) && (C.plans[pid] || {})[key]) overrides++;
      });
      return { key, hasCarrierPack, overrides, source: hasCarrierPack ? "carrier" : "base" };
    });
  }

  const FORM_FIELDS = [
    { key: "title", label: "Card title", type: "text" },
    { key: "vendor", label: "Vendor", type: "text", hint: "internal — never shown to members" },
    { key: "tagline", label: "Tagline", type: "text" },
    { key: "tileSubtitle", label: "Tile subtitle", type: "text" },
    { key: "note", label: "Note", type: "textarea" },
    { key: "ctaLabel", label: "Button label", type: "text" },
    { key: "ctaAction", label: "Button action", type: "select", options: ["tel", "web", "nav"] },
    { key: "ctaHref", label: "Button link", type: "text" },
    { key: "howToUse", label: "How to use this benefit", type: "textarea" },
  ];

  function packToForm(pack) {
    pack = pack || {};
    const cta = pack.cta || {};
    return {
      title: pack.title || "", vendor: pack.vendor || "", tagline: pack.tagline || "",
      tileSubtitle: pack.tileSubtitle || "", note: pack.note || "",
      ctaLabel: cta.label || "", ctaAction: cta.action || "", ctaHref: cta.href || "",
      howToUse: pack.howToUse || "",
      eocFacts: (pack.eoc_facts || []).map(f => ({
        label: f.label || "", value: f.value || "", citation: f.citation || "", approved: f.approved === true,
      })),
    };
  }

  function formToPack(form, cardKey) {
    const pack = { $schema: "duos-benefit-content/v1", key: cardKey };
    ["title", "vendor", "tagline", "tileSubtitle", "note", "howToUse"].forEach(k => {
      if (form[k] && String(form[k]).trim()) pack[k] = String(form[k]).trim();
    });
    if (form.ctaLabel && form.ctaAction) {
      pack.cta = { label: form.ctaLabel.trim(), action: form.ctaAction };
      if (form.ctaHref && form.ctaHref.trim()) pack.cta.href = form.ctaHref.trim();
    }
    const facts = (form.eocFacts || [])
      .filter(f => f.label && f.value && f.citation) // hard rule 2: all three required
      .map(f => ({ label: f.label.trim(), value: f.value.trim(), source: "eoc", approved: true, citation: f.citation.trim() }));
    // Omit the key entirely when empty (never emit eoc_facts: []). The compiler's
    // mergeContent concatenates eoc_facts only when the key is PRESENT, so this
    // omission is load-bearing: it keeps a userPack/preview edit from clobbering
    // inherited facts.
    if (facts.length) pack.eoc_facts = facts;
    return pack;
  }

  // shallow field merge of packs (base first). scalar fields: later wins; eoc_facts concat.
  function mergePacks(packs) {
    const out = {};
    packs.filter(Boolean).forEach(p => {
      Object.keys(p).forEach(k => {
        if (k === "eoc_facts") out.eoc_facts = (out.eoc_facts || []).concat(p.eoc_facts || []);
        else out[k] = p[k];
      });
    });
    return out;
  }

  function effectiveForm(C, scope, cardKey) {
    const layers = [ (C.base || {})[cardKey] ];
    if (scope.level === "contract" || scope.level === "plan")
      layers.push(((C.carriers || {})[scope.carrier] || {})[cardKey]);
    if (scope.level === "plan")
      layers.push(((C.contracts || {})[scope.contract] || {})[cardKey]);
    return packToForm(mergePacks(layers));
  }

  const DELTA_KEYS = ["title", "vendor", "tagline", "tileSubtitle", "note", "ctaLabel", "ctaAction", "ctaHref", "howToUse"];
  function overrideDelta(inheritedForm, editedForm) {
    const delta = {};
    DELTA_KEYS.forEach(k => { if ((editedForm[k] || "") !== (inheritedForm[k] || "")) delta[k] = editedForm[k]; });
    if (JSON.stringify(editedForm.eocFacts || []) !== JSON.stringify(inheritedForm.eocFacts || []))
      delta.eocFacts = editedForm.eocFacts || [];
    return delta;
  }

  function exportPath(scope, cardKey) {
    if (scope.level === "carrier") return `carriers/${scope.carrier}/${cardKey}.json`;
    if (scope.level === "contract") return `contracts/${scope.contract}/${cardKey}.json`;
    if (scope.level === "plan") return `plans/${scope.planId}/${cardKey}.json`;
    throw new Error("exportPath: unknown scope level " + scope.level);
  }

  // Build the content pack to SAVE at a scope. Carrier scope OVERLAYS the form's
  // managed fields onto the existing on-disk pack, preserving keys the Phase-1 form
  // does not surface (eoc_facts, verification, appliesTo, itemContent, cta.icon, ...) —
  // so a scalar edit never silently drops an approved+cited fact or provenance.
  // Contract/plan scope save only the override delta vs the inherited form.
  function buildSavePack(scope, existingPack, editedForm, inheritedForm, cardKey) {
    if (scope.level === "carrier") {
      const existing = existingPack || {};
      const managed = formToPack(editedForm, cardKey);
      const pack = Object.assign({}, existing, managed);
      if (existing.cta && managed.cta) pack.cta = Object.assign({}, existing.cta, managed.cta);
      return pack;
    }
    return formToPack(overrideDelta(inheritedForm, editedForm), cardKey);
  }

  window.WBAuthor = { boardStatus, FORM_FIELDS, packToForm, formToPack, effectiveForm, overrideDelta, exportPath, buildSavePack };
})();
