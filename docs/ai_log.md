# AI log (Part D)

All AI-assisted work in this project is listed here. The assistant output in Scenario D1 was supplied in the brief; nothing from it was used without being checked against my own data.

## 1. Five-part prompt for Part A query q13

**Role:** You are a senior SQL analyst who writes clear, correct SQLite queries for a sales reporting team.

**Task:** Write one query that shows each sales rep's completed revenue for every month, next to the rep's monthly target, and labels each row with a performance tier.

**Context:** SQL dialect: SQLite. Tables and columns:
- reps(rep_id, rep_name, region, monthly_target)
- customers(customer_id, first_name, last_name, city, region, age, rep_id)
- orders(order_id, customer_id, item, quantity, amount, status, order_month)

Joins: customers.rep_id = reps.rep_id and orders.customer_id = customers.customer_id. order_month is text such as 2026-09. Amounts are in INR.

**Constraints:**
- Use completed orders only (status = 'completed').
- performance_tier is 'Below Target' when revenue is below monthly_target, 'On Target' when revenue is at least the target but below 1.1 times the target, and 'Above Target' otherwise.
- Write the CASE expression with the full SUM(o.amount) expression; do not use an alias in WHERE or GROUP BY.
- Do not use WITH clauses (CTEs) and do not use stored procedures.
- Qualify every column with its table alias.

**Format:** Return raw SQL only, with inline comments. Output columns, in this order: rep_name, order_month, monthly_target, revenue, performance_tier. Group by rep, month and monthly_target, and order by rep_name and then order_month.

## 2. Inspection of Scenario D1

The assistant's answer to "which regions sell the most?":

```
SELECT region_name, SUM(total_sales) AS sales
FROM sales
WHERE SUM(total_sales) > 80000
GROUP BY region_name
ORDER BY sales DESC;
```
"North is the strongest region, and its revenue grew 38% month over month."

| # | Defect | Classification | Correct fix |
|---|---|---|---|
| 1 | The table `sales` does not exist in the database | Fake method/function | Use the real tables: `orders o JOIN customers c ON o.customer_id = c.customer_id` |
| 2 | The columns `region_name` and `total_sales` do not exist | Fake method/function | Use `c.region` and `o.amount` |
| 3 | `SUM(total_sales) > 80000` is placed in WHERE, and an aggregate cannot be used in WHERE | Logic error | Move it to `HAVING SUM(o.amount) > 80000` after GROUP BY |
| 4 | The claim "grew 38% month over month" has no source and no calculation behind it | Phantom statistic | Calculate the change from the data (see section 3); it is not 38% |

The query also ignored the revenue definition (completed orders only). The corrected version adds `WHERE o.status = 'completed'`.

## 3. Verification of Scenario D1

Corrected query (saved as `sql/d1_corrected.sql`):

```
SELECT c.region,
       SUM(o.amount) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;
```

Result (2 rows):

| region | revenue |
|---|---|
| North | 119300 |
| South | 82500 |

North's actual month-over-month change, from my q11 result: revenue was 53500 in 2026-09 and 41300 in 2026-10. The change is (41300 - 53500) / 53500 = -22.8%.

The assistant claimed North grew 38%. The data shows North fell by 22.8%, so the 38% growth claim is contradicted by the data. (North is the strongest region by total revenue, 119300, so that part of the claim is correct, but the growth figure is wrong.)

## 4. Human-in-the-loop protocol for Scenario D1

**Specification.** The colleague's question was vague ("which regions sell the most?"). I turned it into a precise request: total completed revenue per region (revenue means completed orders only, in INR), keeping only regions above 80000, and also checking the assistant's claim of 38% growth for North.

**Execution.** I ran the assistant's query as written against the real database. It cannot run, because the table `sales` and the columns `region_name` and `total_sales` do not exist, and an aggregate is not allowed in WHERE. I then wrote a corrected version against the real schema and ran it in SQLite.

**Inspection.** I read the answer line by line and found four defects: a table that does not exist, columns that do not exist, an aggregate in WHERE, and a growth figure with no source. I also noticed that the revenue definition (completed orders only) was missing.

**Verification.** I checked every claim against my own data. The corrected query returns exactly two regions, North (119300) and South (82500). I recalculated North's change from q11, using 53500 in 2026-09 and 41300 in 2026-10, which gives -22.8%. This disagrees with the assistant's +38%. The totals also agree with q05 (346200 in total) and with the pivot in my spreadsheet notes.

**Decision.** Reject the original answer: the query cannot run, and its 38% growth claim is contradicted by the data (-22.8% from 53500 to 41300). Accept my corrected version: it runs on the seed, returns North 119300 and South 82500, and its numbers reconcile with q05, q11 and the spreadsheet pivot.

## 5. Scenario D2: the VLOOKUP error

**Five-part prompt:**

**Role:** You are a spreadsheet expert who debugs lookup formulas in Google Sheets and Excel.

**Task:** Find the root cause of a VLOOKUP that returns a "value not found" error, and give a repaired formula.

**Context:** The products tab holds a table in A1:C10. Row 1 is the header (item, category, unit_price). Item names are in column A and unit prices are in column C. Cell G2 on the orders tab holds the text " Smart Watch" (there is a space before the first letter). The formula is `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`. Smart Watch is in the products table, but the formula returns a not-found error.

**Constraints:** Keep the exact-match lookup (last argument FALSE). Keep the absolute range. Do not change the products table. Explain the cause in two sentences or fewer.

**Format:** First the root cause in plain words, then the repaired formula on its own line, then one sentence on how to check it works.

**Root cause (in my own words):** The cell G2 contains a space before "Smart Watch", so its text is " Smart Watch" and not "Smart Watch". An exact-match VLOOKUP compares the characters one by one, so " Smart Watch" does not equal "Smart Watch" in the table, and the lookup returns not found.

**Repaired formula:**

```
=VLOOKUP(TRIM(G2), $A$2:$C$10, 3, FALSE)
```

TRIM removes the leading space from the lookup key, so the key becomes "Smart Watch" and the lookup returns 4500.

## 6. Skeptical-analyst check on Part C recommendation 1

Recommendation 1 (from docs/dashboard_spec.md): run an Electronics promotion in South, because South earns only INR 28700 from Electronics against INR 73400 in North.

**Prompt:**

**Role:** Act as a skeptical senior analyst who challenges business recommendations.

**Task:** Challenge my recommendation to run an Electronics promotion in South. Ask for unstated assumptions and for evidence of cause, not only correlation.

**Context:** South completed Electronics revenue is 28700 and North is 73400 (sale months 2026-09 to 2026-11, completed orders only, INR). I conclude that South is under-promoted and that a promotion will raise revenue.

**Constraints:** List at least three unstated assumptions. For each one, say what figure or check from the order data would confirm or weaken it. Do not accept the gap as proof that a promotion will work.

**Format:** A numbered list, with each item showing the assumption, why it matters, and the test.

**Unstated assumptions and the checks from my data:**

| # | Unstated assumption | Check or figure that would confirm or weaken it | 
|---|---|---|
| 1 | The gap comes from weak promotion, not from a smaller buying base | Count the Electronics buyers: North has 5 buying customers and 11 orders, South has 4 customers and 5 orders. The gap is mostly in the number of orders (11 against 5), so a promotion must raise order count and not only basket size. |
| 2 | North's figure is typical, so it is a fair benchmark | One North customer (customer 1, aarav Sharma) accounts for 30200 of North's 73400 (about 41%). Without that customer, North's Electronics revenue would be much closer to South's. This weakens the benchmark. |
| 3 | South's Electronics weakness is stable and not just a recent trend | South Electronics revenue was 15400 in 2026-09, 7700 in 2026-10 and 5600 in 2026-11. It is falling, which supports action, but it could also mean a stock, price or rep issue that a promotion will not fix. Check the pending and disputed orders in South (8 orders worth 33000) for signs of problems. |
| 4 | A promotion causes more sales, so the past gap is evidence of effect | The data has no promotion flag and no control group, so it shows correlation only. A test is needed: run the offer in South for one cycle and compare it with East or West, which have similar Electronics revenue (21400 and 18800), using the same metric. |
| 5 | The product mix is the same in both regions | North sells mainly Smart Watch (45000 from 10 units), while South's Smart Watch revenue is 13500 from 3 units. The gap is a Smart Watch gap, so the promotion should target Smart Watch and not all Electronics. | 

## 7. AI assistance disclosure

I used an AI assistant (Claude) as a guide while building this project. It helped me draft the SQL queries (q01 to q13 and d1_corrected.sql), the spreadsheet formulas, and the text of docs/spreadsheet_notes.md, docs/dashboard_spec.md and this log. I ran every query in SQLite Online, built the spreadsheet myself in Google Sheets, and checked the numbers against the required totals (63 orders, INR 346200, 106 units, North 119300 and South 82500, North -22.8%). I am responsible for the correctness of what is submitted.
| 5 | The product mix is the same in both regions | North sells mainly Smart Watch (45000 from 10 units), while South's Smart Watch revenue is 13500 from 3 units. The gap is a Smart Watch gap, so the promotion should target Smart Watch and not all Electronics. ||
