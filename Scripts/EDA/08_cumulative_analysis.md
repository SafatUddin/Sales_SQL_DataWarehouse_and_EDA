---
### 08_CUMULATIVE_ANALYSIS: Running Totals & Moving Averages
---
Purpose: Aggregate data progressively over time. Helps understand if the business is growing or declining

---

### Monthly Sales with Running Total & Moving Average
---
### Q) Monthly sales with running total and moving average
### Answer:
```SQL
SELECT 
    order_period,
    total_sales,
    -- Running total of sales over time
    SUM(total_sales) OVER(ORDER BY real_date) AS running_total,
    -- Average price per period
    average_price,
    -- Moving average of price (resets yearly)
    CAST(AVG(average_price) OVER(ORDER BY real_date) AS SIGNED) AS moving_average
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%M-%Y') AS order_period,
        MIN(order_date) AS real_date, 
        SUM(sales_amount) AS total_sales,
        CAST(AVG(price) AS SIGNED) AS average_price
    FROM gold_analytics.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%M-%Y')
) t
ORDER BY real_date;
```

**Output:**

| order_period | total_sales | running_total | average_price | moving_average |
|--------------|-------------|---------------|---------------|----------------|
| December-2010 | 43,419 | 43,419 | 3,101 | 3,101 |
| January-2011 | 469,795 | 513,214 | 3,262 | 3,182 |
| February-2011 | 466,307 | 979,521 | 3,238 | 3,200 |
| March-2011 | 485,165 | 1,464,686 | 3,234 | 3,209 |
| April-2011 | 502,042 | 1,966,728 | 3,198 | 3,207 |
| May-2011 | 561,647 | 2,528,375 | 3,228 | 3,210 |
| June-2011 | 737,793 | 3,266,168 | 3,208 | 3,210 |
| July-2011 | 596,710 | 3,862,878 | 3,174 | 3,205 |
| August-2011 | 614,516 | 4,477,394 | 3,184 | 3,203 |
| September-2011 | 603,047 | 5,080,441 | 3,260 | 3,209 |
| October-2011 | 708,164 | 5,788,605 | 3,204 | 3,208 |
| November-2011 | 660,507 | 6,449,112 | 3,176 | 3,206 |
| December-2011 | 669,395 | 7,118,507 | 3,015 | 3,191 |
| January-2012 | 495,363 | 7,613,870 | 1,966 | 3,103 |
| February-2012 | 506,992 | 8,120,862 | 1,950 | 3,027 |
| March-2012 | 373,478 | 8,494,340 | 1,762 | 2,948 |
| April-2012 | 400,324 | 8,894,664 | 1,828 | 2,882 |
| May-2012 | 358,866 | 9,253,530 | 1,734 | 2,818 |
| June-2012 | 555,142 | 9,808,672 | 1,746 | 2,761 |
| July-2012 | 444,533 | 10,253,205 | 1,807 | 2,714 |
| August-2012 | 523,887 | 10,777,092 | 1,782 | 2,669 |
| September-2012 | 486,149 | 11,263,241 | 1,807 | 2,630 |
| October-2012 | 535,125 | 11,798,366 | 1,710 | 2,590 |
| November-2012 | 537,918 | 12,336,284 | 1,660 | 2,551 |
| December-2012 | 624,454 | 12,960,738 | 1,293 | 2,501 |
| January-2013 | 857,758 | 13,818,496 | 516 | 2,425 |
| February-2013 | 771,218 | 14,589,714 | 223 | 2,343 |
| March-2013 | 1,049,732 | 15,639,446 | 257 | 2,269 |
| April-2013 | 1,045,860 | 16,685,306 | 263 | 2,200 |
| May-2013 | 1,284,456 | 17,969,762 | 292 | 2,136 |
| June-2013 | 1,642,948 | 19,612,710 | 327 | 2,078 |
| July-2013 | 1,371,595 | 20,984,305 | 294 | 2,022 |
| August-2013 | 1,545,910 | 22,530,215 | 319 | 1,970 |
| September-2013 | 1,447,324 | 23,977,539 | 314 | 1,922 |
| October-2013 | 1,673,261 | 25,650,800 | 316 | 1,876 |
| November-2013 | 1,780,688 | 27,431,488 | 341 | 1,833 |
| December-2013 | 1,874,128 | 29,305,616 | 340 | 1,793 |
| January-2014 | 45,642 | 29,351,258 | 23 | 1,746 |

---

### Alternative: Running Total Partitioned by Year
---

### Q) Running total and moving average partitioned by year
### Answer:
```SQL
SELECT 
    order_period,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY YEAR(real_date) ORDER BY real_date) AS running_total_yearly,
    average_price,
    CAST(AVG(average_price) OVER(PARTITION BY YEAR(real_date) ORDER BY real_date) AS SIGNED) AS moving_average_yearly
FROM (
    SELECT 
        DATE_FORMAT(order_date, '%M-%Y') AS order_period,
        MIN(order_date) AS real_date, 
        SUM(sales_amount) AS total_sales,
        CAST(AVG(price) AS SIGNED) AS average_price
    FROM gold_analytics.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%M-%Y')
) t
ORDER BY real_date;
```

**Output:**

| order_period | total_sales | running_total_yearly | average_price | moving_average_yearly |
|--------------|-------------|----------------------|---------------|-----------------------|
| December-2010 | 43,419 | 43,419 | 3,101 | 3,101 |
| January-2011 | 469,795 | 469,795 | 3,262 | 3,262 |
| February-2011 | 466,307 | 936,102 | 3,238 | 3,250 |
| March-2011 | 485,165 | 1,421,267 | 3,234 | 3,245 |
| April-2011 | 502,042 | 1,923,309 | 3,198 | 3,233 |
| May-2011 | 561,647 | 2,484,956 | 3,228 | 3,232 |
| June-2011 | 737,793 | 3,222,749 | 3,208 | 3,228 |
| July-2011 | 596,710 | 3,819,459 | 3,174 | 3,220 |
| August-2011 | 614,516 | 4,433,975 | 3,184 | 3,216 |
| September-2011 | 603,047 | 5,037,022 | 3,260 | 3,221 |
| October-2011 | 708,164 | 5,745,186 | 3,204 | 3,219 |
| November-2011 | 660,507 | 6,405,693 | 3,176 | 3,215 |
| December-2011 | 669,395 | 7,075,088 | 3,015 | 3,198 |
| January-2012 | 495,363 | 495,363 | 1,966 | 1,966 |
| February-2012 | 506,992 | 1,002,355 | 1,950 | 1,958 |
| March-2012 | 373,478 | 1,375,833 | 1,762 | 1,893 |
| April-2012 | 400,324 | 1,776,157 | 1,828 | 1,877 |
| May-2012 | 358,866 | 2,135,023 | 1,734 | 1,848 |
| June-2012 | 555,142 | 2,690,165 | 1,746 | 1,831 |
| July-2012 | 444,533 | 3,134,698 | 1,807 | 1,828 |
| August-2012 | 523,887 | 3,658,585 | 1,782 | 1,822 |
| September-2012 | 486,149 | 4,144,734 | 1,807 | 1,820 |
| October-2012 | 535,125 | 4,679,859 | 1,710 | 1,809 |
| November-2012 | 537,918 | 5,217,777 | 1,660 | 1,796 |
| December-2012 | 624,454 | 5,842,231 | 1,293 | 1,754 |
| January-2013 | 857,758 | 857,758 | 516 | 516 |
| February-2013 | 771,218 | 1,628,976 | 223 | 370 |
| March-2013 | 1,049,732 | 2,678,708 | 257 | 332 |
| April-2013 | 1,045,860 | 3,724,568 | 263 | 315 |
| May-2013 | 1,284,456 | 5,009,024 | 292 | 310 |
| June-2013 | 1,642,948 | 6,651,972 | 327 | 313 |
| July-2013 | 1,371,595 | 8,023,567 | 294 | 310 |
| August-2013 | 1,545,910 | 9,569,477 | 319 | 311 |
| September-2013 | 1,447,324 | 11,016,801 | 314 | 312 |
| October-2013 | 1,673,261 | 12,690,062 | 316 | 312 |
| November-2013 | 1,780,688 | 14,470,750 | 341 | 315 |
| December-2013 | 1,874,128 | 16,344,878 | 340 | 317 |
| January-2014 | 45,642 | 45,642 | 23 | 23 |

---
