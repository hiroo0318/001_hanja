---
name: hanja-source-ingestion
description: "Extract, normalize, and verify Hanja grade-exam source material for this project. Trigger when importing, correcting, or auditing raw Hanja data."
---

# Hanja source ingestion

1. Inspect files in `01 raw data/` without modifying them.
2. Extract each record as grade, Hanja character, Korean meaning, Korean reading, and source page.
3. Preserve the raw transcription alongside normalized values when transformation is needed.
4. Create `docs/data-catalog.md` and seed-ready data only after checking duplicate, missing, and ambiguous records.
5. Mark ambiguous OCR or scan results for human review; never invent a character, meaning, reading, or grade.
