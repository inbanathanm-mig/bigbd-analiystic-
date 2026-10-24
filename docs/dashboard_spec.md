# Dashboard specification (Part C)

## 1. Data source

Connect Tableau Public to `data/orders_clean.csv` (13 columns, 63 completed orders).

| # | Column | Classification |
|---|---|---|
| 1 | order_id | Dimension |
| 2 | order_month | Dimension |
| 3 | clean_first_name | Dimension |
| 4 | clean_last_name | Dimension |
| 5 | region | Dimension |
| 6 | rep_name | Dimension |
| 7 | item | Dimension |
| 8 | category | Dimension |
| 9 | unit_price | Measure |
| 10 | quantity | Measure |
| 11 | amount | Measure |
| 12 | revenue_calc | Measure |
| 13 | status | Dimension |

That is 9 Dimensions and 4 Measures. order_id is an identifier, so it is a Dimension. order_month stays a text dimension such as 2026-09.

## 2. KPI cards

| KPI card | Definition | Value shown |
|---|---|---|
| Total Revenue | SUM(amount) | INR 346200 |
| Total Units Sold | SUM(quantity) | 106 units |

The Total Revenue card equals Part A's q05 total_revenue (346200), because both use completed orders only.

## 3. Chart sheets

### 3.1 Revenue by Region (bar chart)

- Chart type: horizontal bar chart.
- Rows shelf: region.
- Columns shelf: SUM(amount).
- Colour shelf: none (one colour for all bars). Sort the bars from largest to smallest.
- Why this chart: a bar chart makes it easy to compare the lengths of a few separate categories, such as four regions.

| region | Revenue (INR) |
|---|---|
| North | 119300 |
| South | 82500 |
| West | 74900 |
| East | 69500 |
| Total | 346200 |

### 3.2 Revenue by Category (bar chart)

- Chart type: bar chart.
- Rows shelf: category.
- Columns shelf: SUM(amount).
- Colour shelf: category (the same colours are used in the trend chart).
- Why this chart: three categories are compared on one measure, and bar length shows the gap clearly.

| category | Revenue (INR) |
|---|---|
| Electronics | 142300 |
| Home | 126400 |
| Apparel | 77500 |
| Total | 346200 |

### 3.3 Revenue Trend by Month and Category (line chart)

- Chart type: line chart, one line per category.
- Columns shelf: order_month (discrete).
- Rows shelf: SUM(amount).
- Colour shelf: category.
- Why this chart: a line connects values in time order, so a rise or fall between months is easy to see.

| order_month | Apparel | Electronics | Home | Month total |
|---|---|---|---|---|
| 2026-09 | 24700 | 43000 | 30600 | 98300 |
| 2026-10 | 30600 | 49900 | 12600 | 93100 |
| 2026-11 | 22200 | 49400 | 83200 | 154800 |
| Total | 77500 | 142300 | 126400 | 346200 |

### 3.4 Region x Category Detail (text table)

- Chart type: text table (crosstab).
- Rows shelf: category.
- Columns shelf: region.
- Text (label) shelf: SUM(amount). Colour shelf: none.
- Why this chart: the manager needs the exact value for each region and category pair, and a text table shows exact numbers.

| category | East | North | South | West | Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Total | 69500 | 119300 | 82500 | 74900 | 346200 |

## 4. Dashboard layout

Placement from top to bottom:

1. KPI cards (Total Revenue and Total Units Sold), side by side.
2. Category filter, in the top band directly below the KPI cards.
3. Revenue Trend by Month and Category (line chart), full width.
4. Comparison charts: Revenue by Region and Revenue by Category, side by side.
5. Region x Category Detail (text table), full width.

Containers:

- One vertical container holds the whole dashboard.
- One horizontal container at the top holds the two KPI cards.
- The Category filter sits in its own horizontal container below the KPI row.
- One horizontal container holds the two comparison charts side by side.
- The trend chart and the detail table each sit directly in the vertical container.

Category filter: add the category field as a filter on one worksheet, then choose Apply to Worksheets > All Using This Data Source, so it applies to all four worksheets. Show it as a multiple-values (dropdown) list in the top band.

Use as Filter: when a user clicks a bar in Revenue by Region with Use as Filter switched on, the other charts and the detail table keep only that region's data, so the trend, the category chart and the text table all show that region alone. Clicking the same bar again clears the filter.

## 5. Narrative

### 5.1 Visualization summary

The dashboard shows INR 346200 of completed revenue from 106 units across four regions, three categories and three months (2026-09 to 2026-11). The KPI cards give the totals, the region and category bars show who earns the most, the line chart shows how each category moves by month, and the text table gives exact values for every region and category pair.

### 5.2 Summary analysis

1. **Region comparison.** North is the strongest region with INR 119300 (34.5% of revenue), while East is the weakest with INR 69500. North earns INR 49800 more than East.
2. **Category comparison.** Electronics leads with INR 142300 (41.1% of revenue), and North alone contributes INR 73400 of it, while West contributes only INR 18800 and South INR 28700.
3. **Change across months, Home.** Home revenue fell from INR 30600 in 2026-09 to INR 12600 in 2026-10 (down 58.8%), then jumped to INR 83200 in 2026-11.
4. **Change across months, total.** Total revenue went from INR 93100 in 2026-10 to INR 154800 in 2026-11, an increase of 66.3%, driven mainly by Home.
5. **Change across months, North.** North revenue fell from INR 53500 in 2026-09 to INR 41300 in 2026-10, a drop of 22.8%.

### 5.3 Recommendations

1. **South, Electronics: promotional push.** South earns only INR 28700 from Electronics, against INR 73400 in North. Run an Electronics offer in South (smart watches and earbuds) during the next sale cycle. Metric to watch: South Electronics revenue per month, compared with INR 28700.
2. **North, all categories: win-back push.** North revenue fell every month, from INR 53500 to INR 41300 to INR 24500 (2026-09 to 2026-11). Send a targeted offer to North customers who bought earlier in the sale. Metric to watch: North monthly revenue and number of buying customers, compared with the INR 24500 base.
3. **Home category: stock decision.** Home revenue reached INR 83200 in 2026-11, and Air Fryer alone earned INR 104000 over the sale. Increase Air Fryer stock before the next peak month, mainly for South (Home INR 43800) and East (Home INR 37500). Metric to watch: Air Fryer units sold and any days out of stock.

## 6. Reconciliation

| Figure | Value (INR) |
|---|---|
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region | 346200 |
| Sum of Revenue by Category | 346200 |
| Part B pivot grand total | 346200 |

All four values are equal.
