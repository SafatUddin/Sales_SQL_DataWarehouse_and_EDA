---
### 04_MEASURE_EXPLORATION: Key Business Metrics & KPIs
---
Purpose: Calculate core business measures

Note: If a data field is numeric and makes sense to aggregate, it's a Measure.
Examples: Sales, Quantity, Price, Cost

---

### Individual KPI Queries
---
### Q) Total Sales Revenue
### Answer:
```SQL
SELECT SUM(sales_amount) AS total_sales 
FROM gold_analytics.fact_sales;
```

**Output:**
| total_sales |
|-------------|
| 29,356,250 |

---

### Q) Total Items Sold
### Answer:
```SQL
SELECT SUM(quantity) AS no_of_items_sold 
FROM gold_analytics.fact_sales;
```

**Output:**
| no_of_items_sold |
|------------------|
| 60423 |

---

### Q) Average Selling Price
### Answer:
```SQL
SELECT AVG(price) AS average_selling_price 
FROM gold_analytics.fact_sales;
```

**Output:**
| average_selling_price |
|-----------------------|
| 486.04 |

---

### Q) Total Number of Orders
### Answer:
```SQL
SELECT COUNT(DISTINCT order_number) AS total_number_of_orders 
FROM gold_analytics.fact_sales;
```

**Output:**
| total_number_of_orders |
|------------------------|
| 27659 |

---

### Q) Total Number of Products
### Answer:
```SQL
SELECT COUNT(DISTINCT product_name) AS total_number_of_products 
FROM gold_analytics.dim_products;
```

**Output:**
| total_number_of_products |
|--------------------------|
| 295 |

---

### Q) Total Number of Customers
### Answer:
```SQL
SELECT COUNT(DISTINCT customer_id) AS total_number_of_customers 
FROM gold_analytics.dim_customers;
```

**Output:**
| total_number_of_customers |
|---------------------------|
| 18484 |

---

### Q) Total Number of Customers Who Placed an Order
### Answer:
```SQL
SELECT COUNT(DISTINCT customer_key) AS no_of_customers_that_placed_order 
FROM gold_analytics.fact_sales;
```

**Output:**
| no_of_customers_that_placed_order |
|-----------------------------------|
| 18484 |

---

### Unified KPI Dashboard
---
### Q) All KPIs in a Single View
### Answer:
```SQL
SELECT 'Total Sales' AS measure_name, 
       CAST(SUM(sales_amount) AS SIGNED) AS measure_value 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'No of Items Sold', 
       CAST(SUM(quantity) AS SIGNED) 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'Average Selling Price', 
       CAST(AVG(price) AS SIGNED) 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'Total Number of Orders', 
       CAST(COUNT(DISTINCT order_number) AS SIGNED) 
FROM gold_analytics.fact_sales 
UNION ALL 
SELECT 'Total Number of Products', 
       CAST(COUNT(DISTINCT product_name) AS SIGNED) 
FROM gold_analytics.dim_products 
UNION ALL 
SELECT 'Total Number of Customers', 
       CAST(COUNT(DISTINCT customer_id) AS SIGNED) 
FROM gold_analytics.dim_customers 
UNION ALL 
SELECT 'Total Number of Customers that placed an Order', 
       CAST(COUNT(DISTINCT customer_key) AS SIGNED) 
FROM gold_analytics.fact_sales;
```

**Output:**

| measure_name | measure_value |
|--------------|---------------|
| Total Sales | 29,356,250 |
| No of Items Sold | 60,423 |
| Average Selling Price | 486 |
| Total Number of Orders | 27,659 |
| Total Number of Products | 295 |
| Total Number of Customers | 18,484 |
| Total Number of Customers that placed an Order | 18,484 |

---

