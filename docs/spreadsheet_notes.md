# Spreadsheet notes (Part B)

## (a) Formulas typed in the first data row (orders tab, row 2)

| Column | Formula |
|---|---|
| K clean_first_name | `=PROPER(TRIM(C2))` |
| L clean_last_name | `=PROPER(TRIM(D2))` |
| M category | `=VLOOKUP(G2, products!$A$2:$C$10, 2, FALSE)` |
| N unit_price | `=XLOOKUP(G2, products!$A$2:$A$10, products!$C$2:$C$10, "UNKNOWN_ITEM")` |
| O revenue_calc | `=N2*H2` |

## (b) Aggregates of amount on completed_orders (cells O1:P6)

| Metric | Formula | Result |
|---|---|---|
| COUNT | `=COUNT(K2:K64)` | 63 |
| SUM | `=SUM(K2:K64)` | 346200 |
| AVERAGE | `=AVERAGE(K2:K64)` | 5495.2381 |
| MIN | `=MIN(K2:K64)` | 1100 |
| MAX | `=MAX(K2:K64)` | 15600 |

## (c) Pivot tables (completed_orders tab, starting at O9 and O17)

Pivot (i): rows = category, columns = region, values = sum of amount

| category | East | North | South | West | Grand Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Grand Total | 69500 | 119300 | 82500 | 74900 | 346200 |

Pivot (ii): rows = order_month, values = sum of amount and count of order_id

| order_month | Sum of amount | Count of order_id |
|---|---|---|
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| Grand Total | 346200 | 63 |

## (d) Reconciliation with Part A (q05)

| Figure | Spreadsheet | Part A (q05) | Result |
|---|---|---|---|
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## (e) Data validation

**Missing amounts.** Three orders have no amount: 1001, 1010 and 1064 (the same three rows returned by q02). All three are pending, so they are excluded from revenue by the completed filter. I did not fill them in or guess a value, because an invented amount would change the totals. In the orders tab their amount stays empty, and revenue_calc still shows unit_price x quantity for them, which is only an estimate.

**Data types.** Quantity and amount are stored as numbers (they are right-aligned and COUNT, SUM and AVERAGE return correct results). order_month is kept as plain text such as 2026-09, so it is not converted into a date.

**Duplicates and outliers.** There is no duplicate order_id (90 distinct ids from 1001 to 1090). Among the completed orders the largest amount is 15600, and four orders share it: 1061, 1065, 1069 and 1077 (all Air Fryer, quantity 3). This is the unit price of 5200 times 3, so it is a legitimate value and not an error.

**Decision for a colleague who inherits the sheet.** Keep order_month as plain text. If it is changed to a date, the month labels in the pivot and in the CSV change, and the numbers no longer match the SQL reports.

## (f) Setup

- Tabs created: `products` and `completed_orders` (the imported tab is `orders`; a helper tab `export` was used only to download the CSV).
- Rows imported into `orders`: 90 (plus the header).
- The `products` tab occupies the range A1:C10.
- Filter and sort applied before building `completed_orders`: status = completed, then amount sorted from largest to smallest. This left 63 rows, pasted as values.
- Import setting: automatic conversion of text to numbers, dates and formulas was turned off, so order_month stayed as text.
- XLOOKUP fallback test: in a spare cell (orders!R1) the formula `=XLOOKUP("Mystery Item", products!$A$2:$A$10, products!$C$2:$C$10, "UNKNOWN_ITEM")` displays UNKNOWN_ITEM.
