---
### 12_REPORTS: Consolidated Business Reports
---
Purpose: Create comprehensive views for business stakeholders

---

#### CUSTOMER REPORT

#### Purpose: Consolidates key customer metrics and behaviors

**Highlights:**
- Essential fields: names, ages, transaction details
- Segments customers into VIP, Regular, New categories
- Aggregates: total orders, sales, quantity, products, lifespan
- KPIs: recency, average order value, average monthly spend

---
### Q) Create Customer Report View
### Answer:
```SQL
DROP VIEW IF EXISTS gold_analytics.customer_report;
CREATE VIEW gold_analytics.customer_report AS (
    WITH customer_metrics AS (
        SELECT 
            C.customer_key,
            C.customer_number,
            CONCAT(COALESCE(C.first_name, ''), ' ', COALESCE(C.last_name, '')) AS customer_name,
            C.birthdate,
            TIMESTAMPDIFF(YEAR, C.birthdate, NOW()) AS age,
            COUNT(DISTINCT S.order_number) AS total_orders,
            SUM(S.sales_amount) AS total_sales,
            SUM(S.quantity) AS total_quantity_purchased,
            COUNT(DISTINCT S.product_key) AS total_products,
            TIMESTAMPDIFF(MONTH, MIN(S.order_date), MAX(S.order_date)) AS lifespan,
            TIMESTAMPDIFF(MONTH, MAX(S.order_date), NOW()) AS recency
        FROM gold_analytics.dim_customers C
        LEFT JOIN gold_analytics.fact_sales S
            ON C.customer_key = S.customer_key
        WHERE S.order_date IS NOT NULL
        GROUP BY C.customer_key, C.customer_number, C.first_name, C.last_name, C.birthdate
    )
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        -- Age grouping
        CASE 
            WHEN age < 25 THEN 'Below 25'
            WHEN age BETWEEN 25 AND 39 THEN '25-39'
            WHEN age BETWEEN 40 AND 59 THEN '40-59'
            ELSE 'Above 60'
        END AS age_group,
        -- Customer ranking based on value
        CASE 
            WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_rank,
        total_orders,
        total_sales,
        total_quantity_purchased,
        total_products,
        CONCAT(lifespan, ' months') AS lifespan,
        CONCAT(recency, ' months') AS recency,
        -- Average Order Value (AOV)
        CASE 
            WHEN total_orders = 0 THEN 0
            ELSE ROUND((total_sales / total_orders), 2) 
        END AS average_order_value,
        -- Average Monthly Spend
        CASE 
            WHEN lifespan = 0 THEN total_sales
            ELSE ROUND((total_sales / lifespan), 2) 
        END AS average_monthly_spend
    FROM customer_metrics
    ORDER BY customer_key
);

-- Preview Product Report
SELECT * FROM gold_analytics.product_report;
```

**Output:**

| product_key | product_number | product_name | category | subcategory | cost | sales_performance | total_orders | total_sales | total_quantity_sold | total_customers | lifespan | recency | average_order_revenue | average_monthly_revenue |
|-------------|----------------|--------------|----------|-------------|------|-------------------|--------------|-------------|---------------------|-----------------|----------|---------|----------------------|-------------------------|
| 3 | BK-M82B-38 | Mountain-100 Black- 38 | Bikes | Mountain Bikes | 1,898 | High Performer | 49 | 165,375 | 49 | 49 | 11 | 174 | 3,375.00 | 15,034.09 |
| 4 | BK-M82B-42 | Mountain-100 Black- 42 | Bikes | Mountain Bikes | 1,898 | High Performer | 45 | 151,875 | 45 | 45 | 11 | 174 | 3,375.00 | 13,806.82 |
| 5 | BK-M82B-44 | Mountain-100 Black- 44 | Bikes | Mountain Bikes | 1,898 | High Performer | 60 | 202,500 | 60 | 60 | 11 | 175 | 3,375.00 | 18,409.09 |
| 6 | BK-M82B-48 | Mountain-100 Black- 48 | Bikes | Mountain Bikes | 1,898 | High Performer | 57 | 192,375 | 57 | 57 | 11 | 174 | 3,375.00 | 17,488.64 |
| 7 | BK-M82S-38 | Mountain-100 Silver- 38 | Bikes | Mountain Bikes | 1,912 | High Performer | 58 | 197,200 | 58 | 58 | 11 | 175 | 3,400.00 | 17,927.27 |
| 8 | BK-M82S-42 | Mountain-100 Silver- 42 | Bikes | Mountain Bikes | 1,912 | High Performer | 42 | 142,800 | 42 | 42 | 11 | 174 | 3,400.00 | 12,981.82 |
| 9 | BK-M82S-44 | Mountain-100 Silver- 44 | Bikes | Mountain Bikes | 1,912 | High Performer | 49 | 166,600 | 49 | 49 | 11 | 175 | 3,400.00 | 15,145.45 |
| 10 | BK-M82S-48 | Mountain-100 Silver- 48 | Bikes | Mountain Bikes | 1,912 | High Performer | 36 | 122,400 | 36 | 36 | 11 | 174 | 3,400.00 | 11,127.27 |
| 16 | BK-R93R-44 | Road-150 Red- 44 | Bikes | Road Bikes | 2,171 | High Performer | 281 | 1,005,418 | 281 | 281 | 11 | 174 | 3,578.00 | 91,401.64 |
| 17 | BK-R93R-48 | Road-150 Red- 48 | Bikes | Road Bikes | 2,171 | High Performer | 337 | 1,205,786 | 337 | 337 | 11 | 174 | 3,578.00 | 109,616.91 |
| 18 | BK-R93R-52 | Road-150 Red- 52 | Bikes | Road Bikes | 2,171 | High Performer | 302 | 1,080,556 | 302 | 302 | 11 | 174 | 3,578.00 | 98,232.36 |
| 19 | BK-R93R-56 | Road-150 Red- 56 | Bikes | Road Bikes | 2,171 | High Performer | 295 | 1,055,510 | 295 | 295 | 11 | 174 | 3,578.00 | 95,955.45 |
| 20 | BK-R93R-62 | Road-150 Red- 62 | Bikes | Road Bikes | 2,171 | High Performer | 336 | 1,202,208 | 336 | 336 | 11 | 174 | 3,578.00 | 109,291.64 |
| 36 | BK-R50B-44 | Road-650 Black- 44 | Bikes | Road Bikes | 487 | Mid Range | 63 | 47,565 | 63 | 63 | 23 | 162 | 755.00 | 2,068.04 |
| 37 | BK-R50B-48 | Road-650 Black- 48 | Bikes | Road Bikes | 487 | Mid Range | 60 | 45,552 | 60 | 60 | 20 | 162 | 759.20 | 2,277.60 |
| 38 | BK-R50B-52 | Road-650 Black- 52 | Bikes | Road Bikes | 487 | High Performer | 89 | 66,915 | 89 | 89 | 22 | 163 | 751.85 | 3,041.59 |
| 39 | BK-R50B-58 | Road-650 Black- 58 | Bikes | Road Bikes | 487 | High Performer | 76 | 57,996 | 76 | 76 | 23 | 163 | 763.11 | 2,521.57 |
| 40 | BK-R50B-60 | Road-650 Black- 60 | Bikes | Road Bikes | 487 | High Performer | 76 | 57,156 | 76 | 76 | 22 | 163 | 752.05 | 2,598.00 |
| 41 | BK-R50B-62 | Road-650 Black- 62 | Bikes | Road Bikes | 487 | Mid Range | 65 | 49,047 | 65 | 65 | 23 | 163 | 754.57 | 2,132.48 |
| 42 | BK-R50R-44 | Road-650 Red- 44 | Bikes | Road Bikes | 487 | High Performer | 72 | 54,528 | 72 | 72 | 23 | 162 | 757.33 | 2,370.78 |
| 43 | BK-R50R-48 | Road-650 Red- 48 | Bikes | Road Bikes | 487 | High Performer | 88 | 66,720 | 88 | 88 | 23 | 162 | 758.18 | 2,900.87 |
| 44 | BK-R50R-52 | Road-650 Red- 52 | Bikes | Road Bikes | 487 | Mid Range | 61 | 46,083 | 61 | 61 | 23 | 163 | 755.46 | 2,003.61 |
| 45 | BK-R50R-58 | Road-650 Red- 58 | Bikes | Road Bikes | 487 | High Performer | 74 | 56,346 | 74 | 74 | 22 | 163 | 761.43 | 2,561.18 |
| 46 | BK-R50R-60 | Road-650 Red- 60 | Bikes | Road Bikes | 487 | Mid Range | 53 | 40,071 | 53 | 53 | 22 | 162 | 756.06 | 1,821.41 |
| 47 | BK-R50R-62 | Road-650 Red- 62 | Bikes | Road Bikes | 487 | High Performer | 75 | 57,381 | 75 | 75 | 22 | 163 | 765.08 | 2,608.23 |
| 48 | BK-R89R-44 | Road-250 Red- 44 | Bikes | Road Bikes | 1,519 | High Performer | 144 | 351,792 | 144 | 144 | 11 | 162 | 2,443.00 | 31,981.09 |
| 49 | BK-R89R-48 | Road-250 Red- 48 | Bikes | Road Bikes | 1,519 | High Performer | 162 | 395,766 | 162 | 162 | 11 | 162 | 2,443.00 | 35,978.73 |
| 50 | BK-R89R-52 | Road-250 Red- 52 | Bikes | Road Bikes | 1,519 | High Performer | 133 | 324,919 | 133 | 133 | 11 | 162 | 2,443.00 | 29,538.09 |
| 104 | BC-M005 | Mountain Bottle Cage | Accessories | Bottles and Cages | 4 | Mid Range | 2,025 | 20,340 | 2,034 | 2,004 | 13 | 149 | 10.04 | 1,564.62 |
| 105 | BC-R205 | Road Bottle Cage | Accessories | Bottles and Cages | 3 | Mid Range | 1,712 | 15,408 | 1,712 | 1,700 | 12 | 149 | 9.00 | 1,284.00 |
| 106 | BK-M18B-40 | Mountain-500 Black- 40 | Bikes | Mountain Bikes | 295 | Mid Range | 48 | 25,920 | 48 | 48 | 11 | 151 | 540.00 | 2,356.36 |
| 107 | BK-M18B-42 | Mountain-500 Black- 42 | Bikes | Mountain Bikes | 295 | Mid Range | 49 | 26,460 | 49 | 49 | 11 | 150 | 540.00 | 2,405.45 |
| 108 | BK-M18B-44 | Mountain-500 Black- 44 | Bikes | Mountain Bikes | 295 | Mid Range | 58 | 31,320 | 58 | 58 | 11 | 150 | 540.00 | 2,847.27 |
| 109 | BK-M18B-48 | Mountain-500 Black- 48 | Bikes | Mountain Bikes | 295 | Mid Range | 56 | 30,240 | 56 | 56 | 11 | 150 | 540.00 | 2,749.09 |
| 110 | BK-M18B-52 | Mountain-500 Black- 52 | Bikes | Mountain Bikes | 295 | Mid Range | 41 | 22,140 | 41 | 41 | 11 | 150 | 540.00 | 2,012.73 |
| 111 | BK-M18S-40 | Mountain-500 Silver- 40 | Bikes | Mountain Bikes | 308 | Mid Range | 45 | 25,425 | 45 | 45 | 11 | 150 | 565.00 | 2,311.36 |
| 112 | BK-M18S-42 | Mountain-500 Silver- 42 | Bikes | Mountain Bikes | 308 | Mid Range | 45 | 25,425 | 45 | 45 | 11 | 150 | 565.00 | 2,311.36 |
| 113 | BK-M18S-44 | Mountain-500 Silver- 44 | Bikes | Mountain Bikes | 308 | Mid Range | 39 | 22,035 | 39 | 39 | 11 | 150 | 565.00 | 2,003.18 |
| 114 | BK-M18S-48 | Mountain-500 Silver- 48 | Bikes | Mountain Bikes | 308 | Mid Range | 50 | 28,250 | 50 | 50 | 11 | 150 | 565.00 | 2,568.18 |
| 115 | BK-M18S-52 | Mountain-500 Silver- 52 | Bikes | Mountain Bikes | 308 | Mid Range | 48 | 27,120 | 48 | 48 | 11 | 150 | 565.00 | 2,465.45 |
| 116 | BK-M38S-38 | Mountain-400-W Silver- 38 | Bikes | Mountain Bikes | 420 | High Performer | 148 | 113,812 | 148 | 148 | 11 | 150 | 769.00 | 10,346.55 |
| 117 | BK-M38S-40 | Mountain-400-W Silver- 40 | Bikes | Mountain Bikes | 420 | High Performer | 128 | 98,432 | 128 | 128 | 11 | 150 | 769.00 | 8,948.36 |
| 118 | BK-M38S-42 | Mountain-400-W Silver- 42 | Bikes | Mountain Bikes | 420 | High Performer | 129 | 99,201 | 129 | 129 | 11 | 150 | 769.00 | 9,018.27 |
| 119 | BK-M38S-46 | Mountain-400-W Silver- 46 | Bikes | Mountain Bikes | 420 | High Performer | 138 | 106,122 | 138 | 138 | 11 | 150 | 769.00 | 9,647.45 |
| 120 | BK-M68B-38 | Mountain-200 Black- 38 | Bikes | Mountain Bikes | 1,252 | High Performer | 582 | 1,294,854 | 582 | 565 | 23 | 150 | 2,224.84 | 56,298.00 |
| 121 | BK-M68B-42 | Mountain-200 Black- 42 | Bikes | Mountain Bikes | 1,252 | High Performer | 614 | 1,363,128 | 614 | 604 | 23 | 150 | 2,220.08 | 59,266.43 |
| 122 | BK-M68B-46 | Mountain-200 Black- 46 | Bikes | Mountain Bikes | 1,252 | High Performer | 620 | 1,373,454 | 620 | 600 | 23 | 150 | 2,215.25 | 59,715.39 |
| 123 | BK-M68S-38 | Mountain-200 Silver- 38 | Bikes | Mountain Bikes | 1,266 | High Performer | 596 | 1,339,394 | 596 | 583 | 23 | 150 | 2,247.31 | 58,234.52 |
| 124 | BK-M68S-42 | Mountain-200 Silver- 42 | Bikes | Mountain Bikes | 1,266 | High Performer | 560 | 1,257,368 | 560 | 547 | 23 | 150 | 2,245.30 | 54,668.17 |
| 125 | BK-M68S-46 | Mountain-200 Silver- 46 | Bikes | Mountain Bikes | 1,266 | High Performer | 580 | 1,301,029 | 580 | 567 | 23 | 150 | 2,243.15 | 56,566.48 |
| 126 | BK-R19B-44 | Road-750 Black- 44 | Bikes | Road Bikes | 344 | High Performer | 360 | 194,400 | 360 | 360 | 11 | 150 | 540.00 | 17,672.73 |
| 127 | BK-R19B-48 | Road-750 Black- 48 | Bikes | Road Bikes | 344 | High Performer | 363 | 196,020 | 363 | 363 | 11 | 150 | 540.00 | 17,820.00 |
| 128 | BK-R19B-52 | Road-750 Black- 52 | Bikes | Road Bikes | 344 | High Performer | 386 | 208,440 | 386 | 386 | 12 | 150 | 540.00 | 17,370.00 |
| 129 | BK-R19B-58 | Road-750 Black- 58 | Bikes | Road Bikes | 344 | High Performer | 334 | 180,360 | 334 | 334 | 11 | 150 | 540.00 | 16,396.36 |
| 130 | BK-R64Y-38 | Road-550-W Yellow- 38 | Bikes | Road Bikes | 713 | High Performer | 270 | 293,760 | 270 | 267 | 23 | 150 | 1,088.00 | 12,772.17 |
| 131 | BK-R64Y-40 | Road-550-W Yellow- 40 | Bikes | Road Bikes | 713 | High Performer | 266 | 289,880 | 266 | 264 | 23 | 150 | 1,089.77 | 12,603.48 |
| 132 | BK-R64Y-42 | Road-550-W Yellow- 42 | Bikes | Road Bikes | 713 | High Performer | 306 | 334,440 | 306 | 303 | 23 | 150 | 1,092.94 | 14,540.87 |
| 133 | BK-R64Y-44 | Road-550-W Yellow- 44 | Bikes | Road Bikes | 713 | High Performer | 287 | 312,200 | 287 | 286 | 23 | 150 | 1,087.80 | 13,573.91 |
| 134 | BK-R64Y-48 | Road-550-W Yellow- 48 | Bikes | Road Bikes | 713 | High Performer | 261 | 283,680 | 261 | 258 | 22 | 150 | 1,086.90 | 12,894.55 |
| 135 | BK-R79Y-40 | Road-350-W Yellow- 40 | Bikes | Road Bikes | 1,083 | High Performer | 246 | 418,446 | 246 | 246 | 11 | 150 | 1,701.00 | 38,040.55 |
| 136 | BK-R79Y-42 | Road-350-W Yellow- 42 | Bikes | Road Bikes | 1,083 | High Performer | 235 | 399,735 | 235 | 235 | 11 | 150 | 1,701.00 | 36,339.55 |
| 137 | BK-R79Y-44 | Road-350-W Yellow- 44 | Bikes | Road Bikes | 1,083 | High Performer | 216 | 367,416 | 216 | 216 | 11 | 150 | 1,701.00 | 33,401.45 |
| 138 | BK-R79Y-48 | Road-350-W Yellow- 48 | Bikes | Road Bikes | 1,083 | High Performer | 232 | 394,632 | 232 | 232 | 11 | 150 | 1,701.00 | 35,875.64 |
| 139 | BK-R89B-44 | Road-250 Black- 44 | Bikes | Road Bikes | 1,555 | High Performer | 271 | 628,384 | 271 | 266 | 23 | 150 | 2,318.76 | 27,321.04 |
| 140 | BK-R89B-48 | Road-250 Black- 48 | Bikes | Road Bikes | 1,555 | High Performer | 298 | 691,213 | 298 | 289 | 23 | 150 | 2,319.51 | 30,052.74 |
| 141 | BK-R89B-52 | Road-250 Black- 52 | Bikes | Road Bikes | 1,555 | High Performer | 319 | 734,425 | 319 | 312 | 23 | 150 | 2,302.27 | 31,931.52 |
| 142 | BK-R89B-58 | Road-250 Black- 58 | Bikes | Road Bikes | 1,555 | High Performer | 270 | 622,026 | 270 | 265 | 23 | 150 | 2,303.80 | 27,044.61 |
| 143 | BK-R89R-58 | Road-250 Red- 58 | Bikes | Road Bikes | 1,555 | High Performer | 306 | 702,666 | 306 | 301 | 23 | 150 | 2,296.29 | 30,550.70 |
| 144 | BK-T18U-44 | Touring-3000 Blue- 44 | Bikes | Touring Bikes | 461 | Mid Range | 53 | 39,326 | 53 | 53 | 11 | 150 | 742.00 | 3,575.09 |
| 145 | BK-T18U-50 | Touring-3000 Blue- 50 | Bikes | Touring Bikes | 461 | Mid Range | 48 | 35,616 | 48 | 48 | 11 | 150 | 742.00 | 3,237.82 |
| 146 | BK-T18U-54 | Touring-3000 Blue- 54 | Bikes | Touring Bikes | 461 | Mid Range | 55 | 40,810 | 55 | 55 | 11 | 151 | 742.00 | 3,710.00 |
| 147 | BK-T18U-58 | Touring-3000 Blue- 58 | Bikes | Touring Bikes | 461 | Mid Range | 57 | 42,294 | 57 | 57 | 11 | 150 | 742.00 | 3,844.91 |
| 148 | BK-T18U-62 | Touring-3000 Blue- 62 | Bikes | Touring Bikes | 461 | Mid Range | 64 | 47,488 | 64 | 64 | 10 | 150 | 742.00 | 4,748.80 |
| 149 | BK-T18Y-44 | Touring-3000 Yellow- 44 | Bikes | Touring Bikes | 461 | Mid Range | 59 | 43,778 | 59 | 59 | 10 | 150 | 742.00 | 4,377.80 |
| 150 | BK-T18Y-50 | Touring-3000 Yellow- 50 | Bikes | Touring Bikes | 461 | Mid Range | 59 | 43,778 | 59 | 59 | 11 | 150 | 742.00 | 3,979.82 |
| 151 | BK-T18Y-54 | Touring-3000 Yellow- 54 | Bikes | Touring Bikes | 461 | Mid Range | 48 | 35,616 | 48 | 48 | 10 | 151 | 742.00 | 3,561.60 |
| 152 | BK-T18Y-58 | Touring-3000 Yellow- 58 | Bikes | Touring Bikes | 461 | Mid Range | 47 | 34,874 | 47 | 47 | 11 | 150 | 742.00 | 3,170.36 |
| 153 | BK-T18Y-62 | Touring-3000 Yellow- 62 | Bikes | Touring Bikes | 461 | Mid Range | 50 | 37,100 | 50 | 50 | 11 | 150 | 742.00 | 3,372.73 |
| 154 | BK-T44U-46 | Touring-2000 Blue- 46 | Bikes | Touring Bikes | 755 | High Performer | 97 | 117,855 | 97 | 97 | 11 | 150 | 1,215.00 | 10,714.09 |
| 155 | BK-T44U-50 | Touring-2000 Blue- 50 | Bikes | Touring Bikes | 755 | High Performer | 106 | 128,790 | 106 | 106 | 11 | 150 | 1,215.00 | 11,708.18 |
| 156 | BK-T44U-54 | Touring-2000 Blue- 54 | Bikes | Touring Bikes | 755 | High Performer | 88 | 106,920 | 88 | 88 | 11 | 150 | 1,215.00 | 9,720.00 |
| 157 | BK-T44U-60 | Touring-2000 Blue- 60 | Bikes | Touring Bikes | 755 | High Performer | 81 | 98,415 | 81 | 81 | 11 | 150 | 1,215.00 | 8,946.82 |
| 158 | BK-T79U-46 | Touring-1000 Blue- 46 | Bikes | Touring Bikes | 1,482 | High Performer | 177 | 421,968 | 177 | 177 | 11 | 150 | 2,384.00 | 38,360.73 |
| 159 | BK-T79U-50 | Touring-1000 Blue- 50 | Bikes | Touring Bikes | 1,482 | High Performer | 150 | 357,600 | 150 | 150 | 11 | 150 | 2,384.00 | 32,509.09 |
| 160 | BK-T79U-54 | Touring-1000 Blue- 54 | Bikes | Touring Bikes | 1,482 | High Performer | 160 | 381,440 | 160 | 160 | 11 | 150 | 2,384.00 | 34,676.36 |
| 161 | BK-T79U-60 | Touring-1000 Blue- 60 | Bikes | Touring Bikes | 1,482 | High Performer | 147 | 350,448 | 147 | 147 | 11 | 150 | 2,384.00 | 31,858.91 |
| 162 | BK-T79Y-46 | Touring-1000 Yellow- 46 | Bikes | Touring Bikes | 1,482 | High Performer | 172 | 410,048 | 172 | 170 | 11 | 150 | 2,384.00 | 37,277.09 |
| 163 | BK-T79Y-50 | Touring-1000 Yellow- 50 | Bikes | Touring Bikes | 1,482 | High Performer | 151 | 359,984 | 151 | 150 | 11 | 150 | 2,384.00 | 32,725.82 |
| 164 | BK-T79Y-54 | Touring-1000 Yellow- 54 | Bikes | Touring Bikes | 1,482 | High Performer | 158 | 376,672 | 158 | 158 | 11 | 150 | 2,384.00 | 34,242.91 |
| 165 | BK-T79Y-60 | Touring-1000 Yellow- 60 | Bikes | Touring Bikes | 1,482 | High Performer | 140 | 333,760 | 140 | 140 | 11 | 150 | 2,384.00 | 30,341.82 |
| 166 | CA-1098 | AWC Logo Cap | Clothing | Caps | 7 | Mid Range | 2,190 | 19,710 | 2,190 | 2,132 | 12 | 149 | 9.00 | 1,642.50 |
| 168 | CL-9009 | Bike Wash - Dissolver | Accessories | Cleaners | 3 | Low Performer | 908 | 7,272 | 909 | 875 | 12 | 149 | 8.01 | 606.00 |
| 174 | FE-6654 | Fender Set - Mountain | Accessories | Fenders | 8 | Mid Range | 2,121 | 46,662 | 2,121 | 2,110 | 12 | 149 | 22.00 | 3,888.50 |
| 233 | GL-H102-L | Half-Finger Gloves- L | Clothing | Gloves | 9 | Mid Range | 443 | 10,632 | 443 | 437 | 12 | 149 | 24.00 | 886.00 |
| 234 | GL-H102-M | Half-Finger Gloves- M | Clothing | Gloves | 9 | Mid Range | 499 | 11,976 | 499 | 488 | 12 | 149 | 24.00 | 998.00 |
| 235 | GL-H102-S | Half-Finger Gloves- S | Clothing | Gloves | 9 | Mid Range | 488 | 11,712 | 488 | 479 | 12 | 149 | 24.00 | 976.00 |
| 244 | HL-U509 | Sport-100 Helmet- Black | Accessories | Helmets | 13 | High Performer | 2,085 | 72,975 | 2,085 | 2,024 | 13 | 149 | 35.00 | 5,613.46 |
| 245 | HL-U509-B | Sport-100 Helmet- Blue | Accessories | Helmets | 13 | High Performer | 2,125 | 74,410 | 2,126 | 2,050 | 13 | 149 | 35.02 | 5,723.85 |
| 246 | HL-U509-R | Sport-100 Helmet- Red | Accessories | Helmets | 13 | High Performer | 2,230 | 78,050 | 2,230 | 2,147 | 13 | 149 | 35.00 | 6,003.85 |
| 247 | HY-1023-70 | Hydration Pack - 70 oz. | Accessories | Hydration Packs | 21 | Mid Range | 733 | 40,315 | 733 | 719 | 12 | 149 | 55.00 | 3,359.58 |
| 248 | LJ-0192-L | Long-Sleeve Logo Jersey- L | Clothing | Jerseys | 38 | Mid Range | 452 | 22,650 | 453 | 449 | 13 | 149 | 50.11 | 1,742.31 |
| 249 | LJ-0192-M | Long-Sleeve Logo Jersey- M | Clothing | Jerseys | 38 | Mid Range | 442 | 22,100 | 442 | 436 | 13 | 149 | 50.00 | 1,700.00 |
| 250 | LJ-0192-S | Long-Sleeve Logo Jersey- S | Clothing | Jerseys | 38 | Mid Range | 429 | 21,450 | 429 | 426 | 12 | 149 | 50.00 | 1,787.50 |
| 251 | LJ-0192-X | Long-Sleeve Logo Jersey- XL | Clothing | Jerseys | 38 | Mid Range | 413 | 20,700 | 414 | 409 | 12 | 149 | 50.12 | 1,725.00 |
| 259 | PK-7098 | Patch Kit/8 Patches | Accessories | Tires and Tubes | 1 | Low Performer | 3,191 | 6,382 | 3,191 | 2,950 | 12 | 149 | 2.00 | 531.83 |
| 260 | RA-H123 | Hitch Rack - 4-Bike | Accessories | Bike Racks | 45 | Mid Range | 328 | 39,360 | 328 | 325 | 12 | 149 | 120.00 | 3,280.00 |
| 272 | SH-W890-L | Women's Mountain Shorts- L | Clothing | Shorts | 26 | Mid Range | 363 | 25,410 | 363 | 363 | 12 | 149 | 70.00 | 2,117.50 |
| 273 | SH-W890-M | Women's Mountain Shorts- M | Clothing | Shorts | 26 | Mid Range | 352 | 24,640 | 352 | 352 | 12 | 149 | 70.00 | 2,053.33 |
| 274 | SH-W890-S | Women's Mountain Shorts- S | Clothing | Shorts | 26 | Mid Range | 304 | 21,280 | 304 | 304 | 12 | 149 | 70.00 | 1,773.33 |
| 275 | SJ-0194-L | Short-Sleeve Classic Jersey- L | Clothing | Jerseys | 42 | Mid Range | 374 | 20,196 | 374 | 372 | 12 | 149 | 54.00 | 1,683.00 |
| 276 | SJ-0194-M | Short-Sleeve Classic Jersey- M | Clothing | Jerseys | 42 | Mid Range | 407 | 21,978 | 407 | 404 | 12 | 149 | 54.00 | 1,831.50 |
| 277 | SJ-0194-S | Short-Sleeve Classic Jersey- S | Clothing | Jerseys | 42 | Mid Range | 406 | 21,924 | 406 | 402 | 12 | 149 | 54.00 | 1,827.00 |
| 278 | SJ-0194-X | Short-Sleeve Classic Jersey- XL | Clothing | Jerseys | 42 | Mid Range | 409 | 22,086 | 409 | 405 | 12 | 149 | 54.00 | 1,840.50 |
| 279 | SO-R809-L | Racing Socks- L | Clothing | Socks | 3 | Low Performer | 270 | 2,430 | 270 | 269 | 12 | 149 | 9.00 | 202.50 |
| 280 | SO-R809-M | Racing Socks- M | Clothing | Socks | 3 | Low Performer | 298 | 2,682 | 298 | 295 | 12 | 149 | 9.00 | 223.50 |
| 281 | ST-1401 | All-Purpose Bike Stand | Accessories | Bike Stands | 59 | Mid Range | 249 | 39,591 | 249 | 243 | 13 | 149 | 159.00 | 3,045.46 |
| 282 | TI-M267 | LL Mountain Tire | Accessories | Tires and Tubes | 9 | Mid Range | 862 | 21,600 | 864 | 830 | 12 | 149 | 25.06 | 1,800.00 |
| 283 | TI-M602 | ML Mountain Tire | Accessories | Tires and Tubes | 11 | Mid Range | 1,161 | 34,830 | 1,161 | 1,161 | 12 | 149 | 30.00 | 2,902.50 |
| 284 | TI-M823 | HL Mountain Tire | Accessories | Tires and Tubes | 13 | Mid Range | 1,396 | 48,895 | 1,397 | 1,396 | 13 | 149 | 35.03 | 3,761.15 |
| 285 | TI-R092 | LL Road Tire | Accessories | Tires and Tubes | 8 | Mid Range | 1,044 | 21,924 | 1,044 | 1,030 | 13 | 149 | 21.00 | 1,686.46 |
| 286 | TI-R628 | ML Road Tire | Accessories | Tires and Tubes | 9 | Mid Range | 926 | 23,150 | 926 | 891 | 12 | 149 | 25.00 | 1,929.17 |
| 287 | TI-R982 | HL Road Tire | Accessories | Tires and Tubes | 12 | Mid Range | 858 | 28,314 | 858 | 820 | 13 | 149 | 33.00 | 2,178.00 |
|

---

