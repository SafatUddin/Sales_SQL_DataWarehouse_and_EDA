---
### 06_RANKING_ANALYSIS: Top N | Bottom N Analysis
---
Purpose: Order dimensions by measure values to identify best and worst performers

---

### Product Ranking
---

### Q) Top 5 products by revenue
### Answer:
```SQL
SELECT 
    P.product_name, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_revenue DESC
LIMIT 5;
```

**Output:**

| product_name | total_revenue |
|--------------|---------------|
| Mountain-200 Black- 46 | 1,373,454 |
| Mountain-200 Black- 42 | 1,363,128 |
| Mountain-200 Silver- 38 | 1,339,394 |
| Mountain-200 Silver- 46 | 1,301,029 |
| Mountain-200 Black- 38 | 1,294,854 |

---

### Q) Top 5 products by revenue (using window function)
### Answer:
```SQL
SELECT 
    ROW_NUMBER() OVER(ORDER BY SUM(S.sales_amount) DESC) AS rank_no,
    P.product_name, 
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.product_name
LIMIT 5;
```

**Output:**

| product_name | total_revenue |
|--------------|---------------|
| Mountain-200 Black- 46 | 1,373,454 |
| Mountain-200 Black- 42 | 1,363,128 |
| Mountain-200 Silver- 38 | 1,339,394 |
| Mountain-200 Silver- 46 | 1,301,029 |
| Mountain-200 Black- 38 | 1,294,854 |

---

### Q) Bottom 5 worst performing products by sales
### Answer:
```SQL
SELECT 
    P.product_name, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.product_name
ORDER BY total_revenue ASC
LIMIT 5;
```

**Output:**

| product_name | total_revenue |
|--------------|---------------|
| Racing Socks- L | 2,430 |
| Racing Socks- M | 2,682 |
| Patch Kit/8 Patches | 6,382 |
| Bike Wash - Dissolver | 7,272 |
| Touring Tire Tube | 7,440 |

---

### Subcategory Ranking
---

### Q) Top 5 subcategories by revenue
### Answer:
```SQL
SELECT 
    P.subcategory, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.subcategory
ORDER BY total_revenue DESC
LIMIT 5;
```

**Output:**

| subcategory | total_revenue |
|-------------|---------------|
| Road Bikes | 14,519,438 |
| Mountain Bikes | 9,952,254 |
| Touring Bikes | 3,844,580 |
| Tires and Tubes | 244,634 |
| Helmets | 225,435 |

---

### Q) Bottom 5 subcategories by revenue
### Answer:
```SQL
SELECT 
    P.subcategory, 
    SUM(S.sales_amount) AS total_revenue 
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key
GROUP BY P.subcategory
ORDER BY total_revenue ASC
LIMIT 5;
```

**Output:**

| subcategory | total_revenue |
|-------------|---------------|
| Socks | 5,112 |
| Cleaners | 7,272 |
| Caps | 19,710 |
| Gloves | 34,320 |
| Vests | 36,160 |

---

### Customer Ranking
---

### Q) Top 10 customers by revenue
### Answer:
```SQL
SELECT 
    ROW_NUMBER() OVER(ORDER BY SUM(S.sales_amount) DESC) AS rank_no,
    C.customer_id, 
    C.first_name, 
    C.last_name,
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY total_revenue DESC
LIMIT 10;
```

**Output:**

| rank_no | customer_id | first_name | last_name | total_revenue |
|---------|-------------|------------|-----------|---------------|
| 1 | 12132 | Kaitlyn | Henderson | 13,294 |
| 2 | 12301 | Nichole | Nara | 13,294 |
| 3 | 12308 | Margaret | He | 13,268 |
| 4 | 12131 | Randall | Dominguez | 13,265 |
| 5 | 12300 | Adriana | Gonzalez | 13,242 |
| 6 | 12321 | Rosa | Hu | 13,215 |
| 7 | 12124 | Brandi | Gill | 13,195 |
| 8 | 12307 | Brad | She | 13,172 |
| 9 | 12296 | Francisco | Sara | 13,164 |
| 10 | 11433 | Maurice | Shan | 12,914 |

---

### Q) Top 3 customers with fewest orders placed
### Answer:
```SQL
SELECT 
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_number) ASC) AS rank_no,
    C.customer_id, 
    C.first_name, 
    C.last_name,
    COUNT(DISTINCT order_number) AS no_of_orders_placed
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY no_of_orders_placed ASC
LIMIT 3;
```

**Output:**

| rank_no | customer_id | first_name | last_name | no_of_orders_placed |
|---------|-------------|------------|-----------|---------------------|
| 9148 | 18568 | Mya | Bennett | 1 |
| 9149 | 18569 | Emma | Bryant | 1 |
| 9150 | 18570 | Mason | Peterson | 1 |

---
