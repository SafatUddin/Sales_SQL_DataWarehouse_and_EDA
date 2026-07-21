---
### 11_DATA_SEGMENTATION: Group Data by Specific Ranges
---
Purpose: Group data based on specific ranges to understand correlation between measures. 
Examples: Total Sales by Sales Range, Total Customers by Age

---

### Product Cost Segmentation
---

### Q) Product distribution by cost range segments
### Answer:
```SQL
WITH product_segments AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 501 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold_analytics.dim_products
)
SELECT
    cost_range,
    COUNT(DISTINCT product_key) AS total_products
FROM product_segments 
GROUP BY cost_range
ORDER BY total_products DESC;
```

**Output:**

| cost_range | total_products |
|------------|----------------|
| Below 100 | 110 |
| 100-500 | 101 |
| 500-1000 | 45 |
| Above 1000 | 39 |

---

### Customer Segmentation (VIP / Regular / New)
---

### Q) Customer segmentation based on spending and loyalty
### Answer:
```SQL
WITH customer_segments AS (
    SELECT 
        C.customer_key,
        C.first_name,
        C.last_name,
        SUM(S.sales_amount) AS net_spent,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold_analytics.dim_customers C
    LEFT JOIN gold_analytics.fact_sales S
        ON C.customer_key = S.customer_key
    GROUP BY C.customer_key, C.first_name, C.last_name
)
SELECT 
    CASE 
        WHEN lifespan >= 12 AND net_spent > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND net_spent <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_rank,
    COUNT(customer_key) AS total_customers
FROM customer_segments
GROUP BY customer_rank
ORDER BY 
    CASE customer_rank
        WHEN 'VIP' THEN 1
        WHEN 'Regular' THEN 2
        ELSE 3
    END;
```

**Output:**

| customer_rank | total_customers |
|---------------|-----------------|
| VIP | 1,619 |
| Regular | 2,037 |
| New | 14,828 |

**Segment Definitions:**
- **VIP:** >= 12 months history AND spending > €5,000
- **Regular:** >= 12 months history AND spending <= €5,000
- **New:** < 12 months history

---
```
