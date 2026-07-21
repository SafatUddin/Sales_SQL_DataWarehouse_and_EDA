---
### 10_PART_TO_WHOLE_ANALYSIS: Contribution Percentages
---
Purpose: Analyze how an individual part performs compared to the overall total

Formula: (Measure / Total(Measure)) * 100 BY Dimension

Helps understand which category has the greatest impact on the business

---

### Category Contribution to Overall Sales
---

### Q) Product category contribution to total sales percentage
### Answer:
```SQL
WITH category_sales AS (
    SELECT 
        P.category,
        SUM(sales_amount) AS total_sales
    FROM gold_analytics.fact_sales S
    LEFT JOIN gold_analytics.dim_products P
        ON S.product_key = P.product_key
    GROUP BY P.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    -- Percentage contribution to total sales
    CONCAT(ROUND(((total_sales / SUM(total_sales) OVER()) * 100), 2), '%') AS percentage_of_overall_sales
FROM category_sales
ORDER BY total_sales DESC;
```

**Output:**

| category | total_sales | overall_sales | percentage_of_overall_sales |
|----------|-------------|---------------|-----------------------------|
| Bikes | 28,316,272 | 29,356,250 | 96.46% |
| Accessories | 700,262 | 29,356,250 | 2.39% |
| Clothing | 339,716 | 29,356,250 | 1.16% |

---

### Country Contribution to Overall Quantity
---

### Q) Country contribution to total quantity sold percentage
### Answer:
```SQL
WITH country_quantity AS (
    SELECT 
        C.country,
        SUM(S.quantity) AS total_quantity
    FROM gold_analytics.fact_sales S
    LEFT JOIN gold_analytics.dim_customers C
        ON S.customer_key = C.customer_key
    GROUP BY C.country
)
SELECT 
    country,
    total_quantity,
    SUM(total_quantity) OVER() AS overall_quantity,
    CONCAT(ROUND(((total_quantity / SUM(total_quantity) OVER()) * 100), 2), '%') AS percentage_of_overall_quantity
FROM country_quantity
ORDER BY total_quantity DESC;
```

**Output:**

| country | total_quantity | overall_quantity | percentage_of_overall_quantity |
|---------|----------------|------------------|--------------------------------|
| United States | 20,481 | 60,423 | 33.90% |
| Australia | 13,346 | 60,423 | 22.09% |
| Canada | 7,630 | 60,423 | 12.63% |
| United Kingdom | 6,910 | 60,423 | 11.44% |
| Germany | 5,626 | 60,423 | 9.31% |
| France | 5,559 | 60,423 | 9.20% |
| N/A | 871 | 60,423 | 1.44% |

---
