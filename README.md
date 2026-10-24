# Big Billion Days Regional Performance Review

A traceable analytics pipeline for Flipkart's Big Billion Days sale: SQL queries, a spreadsheet cleaning layer, a dashboard specification, and a verified AI-assistance log, all built on one dataset (4 tables, 90 orders, INR).

## Tools used

- **SQL compiler:** SQLite Online (sqliteonline.com)
- **SQL dialect:** SQLite
- **Spreadsheet tool:** Google Sheets
- **Dashboard:** I did not build the dashboard in Tableau Public. Part C is a written specification (docs/dashboard_spec.md) with every number computed in the spreadsheet, as the brief allows.

## Key findings

North is the strongest region with INR 119300 of completed revenue (34.5% of the INR 346200 total, from 63 completed orders and 106 units), but its monthly revenue fell every month, from 53500 in 2026-09 to 41300 in 2026-10 (-22.8%) and 24500 in 2026-11, so the assistant's claim of 38% growth for North is contradicted by the data. Electronics is the largest category (INR 142300, 41.1%), and Air Fryer is the best single product (INR 104000), which helped Home revenue jump to INR 83200 in 2026-11 and total revenue rise 66.3% from October to November (93100 to 154800). South earns only INR 28700 from Electronics against INR 73400 in North, which is why the first recommendation is an Electronics promotion in South.

## File index

| File | Part |
|---|---|
| README.md | Submission (all parts) |
| sql/00_schema_and_seed.sql | Part A |
| sql/q01.sql to sql/q13.sql | Part A |
| results/query_results.md | Part A |
| data/orders_enriched.csv | Part A (output, input to Part B) |
| docs/spreadsheet_notes.md | Part B |
| data/orders_clean.csv | Part B (output, input to Part C) |
| docs/dashboard_spec.md | Part C |
| sql/d1_corrected.sql | Part D |
| docs/ai_log.md | Part D |

## Assumptions and choices

- Revenue means the sum of amount over orders with status completed. Pending and disputed orders are never counted as revenue.
- The three orders with a missing amount (1001, 1010, 1064) are all pending, so they do not affect revenue. They were left empty and not filled in.
- order_month is kept as plain text (for example 2026-09) in the spreadsheet and in the CSV files, and it is not converted to a date.
- The dashboard numbers come from the cleaned CSV and the spreadsheet pivots, and they reconcile with Part A's q05 (63 orders, INR 346200).
- AI assistance was used while building this project. See docs/ai_log.md.
