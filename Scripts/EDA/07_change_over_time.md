---
### 07_CHANGE_OVER_TIME: Trend & Seasonality Analysis
---
Purpose: Analyze how measures evolve over time. Helps track trends and identify seasonality in the data

---

### Yearly Performance
---

### Q) Yearly sales performance trends
### Answer:
```SQL
SELECT 
    YEAR(order_date) AS order_year, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_analytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;
```

**Output:**

| order_year | total_sales | total_customers | total_quantity |
|------------|-------------|-----------------|----------------|
| 2010 | 43,419 | 14 | 14 |
| 2011 | 7,075,088 | 2,216 | 2,216 |
| 2012 | 5,842,231 | 3,255 | 3,397 |
| 2013 | 16,344,878 | 17,427 | 52,807 |
| 2014 | 45,642 | 834 | 1,970 |

---

### Monthly Performance
---

### Q) Monthly sales performance trends
### Answer:
```SQL
SELECT 
    YEAR(order_date) AS order_year,
    MONTHNAME(order_date) AS order_month, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_analytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
```

**Output:**

| order_year | order_month | total_sales | total_customers | total_quantity |
|------------|-------------|-------------|-----------------|----------------|
| 2010 | December | 43,419 | 14 | 14 |
| 2011 | January | 469,795 | 144 | 144 |
| 2011 | February | 466,307 | 144 | 144 |
| 2011 | March | 485,165 | 150 | 150 |
| 2011 | April | 502,042 | 157 | 157 |
| 2011 | May | 561,647 | 174 | 174 |
| 2011 | June | 737,793 | 230 | 230 |
| 2011 | July | 596,710 | 188 | 188 |
| 2011 | August | 614,516 | 193 | 193 |
| 2011 | September | 603,047 | 185 | 185 |
| 2011 | October | 708,164 | 221 | 221 |
| 2011 | November | 660,507 | 208 | 208 |
| 2011 | December | 669,395 | 222 | 222 |
| 2012 | January | 495,363 | 252 | 252 |
| 2012 | February | 506,992 | 260 | 260 |
| 2012 | March | 373,478 | 212 | 212 |
| 2012 | April | 400,324 | 219 | 219 |
| 2012 | May | 358,866 | 207 | 207 |
| 2012 | June | 555,142 | 318 | 318 |
| 2012 | July | 444,533 | 246 | 246 |
| 2012 | August | 523,887 | 294 | 294 |
| 2012 | September | 486,149 | 269 | 269 |
| 2012 | October | 535,125 | 313 | 313 |
| 2012 | November | 537,918 | 324 | 324 |
| 2012 | December | 624,454 | 354 | 483 |
| 2013 | January | 857,758 | 627 | 1,677 |
| 2013 | February | 771,218 | 1,373 | 3,454 |
| 2013 | March | 1,049,732 | 1,631 | 4,087 |
| 2013 | April | 1,045,860 | 1,564 | 3,979 |
| 2013 | May | 1,284,456 | 1,719 | 4,400 |
| 2013 | June | 1,642,948 | 1,948 | 5,025 |
| 2013 | July | 1,371,595 | 1,796 | 4,673 |
| 2013 | August | 1,545,910 | 1,898 | 4,848 |
| 2013 | September | 1,447,324 | 1,832 | 4,616 |
| 2013 | October | 1,673,261 | 2,073 | 5,304 |
| 2013 | November | 1,780,688 | 2,036 | 5,224 |
| 2013 | December | 1,874,128 | 2,133 | 5,520 |
| 2014 | January | 45,642 | 834 | 1,970 |

---

### Monthly-Yearly Formatted Performance
---

### Q) Monthly-Yearly formatted performance summary
### Answer:
```SQL
SELECT 
    DATE_FORMAT(order_date, '%M-%Y') AS order_period, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold_analytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%M-%Y')
ORDER BY DATE_FORMAT(order_date, '%M-%Y');
```

**Output:**

| order_period | total_sales | total_customers | total_quantity |
|--------------|-------------|-----------------|----------------|
| April-2011 | 502,042 | 157 | 157 |
| April-2012 | 400,324 | 219 | 219 |
| April-2013 | 1,045,860 | 1,564 | 3,979 |
| August-2011 | 614,516 | 193 | 193 |
| August-2012 | 523,887 | 294 | 294 |
| August-2013 | 1,545,910 | 1,898 | 4,848 |
| December-2010 | 43,419 | 14 | 14 |
| December-2011 | 669,395 | 222 | 222 |
| December-2012 | 624,454 | 354 | 483 |
| December-2013 | 1,874,128 | 2,133 | 5,520 |
| February-2011 | 466,307 | 144 | 144 |
| February-2012 | 506,992 | 260 | 260 |
| February-2013 | 771,218 | 1,373 | 3,454 |
| January-2011 | 469,795 | 144 | 144 |
| January-2012 | 495,363 | 252 | 252 |
| January-2013 | 857,758 | 627 | 1,677 |
| January-2014 | 45,642 | 834 | 1,970 |
| July-2011 | 596,710 | 188 | 188 |
| July-2012 | 444,533 | 246 | 246 |
| July-2013 | 1,371,595 | 1,796 | 4,673 |
| June-2011 | 737,793 | 230 | 230 |
| June-2012 | 555,142 | 318 | 318 |
| June-2013 | 1,642,948 | 1,948 | 5,025 |
| March-2011 | 485,165 | 150 | 150 |
| March-2012 | 373,478 | 212 | 212 |
| March-2013 | 1,049,732 | 1,631 | 4,087 |
| May-2011 | 561,647 | 174 | 174 |
| May-2012 | 358,866 | 207 | 207 |
| May-2013 | 1,284,456 | 1,719 | 4,400 |
| November-2011 | 660,507 | 208 | 208 |
| November-2012 | 537,918 | 324 | 324 |
| November-2013 | 1,780,688 | 2,036 | 5,224 |
| October-2011 | 708,164 | 221 | 221 |
| October-2012 | 535,125 | 313 | 313 |
| October-2013 | 1,673,261 | 2,073 | 5,304 |
| September-2011 | 603,047 | 185 | 185 |
| September-2012 | 486,149 | 269 | 269 |
| September-2013 | 1,447,324 | 1,832 | 4,616 |

---
