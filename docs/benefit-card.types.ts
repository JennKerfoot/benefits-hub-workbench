/**
 * Output contract of the card compiler — what BenefitsHub.tsx renders.
 * Extends the shapes already in artifacts/duos-pwa/src/screens/BenefitsHub.tsx
 * with provenance fields so QA and member support can trace any rendered value.
 */

export type FactSource = 'pbp' | 'eoc' | 'computed';

export interface FactRow {
  label: string;
  value: string;
  highlight?: boolean;
  /** Where this value came from. 'pbp' = plan's CMS filing; 'eoc' = approved
   *  carrier-content fact; 'computed' = year constant (e.g. Part D cap). */
  source: FactSource;
  /** For source 'pbp': path into the plan JSON, e.g. "benefits.eyewear.max_plan_benefit". */
  pbpPath?: string;
  /** For source 'eoc': citation from the content file, e.g. "2026 EOC p. 84". */
  citation?: string;
}

export interface BenefitSection {
  icon: string;
  label: string;
  facts: FactRow[];
  note?: string;
  chips?: string[];
}

export interface Connection {
  icon: string;
  text: string;
}

export interface BenefitCTA {
  label: string;
  icon?: string;
  action: 'tel' | 'web' | 'nav';
  href?: string;
  navTarget?: string;
}

export interface BenefitCard {
  key: string;          // taxonomy card key, e.g. "fitness"
  icon: string;         // Material Symbols name
  iconBg: string;
  iconColor: string;
  barColor: string;
  title: string;
  tagline: string;      // slots already resolved — plain display string
  tileSubtitle: string;
  sections: BenefitSection[];
  connections: Connection[];
  cta?: BenefitCTA;
  /** Vendor delivering the benefit (One Pass, TruHearing, …) — carrier content. */
  vendor?: string;
  /** Stamped by the compiler from taxonomy.json for SSBCI/VBID cards. The app
   *  renders this card ONLY when the member's eligibility-file flag matches —
   *  omitting this check would show condition-gated benefits to all members. */
  requiresEligibility?: 'ssbci';
  /** Member-facing banner shown on eligibility-gated cards. */
  eligibilityBanner?: string;
}

export interface CompiledPlanCards {
  planId: string;                  // "H5425_123_0"
  planYear: number;                // 2026
  planName: string;                // plan_info.plan_name
  orgMarketingName: string;        // plan_info.org_marketing_name
  /** When true the renderer shows the "$0 member liability" banner; card
   *  values are NOT rewritten (mirrors the dashboard's display-layer policy). */
  dsnpZeroDollar: boolean;
  cards: BenefitCard[];
  /** Compiler + content versions for traceability. */
  build: { compilerVersion: string; contentRevision: string; generatedAt: string };
}
