---
### 05_MAGNITUDE_ANALYSIS: Compare Measures by Categories
---
Purpose: Understand the importance of different categories

Concept: Break down measures by dimension to see which categories drive the business
Examples: Total sales by country, Total quantity by category, Average price by product

---

### Customer Magnitude Analysis
---

### Q) Total customers by country
### Answer:
```SQL
SELECT 
    country, 
    COUNT(DISTINCT customer_id) AS total_customers 
FROM gold_analytics.dim_customers 
GROUP BY country 
ORDER BY total_customers DESC;
```

**Output:**

| country | total_customers |
|---------|-----------------|
| United States | 7,482 |
| Australia | 3,591 |
| United Kingdom | 1,913 |
| France | 1,810 |
| Germany | 1,780 |
| Canada | 1,571 |
| N/A | 337 |

---

### Q) Total customers by gender
### Answer:
```SQL
SELECT 
    gender, 
    COUNT(DISTINCT customer_id) AS total_customers 
FROM gold_analytics.dim_customers 
GROUP BY gender;
```

**Output:**

| gender | total_customers |
|--------|-----------------|
| Female | 9,128 |
| Male | 9,341 |
| N/A | 15 |

---

### Product Magnitude Analysis
---

### Q) Total products by category
### Answer:
```SQL
SELECT 
    category, 
    COUNT(DISTINCT product_id) AS total_products 
FROM gold_analytics.dim_products 
GROUP BY category 
ORDER BY total_products DESC;
```

**Output:**

| category | total_products |
|----------|----------------|
| Components | 127 |
| Bikes | 97 |
| Clothing | 35 |
| Accessories | 29 |
| NULL | 7 |

---

### Q) Average cost by category
### Answer:
```SQL
SELECT 
    category, 
    AVG(cost) AS average_cost 
FROM gold_analytics.dim_products 
GROUP BY category 
ORDER BY average_cost DESC;
```

**Output:**

| category | average_cost |
|----------|--------------|
| Bikes | 949.44 |
| Components | 264.72 |
| NULL | 28.57 |
| Clothing | 24.80 |
| Accessories | 13.17 |

---

### Sales Magnitude Analysis
---

### Q) Total revenue by product category
### Answer:
```SQL
SELECT 
    P.category, 
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_products P
    ON S.product_key = P.product_key 
GROUP BY P.category
ORDER BY total_revenue DESC;
```

**Output:**
| category | total_revenue |
|----------|---------------|
| Bikes | 28,316,272 |
| Accessories | 700,262 |
| Clothing | 339,716 |

---

### Q) Total revenue by customer
### Answer:
```SQL
SELECT 
    C.customer_id, 
    C.first_name, 
    C.last_name, 
    SUM(S.sales_amount) AS total_revenue
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY total_revenue DESC
LIMIT 100;
```

**Output:**

| customer_id | first_name | last_name | total_revenue |
|-------------|------------|-----------|---------------|
| 12301 | Nichole | Nara | 13,294 |
| 12132 | Kaitlyn | Henderson | 13,294 |
| 12308 | Margaret | He | 13,268 |
| 12131 | Randall | Dominguez | 13,265 |
| 12300 | Adriana | Gonzalez | 13,242 |
| 12321 | Rosa | Hu | 13,215 |
| 12124 | Brandi | Gill | 13,195 |
| 12307 | Brad | She | 13,172 |
| 12296 | Francisco | Sara | 13,164 |
| 11433 | Maurice | Shan | 12,914 |
| 11439 | Janet | Munoz | 12,488 |
| 11241 | Lisa | Cai | 11,468 |
| 11417 | Lacey | Zheng | 11,248 |
| 11420 | Jordan | Turner | 11,200 |
| 11242 | Larry | Munoz | 11,067 |
| 12655 | Larry | Vazquez | 10,899 |
| 13263 | Kate | Anand | 10,871 |
| 12323 | Lawrence | Alonso | 10,836 |
| 12333 | Terrance | Rodriguez | 10,829 |
| 12650 | Aaron | Wright | 10,813 |
| 12631 | Clarence | Gao | 10,799 |
| 12632 | Bonnie | Nath | 10,793 |
| 12332 | Andres | Nara | 10,789 |
| 13405 | Ethan | Bryant | 10,778 |
| 11245 | Ricky | Vazquez | 10,580 |
| 11246 | Latasha | Rubio | 10,575 |
| 11237 | Clarence | Anand | 10,566 |
| 11425 | Ariana | Gray | 10,528 |
| 11429 | Marco | Lopez | 10,468 |
| 11428 | Deanna | Perez | 9,954 |
| 11427 | Desiree | Dominguez | 9,918 |
| 11431 | Bryant | Garcia | 9,913 |
| 11423 | Jasmine | Stewart | 9,905 |
| 11249 | Cindy | Patel | 9,890 |
| 11412 | Sydney | Bryant | 9,880 |
| 14186 | Katrina | Tang | 9,796 |
| 11421 | Amy | Sun | 9,780 |
| 13592 | Gabriella | Collins | 9,695 |
| 13605 | Gerrit | Straatsma | 9,614 |
| 14185 | Frank | Vazquez | 9,524 |
| 13575 | Alicia | Shen | 9,458 |
| 14192 | Ronald | Kapoor | 9,452 |
| 13577 | Theodore | Torres | 9,451 |
| 14200 | Colleen | Goel | 9,422 |
| 13595 | Cole | Stewart | 9,391 |
| 11432 | Dominique | Prasad | 9,330 |
| 13257 | Jon | Chander | 8,941 |
| 13258 | Anne | Dominguez | 8,886 |
| 12128 | Kristy | Munoz | 8,681 |
| 12125 | Diana | Ortega | 8,595 |
| 12129 | Wendy | Alvarez | 8,557 |
| 13600 | Marie | Sanz | 8,460 |
| 14427 | Emmanuel | Patel | 8,451 |
| 15106 | Shannon | Navarro | 8,421 |
| 14775 | Bonnie | Xie | 8,404 |
| 14429 | Lacey | He | 8,394 |
| 15692 | Ryan | Garcia | 8,392 |
| 15097 | Morgan | Bennett | 8,377 |
| 13602 | Virginia | Mehta | 8,376 |
| 13581 | Albert | Blanco | 8,375 |
| 13583 | Blake | Butler | 8,375 |
| 13585 | Savannah | Morris | 8,368 |
| 14939 | Cory | Kapoor | 8,367 |
| 14940 | Carmen | Rana | 8,367 |
| 14207 | José | Saraiva | 8,361 |
| 13584 | Isaiah | Cox | 8,361 |
| 13591 | Latasha | Alonso | 8,355 |
| 14830 | Isabella | Ward | 8,346 |
| 15691 | Julian | Henderson | 8,341 |
| 14425 | Victor | Carlson | 8,332 |
| 13576 | Tamara | Lal | 8,330 |
| 14181 | Adriana | Chandra | 8,326 |
| 15695 | Bruce | Gomez | 8,324 |
| 14428 | Cassie | Andersen | 8,321 |
| 14183 | Robyn | Carlson | 8,321 |
| 11767 | Meagan | Madan | 8,319 |
| 14426 | Madison | Hughes | 8,319 |
| 14189 | Krista | Martin | 8,317 |
| 14195 | Clinton | Blanco | 8,316 |
| 14198 | Daisy | Romero | 8,308 |
| 13590 | Louis | Xie | 8,306 |
| 15080 | Evelyn | Chandra | 8,305 |
| 14191 | Derrick | Martin | 8,301 |
| 15118 | Nelson | Ortega | 8,301 |
| 15354 | Corey | Kumar | 8,297 |
| 11112 | Crystal | Wang | 8,295 |
| 11766 | Candace | Raman | 8,280 |
| 12338 | Monica | Vance | 8,265 |
| 11101 | Abby | Sai | 8,262 |
| 11900 | Byron | Carlson | 8,257 |
| 12003 | Audrey | Munoz | 8,256 |
| 11451 | Ruben | Muñoz | 8,250 |
| 11000 | Jon | Yang | 8,249 |
| 11995 | Kelvin | Carson | 8,249 |
| 11058 | Marc | Diaz | 8,248 |
| 11901 | Stacy | Alvarez | 8,248 |
| 11986 | Max | Alvarez | 8,245 |
| 11109 | Ruben | Kapoor | 8,245 |
| 11120 | Beth | Jiménez | 8,242 |
| 11446 | Bethany | Chander | 8,237 |

---

### Q) Distribution of sold items across countries
### Answer:
```SQL
SELECT 
    C.country, 
    SUM(S.quantity) AS total_sold
FROM gold_analytics.fact_sales S
LEFT JOIN gold_analytics.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY C.country
ORDER BY total_sold DESC;
```

**Output:**

| country | total_sold |
|---------|------------|
| United States | 20,481 |
| Australia | 13,346 |
| Canada | 7,630 |
| United Kingdom | 6,910 |
| Germany | 5,626 |
| France | 5,559 |
| N/A | 871 |

---
