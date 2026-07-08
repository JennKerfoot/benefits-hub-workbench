"""
Pytest configuration for the pipeline test suite.

Ensures `pipeline/` (the parent of this tests/ dir) is on sys.path so
`from preprocess import ...` resolves regardless of the current working
directory pytest is invoked from.
"""

import sys
from pathlib import Path

PIPELINE_DIR = Path(__file__).resolve().parent.parent
if str(PIPELINE_DIR) not in sys.path:
    sys.path.insert(0, str(PIPELINE_DIR))
