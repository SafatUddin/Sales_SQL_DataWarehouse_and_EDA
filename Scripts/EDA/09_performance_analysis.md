---
### 09_PERFORMANCE_ANALYSIS: Current vs Target Comparisons
---
Purpose: Compare current values to target/baseline values

Measures success and compares performance across periods.
Examples: (Current Sales - Average Sales), (Current Year - Previous Year), (Current - Lowest)

---

### Yearly Product Performance vs Average & Previous Year
---

### Q) Year-over-year product performance comparison with average baseline
### Answer:
```SQL
WITH yearly_product_sales AS (
    SELECT 
        YEAR(S.order_date) AS order_year,
        P.product_name,
        SUM(S.sales_amount) AS current_sales
    FROM gold_analytics.fact_sales S
    LEFT JOIN gold_analytics.dim_products P
        ON S.product_key = P.product_key
    WHERE order_date IS NOT NULL
    GROUP BY order_year, P.product_name
)
SELECT 
    order_year,
    product_name,
    current_sales,
    -- Previous year sales for same product
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS previous_year_sales,
    -- Difference from previous year
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS diff_py_sales,
    -- Change direction indicator
    CASE 
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change,
    -- Average sales across all years for this product
    CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) AS average_sales,
    -- Difference from average
    current_sales - CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) AS diff_avg,
    -- Performance vs average indicator
    CASE 
        WHEN current_sales - CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) > 0 THEN 'Above Average'
        WHEN current_sales - CAST(AVG(current_sales) OVER(PARTITION BY product_name) AS SIGNED) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
```

**Output:**

| order_year | product_name | current_sales | previous_year_sales | diff_py_sales | py_change | average_sales | diff_avg | avg_change |
|------------|--------------|---------------|---------------------|---------------|-----------|---------------|----------|------------|
| 2012 | All-Purpose Bike Stand | 159 | NULL | NULL | No Change | 13,197 | -13,038 | Below Average |
| 2013 | All-Purpose Bike Stand | 37,683 | 159 | 37,524 | Increase | 13,197 | 24,486 | Above Average |
| 2014 | All-Purpose Bike Stand | 1,749 | 37,683 | -35,934 | Decrease | 13,197 | -11,448 | Below Average |
| 2012 | AWC Logo Cap | 72 | NULL | NULL | No Change | 6,570 | -6,498 | Below Average |
| 2013 | AWC Logo Cap | 18,891 | 72 | 18,819 | Increase | 6,570 | 12,321 | Above Average |
| 2014 | AWC Logo Cap | 747 | 18,891 | -18,144 | Decrease | 6,570 | -5,823 | Below Average |
| 2013 | Bike Wash - Dissolver | 6,960 | NULL | NULL | No Change | 3,636 | 3,324 | Above Average |
| 2014 | Bike Wash - Dissolver | 312 | 6,960 | -6,648 | Decrease | 3,636 | -3,324 | Below Average |
| 2013 | Classic Vest- L | 11,968 | NULL | NULL | No Change | 6,240 | 5,728 | Above Average |
| 2014 | Classic Vest- L | 512 | 11,968 | -11,456 | Decrease | 6,240 | -5,728 | Below Average |
| 2013 | Classic Vest- M | 11,840 | NULL | NULL | No Change | 6,368 | 5,472 | Above Average |
| 2014 | Classic Vest- M | 896 | 11,840 | -10,944 | Decrease | 6,368 | -5,472 | Below Average |
| 2012 | Classic Vest- S | 64 | NULL | NULL | No Change | 3,648 | -3,584 | Below Average |
| 2013 | Classic Vest- S | 10,368 | 64 | 10,304 | Increase | 3,648 | 6,720 | Above Average |
| 2014 | Classic Vest- S | 512 | 10,368 | -9,856 | Decrease | 3,648 | -3,136 | Below Average |
| 2012 | Fender Set - Mountain | 110 | NULL | NULL | No Change | 15,554 | -15,444 | Below Average |
| 2013 | Fender Set - Mountain | 44,484 | 110 | 44,374 | Increase | 15,554 | 28,930 | Above Average |
| 2014 | Fender Set - Mountain | 2,068 | 44,484 | -42,416 | Decrease | 15,554 | -13,486 | Below Average |
| 2012 | Half-Finger Gloves- L | 24 | NULL | NULL | No Change | 3,544 | -3,520 | Below Average |
| 2013 | Half-Finger Gloves- L | 10,248 | 24 | 10,224 | Increase | 3,544 | 6,704 | Above Average |
| 2014 | Half-Finger Gloves- L | 360 | 10,248 | -9,888 | Decrease | 3,544 | -3,184 | Below Average |
| 2012 | Half-Finger Gloves- M | 24 | NULL | NULL | No Change | 3,992 | -3,968 | Below Average |
| 2013 | Half-Finger Gloves- M | 11,376 | 24 | 11,352 | Increase | 3,992 | 7,384 | Above Average |
| 2014 | Half-Finger Gloves- M | 576 | 11,376 | -10,800 | Decrease | 3,992 | -3,416 | Below Average |
| 2012 | Half-Finger Gloves- S | 24 | NULL | NULL | No Change | 3,896 | -3,872 | Below Average |
| 2013 | Half-Finger Gloves- S | 11,064 | 24 | 11,040 | Increase | 3,896 | 7,168 | Above Average |
| 2014 | Half-Finger Gloves- S | 600 | 11,064 | -10,464 | Decrease | 3,896 | -3,296 | Below Average |
| 2013 | Hitch Rack - 4-Bike | 36,840 | NULL | NULL | No Change | 19,620 | 17,220 | Above Average |
| 2014 | Hitch Rack - 4-Bike | 2,400 | 36,840 | -34,440 | Decrease | 19,620 | -17,220 | Below Average |
| 2012 | HL Mountain Tire | 140 | NULL | NULL | No Change | 16,287 | -16,147 | Below Average |
| 2013 | HL Mountain Tire | 46,935 | 140 | 46,795 | Increase | 16,287 | 30,648 | Above Average |
| 2014 | HL Mountain Tire | 1,785 | 46,935 | -45,150 | Decrease | 16,287 | -14,502 | Below Average |
| 2012 | HL Road Tire | 132 | NULL | NULL | No Change | 9,438 | -9,306 | Below Average |
| 2013 | HL Road Tire | 26,532 | 132 | 26,400 | Increase | 9,438 | 17,094 | Above Average |
| 2014 | HL Road Tire | 1,650 | 26,532 | -24,882 | Decrease | 9,438 | -7,788 | Below Average |
| 2012 | Hydration Pack - 70 oz. | 110 | NULL | NULL | No Change | 13,438 | -13,328 | Below Average |
| 2013 | Hydration Pack - 70 oz. | 38,940 | 110 | 38,830 | Increase | 13,438 | 25,502 | Above Average |
| 2014 | Hydration Pack - 70 oz. | 1,265 | 38,940 | -37,675 | Decrease | 13,438 | -12,173 | Below Average |
| 2013 | LL Mountain Tire | 20,125 | NULL | NULL | No Change | 10,775 | 9,350 | Above Average |
| 2014 | LL Mountain Tire | 1,425 | 20,125 | -18,700 | Decrease | 10,775 | -9,350 | Below Average |
| 2012 | LL Road Tire | 105 | NULL | NULL | No Change | 7,301 | -7,196 | Below Average |
| 2013 | LL Road Tire | 20,622 | 105 | 20,517 | Increase | 7,301 | 13,321 | Above Average |
| 2014 | LL Road Tire | 1,176 | 20,622 | -19,446 | Decrease | 7,301 | -6,125 | Below Average |
| 2012 | Long-Sleeve Logo Jersey- L | 150 | NULL | NULL | No Change | 7,550 | -7,400 | Below Average |
| 2013 | Long-Sleeve Logo Jersey- L | 21,550 | 150 | 21,400 | Increase | 7,550 | 14,000 | Above Average |
| 2014 | Long-Sleeve Logo Jersey- L | 950 | 21,550 | -20,600 | Decrease | 7,550 | -6,600 | Below Average |
| 2012 | Long-Sleeve Logo Jersey- M | 50 | NULL | NULL | No Change | 7,367 | -7,317 | Below Average |
| 2013 | Long-Sleeve Logo Jersey- M | 20,850 | 50 | 20,800 | Increase | 7,367 | 13,483 | Above Average |
| 2014 | Long-Sleeve Logo Jersey- M | 1,200 | 20,850 | -19,650 | Decrease | 7,367 | -6,167 | Below Average |
| 2013 | Long-Sleeve Logo Jersey- S | 20,350 | NULL | NULL | No Change | 10,725 | 9,625 | Above Average |
| 2014 | Long-Sleeve Logo Jersey- S | 1,100 | 20,350 | -19,250 | Decrease | 10,725 | -9,625 | Below Average |
| 2013 | Long-Sleeve Logo Jersey- XL | 19,850 | NULL | NULL | No Change | 10,350 | 9,500 | Above Average |
| 2014 | Long-Sleeve Logo Jersey- XL | 850 | 19,850 | -19,000 | Decrease | 10,350 | -9,500 | Below Average |
| 2012 | ML Mountain Tire | 30 | NULL | NULL | No Change | 11,600 | -11,570 | Below Average |
| 2013 | ML Mountain Tire | 32,580 | 30 | 32,550 | Increase | 11,600 | 20,980 | Above Average |
| 2014 | ML Mountain Tire | 2,190 | 32,580 | -30,390 | Decrease | 11,600 | -9,410 | Below Average |
| 2012 | ML Road Tire | 50 | NULL | NULL | No Change | 7,708 | -7,658 | Below Average |
| 2013 | ML Road Tire | 22,275 | 50 | 22,225 | Increase | 7,708 | 14,567 | Above Average |
| 2014 | ML Road Tire | 800 | 22,275 | -21,475 | Decrease | 7,708 | -6,908 | Below Average |
| 2012 | Mountain Bottle Cage | 110 | NULL | NULL | No Change | 6,780 | -6,670 | Below Average |
| 2013 | Mountain Bottle Cage | 19,530 | 110 | 19,420 | Increase | 6,780 | 12,750 | Above Average |
| 2014 | Mountain Bottle Cage | 700 | 19,530 | -18,830 | Decrease | 6,780 | -6,080 | Below Average |
| 2012 | Mountain Tire Tube | 15 | NULL | NULL | No Change | 5,155 | -5,140 | Below Average |
| 2013 | Mountain Tire Tube | 14,620 | 15 | 14,605 | Increase | 5,155 | 9,465 | Above Average |
| 2014 | Mountain Tire Tube | 830 | 14,620 | -13,790 | Decrease | 5,155 | -4,325 | Below Average |
| 2011 | Mountain-100 Black- 38 | 165,375 | NULL | NULL | No Change | 165,375 | 0 | Average |
| 2011 | Mountain-100 Black- 42 | 151,875 | NULL | NULL | No Change | 151,875 | 0 | Average |
| 2011 | Mountain-100 Black- 44 | 202,500 | NULL | NULL | No Change | 202,500 | 0 | Average |
| 2010 | Mountain-100 Black- 48 | 3,375 | NULL | NULL | No Change | 96,188 | -92,813 | Below Average |
| 2011 | Mountain-100 Black- 48 | 189,000 | 3,375 | 185,625 | Increase | 96,188 | 92,812 | Above Average |
| 2010 | Mountain-100 Silver- 38 | 3,400 | NULL | NULL | No Change | 98,600 | -95,200 | Below Average |
| 2011 | Mountain-100 Silver- 38 | 193,800 | 3,400 | 190,400 | Increase | 98,600 | 95,200 | Above Average |
| 2011 | Mountain-100 Silver- 42 | 142,800 | NULL | NULL | No Change | 142,800 | 0 | Average |
| 2010 | Mountain-100 Silver- 44 | 10,200 | NULL | NULL | No Change | 83,300 | -73,100 | Below Average |
| 2011 | Mountain-100 Silver- 44 | 156,400 | 10,200 | 146,200 | Increase | 83,300 | 73,100 | Above Average |
| 2011 | Mountain-100 Silver- 48 | 122,400 | NULL | NULL | No Change | 122,400 | 0 | Average |
| 2011 | Mountain-200 Black- 38 | 4,098 | NULL | NULL | No Change | 430,853 | -426,755 | Below Average |
| 2012 | Mountain-200 Black- 38 | 342,921 | 4,098 | 338,823 | Increase | 430,853 | -87,932 | Below Average |
| 2013 | Mountain-200 Black- 38 | 945,540 | 342,921 | 602,619 | Increase | 430,853 | 514,687 | Above Average |
| 2012 | Mountain-200 Black- 42 | 392,343 | NULL | NULL | No Change | 681,564 | -289,221 | Below Average |
| 2013 | Mountain-200 Black- 42 | 970,785 | 392,343 | 578,442 | Increase | 681,564 | 289,221 | Above Average |
| 2011 | Mountain-200 Black- 46 | 2,049 | NULL | NULL | No Change | 457,818 | -455,769 | Below Average |
| 2012 | Mountain-200 Black- 46 | 423,570 | 2,049 | 421,521 | Increase | 457,818 | -34,248 | Below Average |
| 2013 | Mountain-200 Black- 46 | 947,835 | 423,570 | 524,265 | Increase | 457,818 | 490,017 | Above Average |
| 2012 | Mountain-200 Silver- 38 | 371,954 | NULL | NULL | No Change | 669,697 | -297,743 | Below Average |
| 2013 | Mountain-200 Silver- 38 | 967,440 | 371,954 | 595,486 | Increase | 669,697 | 297,743 | Above Average |
| 2011 | Mountain-200 Silver- 42 | 2,071 | NULL | NULL | No Change | 419,123 | -417,052 | Below Average |
| 2012 | Mountain-200 Silver- 42 | 352,817 | 2,071 | 350,746 | Increase | 419,123 | -66,306 | Below Average |
| 2013 | Mountain-200 Silver- 42 | 902,480 | 352,817 | 549,663 | Increase | 419,123 | 483,357 | Above Average |
| 2012 | Mountain-200 Silver- 46 | 377,669 | NULL | NULL | No Change | 649,355 | -271,686 | Below Average |
| 2013 | Mountain-200 Silver- 46 | 921,040 | 377,669 | 543,371 | Increase | 649,355 | 271,685 | Above Average |
| 2013 | Mountain-400-W Silver- 38 | 113,812 | NULL | NULL | No Change | 113,812 | 0 | Average |
| 2012 | Mountain-400-W Silver- 40 | 769 | NULL | NULL | No Change | 49,216 | -48,447 | Below Average |
| 2013 | Mountain-400-W Silver- 40 | 97,663 | 769 | 96,894 | Increase | 49,216 | 48,447 | Above Average |
| 2013 | Mountain-400-W Silver- 42 | 99,201 | NULL | NULL | No Change | 99,201 | 0 | Average |
| 2013 | Mountain-400-W Silver- 46 | 106,122 | NULL | NULL | No Change | 106,122 | 0 | Average |
| 2012 | Mountain-500 Black- 40 | 540 | NULL | NULL | No Change | 12,960 | -12,420 | Below Average |
| 2013 | Mountain-500 Black- 40 | 25,380 | 540 | 24,840 | Increase | 12,960 | 12,420 | Above Average |
| 2013 | Mountain-500 Black- 42 | 26,460 | NULL | NULL | No Change | 26,460 | 0 | Average |
| 2013 | Mountain-500 Black- 44 | 31,320 | NULL | NULL | No Change | 31,320 | 0 | Average |
| 2013 | Mountain-500 Black- 48 | 30,240 | NULL | NULL | No Change | 30,240 | 0 | Average |
| 2013 | Mountain-500 Black- 52 | 22,140 | NULL | NULL | No Change | 22,140 | 0 | Average |
| 2013 | Mountain-500 Silver- 40 | 25,425 | NULL | NULL | No Change | 25,425 | 0 | Average |
| 2013 | Mountain-500 Silver- 42 | 25,425 | NULL | NULL | No Change | 25,425 | 0 | Average |
| 2012 | Mountain-500 Silver- 44 | 565 | NULL | NULL | No Change | 11,018 | -10,453 | Below Average |
| 2013 | Mountain-500 Silver- 44 | 21,470 | 565 | 20,905 | Increase | 11,018 | 10,452 | Above Average |
| 2013 | Mountain-500 Silver- 48 | 28,250 | NULL | NULL | No Change | 28,250 | 0 | Average |
| 2013 | Mountain-500 Silver- 52 | 27,120 | NULL | NULL | No Change | 27,120 | 0 | Average |
| 2012 | Patch Kit/8 Patches | 8 | NULL | NULL | No Change | 2,126 | -2,118 | Below Average |
| 2013 | Patch Kit/8 Patches | 6,048 | 8 | 6,040 | Increase | 2,126 | 3,922 | Above Average |
| 2014 | Patch Kit/8 Patches | 322 | 6,048 | -5,726 | Decrease | 2,126 | -1,804 | Below Average |
| 2012 | Racing Socks- L | 18 | NULL | NULL | No Change | 810 | -792 | Below Average |
| 2013 | Racing Socks- L | 2,340 | 18 | 2,322 | Increase | 810 | 1,530 | Above Average |
| 2014 | Racing Socks- L | 72 | 2,340 | -2,268 | Decrease | 810 | -738 | Below Average |
| 2013 | Racing Socks- M | 2,529 | NULL | NULL | No Change | 1,341 | 1,188 | Above Average |
| 2014 | Racing Socks- M | 153 | 2,529 | -2,376 | Decrease | 1,341 | -1,188 | Below Average |
| 2012 | Road Bottle Cage | 81 | NULL | NULL | No Change | 5,133 | -5,052 | Below Average |
| 2013 | Road Bottle Cage | 15,237 | 81 | 15,156 | Increase | 5,133 | 10,104 | Above Average |
| 2014 | Road Bottle Cage | 81 | 15,237 | -15,156 | Decrease | 5,133 | -5,052 | Below Average |
| 2012 | Road Tire Tube | 28 | NULL | NULL | No Change | 3,167 | -3,139 | Below Average |
| 2013 | Road Tire Tube | 8,888 | 28 | 8,860 | Increase | 3,167 | 5,721 | Above Average |
| 2014 | Road Tire Tube | 584 | 8,888 | -8,304 | Decrease | 3,167 | -2,583 | Below Average |
| 2010 | Road-150 Red- 44 | 3,578 | NULL | NULL | No Change | 502,709 | -499,131 | Below Average |
| 2011 | Road-150 Red- 44 | 1,001,840 | 3,578 | 998,262 | Increase | 502,709 | 499,131 | Above Average |
| 2010 | Road-150 Red- 48 | 7,156 | NULL | NULL | No Change | 602,893 | -595,737 | Below Average |
| 2011 | Road-150 Red- 48 | 1,198,630 | 7,156 | 1,191,474 | Increase | 602,893 | 595,737 | Above Average |
| 2010 | Road-150 Red- 52 | 3,578 | NULL | NULL | No Change | 540,278 | -536,700 | Below Average |
| 2011 | Road-150 Red- 52 | 1,076,978 | 3,578 | 1,073,400 | Increase | 540,278 | 536,700 | Above Average |
| 2010 | Road-150 Red- 56 | 3,578 | NULL | NULL | No Change | 527,755 | -524,177 | Below Average |
| 2011 | Road-150 Red- 56 | 1,051,932 | 3,578 | 1,048,354 | Increase | 527,755 | 524,177 | Above Average |
| 2010 | Road-150 Red- 62 | 7,156 | NULL | NULL | No Change | 601,104 | -593,948 | Below Average |
| 2011 | Road-150 Red- 62 | 1,195,052 | 7,156 | 1,187,896 | Increase | 601,104 | 593,948 | Above Average |
| 2011 | Road-250 Black- 44 | 6,546 | NULL | NULL | No Change | 209,461 | -202,915 | Below Average |
| 2012 | Road-250 Black- 44 | 279,818 | 6,546 | 273,272 | Increase | 209,461 | 70,357 | Above Average |
| 2013 | Road-250 Black- 44 | 342,020 | 279,818 | 62,202 | Increase | 209,461 | 132,559 | Above Average |
| 2012 | Road-250 Black- 48 | 310,105 | NULL | NULL | No Change | 345,607 | -35,502 | Below Average |
| 2013 | Road-250 Black- 48 | 381,108 | 310,105 | 71,003 | Increase | 345,607 | 35,501 | Above Average |
| 2011 | Road-250 Black- 52 | 4,364 | NULL | NULL | No Change | 244,808 | -240,444 | Below Average |
| 2012 | Road-250 Black- 52 | 378,269 | 4,364 | 373,905 | Increase | 244,808 | 133,461 | Above Average |
| 2013 | Road-250 Black- 52 | 351,792 | 378,269 | -26,477 | Decrease | 244,808 | 106,984 | Above Average |
| 2011 | Road-250 Black- 58 | 2,182 | NULL | NULL | No Change | 207,342 | -205,160 | Below Average |
| 2012 | Road-250 Black- 58 | 316,912 | 2,182 | 314,730 | Increase | 207,342 | 109,570 | Above Average |
| 2013 | Road-250 Black- 58 | 302,932 | 316,912 | -13,980 | Decrease | 207,342 | 95,590 | Above Average |
| 2011 | Road-250 Red- 44 | 4,886 | NULL | NULL | No Change | 175,896 | -171,010 | Below Average |
| 2012 | Road-250 Red- 44 | 346,906 | 4,886 | 342,020 | Increase | 175,896 | 171,010 | Above Average |
| 2011 | Road-250 Red- 48 | 7,329 | NULL | NULL | No Change | 197,883 | -190,554 | Below Average |
| 2012 | Road-250 Red- 48 | 388,437 | 7,329 | 381,108 | Increase | 197,883 | 190,554 | Above Average |
| 2011 | Road-250 Red- 52 | 2,443 | NULL | NULL | No Change | 162,460 | -160,017 | Below Average |
| 2012 | Road-250 Red- 52 | 322,476 | 2,443 | 320,033 | Increase | 162,460 | 160,016 | Above Average |
| 2011 | Road-250 Red- 58 | 6,546 | NULL | NULL | No Change | 234,222 | -227,676 | Below Average |
| 2012 | Road-250 Red- 58 | 376,087 | 6,546 | 369,541 | Increase | 234,222 | 141,865 | Above Average |
| 2013 | Road-250 Red- 58 | 320,033 | 376,087 | -56,054 | Decrease | 234,222 | 85,811 | Above Average |
| 2012 | Road-350-W Yellow- 40 | 1,701 | NULL | NULL | No Change | 209,223 | -207,522 | Below Average |
| 2013 | Road-350-W Yellow- 40 | 416,745 | 1,701 | 415,044 | Increase | 209,223 | 207,522 | Above Average |
| 2012 | Road-350-W Yellow- 42 | 5,103 | NULL | NULL | No Change | 199,868 | -194,765 | Below Average |
| 2013 | Road-350-W Yellow- 42 | 394,632 | 5,103 | 389,529 | Increase | 199,868 | 194,764 | Above Average |
| 2013 | Road-350-W Yellow- 44 | 367,416 | NULL | NULL | No Change | 367,416 | 0 | Average |
| 2012 | Road-350-W Yellow- 48 | 1,701 | NULL | NULL | No Change | 197,316 | -195,615 | Below Average |
| 2013 | Road-350-W Yellow- 48 | 392,931 | 1,701 | 391,230 | Increase | 197,316 | 195,615 | Above Average |
| 2011 | Road-550-W Yellow- 38 | 1,000 | NULL | NULL | No Change | 97,920 | -96,920 | Below Average |
| 2012 | Road-550-W Yellow- 38 | 71,000 | 1,000 | 70,000 | Increase | 97,920 | -26,920 | Below Average |
| 2013 | Road-550-W Yellow- 38 | 221,760 | 71,000 | 150,760 | Increase | 97,920 | 123,840 | Above Average |
| 2012 | Road-550-W Yellow- 40 | 68,120 | NULL | NULL | No Change | 144,940 | -76,820 | Below Average |
| 2013 | Road-550-W Yellow- 40 | 221,760 | 68,120 | 153,640 | Increase | 144,940 | 76,820 | Above Average |
| 2011 | Road-550-W Yellow- 42 | 1,000 | NULL | NULL | No Change | 111,480 | -110,480 | Below Average |
| 2012 | Road-550-W Yellow- 42 | 68,000 | 1,000 | 67,000 | Increase | 111,480 | -43,480 | Below Average |
| 2013 | Road-550-W Yellow- 42 | 265,440 | 68,000 | 197,440 | Increase | 111,480 | 153,960 | Above Average |
| 2012 | Road-550-W Yellow- 44 | 78,120 | NULL | NULL | No Change | 156,100 | -77,980 | Below Average |
| 2013 | Road-550-W Yellow- 44 | 234,080 | 78,120 | 155,960 | Increase | 156,100 | 77,980 | Above Average |
| 2012 | Road-550-W Yellow- 48 | 74,240 | NULL | NULL | No Change | 141,840 | -67,600 | Below Average |
| 2013 | Road-550-W Yellow- 48 | 209,440 | 74,240 | 135,200 | Increase | 141,840 | 67,600 | Above Average |
| 2011 | Road-650 Black- 44 | 14,679 | NULL | NULL | No Change | 23,783 | -9,104 | Below Average |
| 2012 | Road-650 Black- 44 | 32,886 | 14,679 | 18,207 | Increase | 23,783 | 9,103 | Above Average |
| 2011 | Road-650 Black- 48 | 11,883 | NULL | NULL | No Change | 22,776 | -10,893 | Below Average |
| 2012 | Road-650 Black- 48 | 33,669 | 11,883 | 21,786 | Increase | 22,776 | 10,893 | Above Average |
| 2011 | Road-650 Black- 52 | 23,067 | NULL | NULL | No Change | 33,458 | -10,391 | Below Average |
| 2012 | Road-650 Black- 52 | 43,848 | 23,067 | 20,781 | Increase | 33,458 | 10,390 | Above Average |
| 2011 | Road-650 Black- 58 | 12,582 | NULL | NULL | No Change | 28,998 | -16,416 | Below Average |
| 2012 | Road-650 Black- 58 | 45,414 | 12,582 | 32,832 | Increase | 28,998 | 16,416 | Above Average |
| 2011 | Road-650 Black- 60 | 19,572 | NULL | NULL | No Change | 28,578 | -9,006 | Below Average |
| 2012 | Road-650 Black- 60 | 37,584 | 19,572 | 18,012 | Increase | 28,578 | 9,006 | Above Average |
| 2010 | Road-650 Black- 62 | 699 | NULL | NULL | No Change | 16,349 | -15,650 | Below Average |
| 2011 | Road-650 Black- 62 | 14,679 | 699 | 13,980 | Increase | 16,349 | -1,670 | Below Average |
| 2012 | Road-650 Black- 62 | 33,669 | 14,679 | 18,990 | Increase | 16,349 | 17,320 | Above Average |
| 2011 | Road-650 Red- 44 | 15,378 | NULL | NULL | No Change | 27,264 | -11,886 | Below Average |
| 2012 | Road-650 Red- 44 | 39,150 | 15,378 | 23,772 | Increase | 27,264 | 11,886 | Above Average |
| 2011 | Road-650 Red- 48 | 18,957 | NULL | NULL | No Change | 33,360 | -14,403 | Below Average |
| 2012 | Road-650 Red- 48 | 47,763 | 18,957 | 28,806 | Increase | 33,360 | 14,403 | Above Average |
| 2010 | Road-650 Red- 52 | 699 | NULL | NULL | No Change | 15,361 | -14,662 | Below Average |
| 2011 | Road-650 Red- 52 | 14,064 | 699 | 13,365 | Increase | 15,361 | -1,297 | Below Average |
| 2012 | Road-650 Red- 52 | 31,320 | 14,064 | 17,256 | Increase | 15,361 | 15,959 | Above Average |
| 2011 | Road-650 Red- 58 | 13,281 | NULL | NULL | No Change | 28,173 | -14,892 | Below Average |
| 2012 | Road-650 Red- 58 | 43,065 | 13,281 | 29,784 | Increase | 28,173 | 14,892 | Above Average |
| 2011 | Road-650 Red- 60 | 11,883 | NULL | NULL | No Change | 20,036 | -8,153 | Below Average |
| 2012 | Road-650 Red- 60 | 28,188 | 11,883 | 16,305 | Increase | 20,036 | 8,152 | Above Average |
| 2011 | Road-650 Red- 62 | 11,967 | NULL | NULL | No Change | 28,691 | -16,724 | Below Average |
| 2012 | Road-650 Red- 62 | 45,414 | 11,967 | 33,447 | Increase | 28,691 | 16,723 | Above Average |
| 2012 | Road-750 Black- 44 | 1,620 | NULL | NULL | No Change | 97,200 | -95,580 | Below Average |
| 2013 | Road-750 Black- 44 | 192,780 | 1,620 | 191,160 | Increase | 97,200 | 95,580 | Above Average |
| 2012 | Road-750 Black- 48 | 1,080 | NULL | NULL | No Change | 98,010 | -96,930 | Below Average |
| 2013 | Road-750 Black- 48 | 194,940 | 1,080 | 193,860 | Increase | 98,010 | 96,930 | Above Average |
| 2012 | Road-750 Black- 52 | 2,160 | NULL | NULL | No Change | 104,220 | -102,060 | Below Average |
| 2013 | Road-750 Black- 52 | 206,280 | 2,160 | 204,120 | Increase | 104,220 | 102,060 | Above Average |
| 2012 | Road-750 Black- 58 | 1,080 | NULL | NULL | No Change | 90,180 | -89,100 | Below Average |
| 2013 | Road-750 Black- 58 | 179,280 | 1,080 | 178,200 | Increase | 90,180 | 89,100 | Above Average |
| 2012 | Short-Sleeve Classic Jersey- L | 108 | NULL | NULL | No Change | 6,732 | -6,624 | Below Average |
| 2013 | Short-Sleeve Classic Jersey- L | 19,764 | 108 | 19,656 | Increase | 6,732 | 13,032 | Above Average |
| 2014 | Short-Sleeve Classic Jersey- L | 324 | 19,764 | -19,440 | Decrease | 6,732 | -6,408 | Below Average |
| 2012 | Short-Sleeve Classic Jersey- M | 54 | NULL | NULL | No Change | 7,326 | -7,272 | Below Average |
| 2013 | Short-Sleeve Classic Jersey- M | 20,790 | 54 | 20,736 | Increase | 7,326 | 13,464 | Above Average |
| 2014 | Short-Sleeve Classic Jersey- M | 1,134 | 20,790 | -19,656 | Decrease | 7,326 | -6,192 | Below Average |
| 2012 | Short-Sleeve Classic Jersey- S | 54 | NULL | NULL | No Change | 7,308 | -7,254 | Below Average |
| 2013 | Short-Sleeve Classic Jersey- S | 21,384 | 54 | 21,330 | Increase | 7,308 | 14,076 | Above Average |
| 2014 | Short-Sleeve Classic Jersey- S | 486 | 21,384 | -20,898 | Decrease | 7,308 | -6,822 | Below Average |
| 2013 | Short-Sleeve Classic Jersey- XL | 21,168 | NULL | NULL | No Change | 11,043 | 10,125 | Above Average |
| 2014 | Short-Sleeve Classic Jersey- XL | 918 | 21,168 | -20,250 | Decrease | 11,043 | -10,125 | Below Average |
| 2012 | Sport-100 Helmet- Black | 210 | NULL | NULL | No Change | 24,325 | -24,115 | Below Average |
| 2013 | Sport-100 Helmet- Black | 69,895 | 210 | 69,685 | Increase | 24,325 | 45,570 | Above Average |
| 2014 | Sport-100 Helmet- Black | 2,870 | 69,895 | -67,025 | Decrease | 24,325 | -21,455 | Below Average |
| 2012 | Sport-100 Helmet- Blue | 350 | NULL | NULL | No Change | 24,792 | -24,442 | Below Average |
| 2013 | Sport-100 Helmet- Blue | 71,050 | 350 | 70,700 | Increase | 24,792 | 46,258 | Above Average |
| 2014 | Sport-100 Helmet- Blue | 2,975 | 71,050 | -68,075 | Decrease | 24,792 | -21,817 | Below Average |
| 2012 | Sport-100 Helmet- Red | 350 | NULL | NULL | No Change | 26,017 | -25,667 | Below Average |
| 2013 | Sport-100 Helmet- Red | 75,145 | 350 | 74,795 | Increase | 26,017 | 49,128 | Above Average |
| 2014 | Sport-100 Helmet- Red | 2,555 | 75,145 | -72,590 | Decrease | 26,017 | -23,462 | Below Average |
| 2012 | Touring Tire | 58 | NULL | NULL | No Change | 9,038 | -8,980 | Below Average |
| 2013 | Touring Tire | 25,607 | 58 | 25,549 | Increase | 9,038 | 16,569 | Above Average |
| 2014 | Touring Tire | 1,450 | 25,607 | -24,157 | Decrease | 9,038 | -7,588 | Below Average |
| 2012 | Touring Tire Tube | 10 | NULL | NULL | No Change | 2,478 | -2,468 | Below Average |
| 2013 | Touring Tire Tube | 7,010 | 10 | 7,000 | Increase | 2,478 | 4,532 | Above Average |
| 2014 | Touring Tire Tube | 415 | 7,010 | -6,595 | Decrease | 2,478 | -2,063 | Below Average |
| 2012 | Touring-1000 Blue- 46 | 4,768 | NULL | NULL | No Change | 210,984 | -206,216 | Below Average |
| 2013 | Touring-1000 Blue- 46 | 417,200 | 4,768 | 412,432 | Increase | 210,984 | 206,216 | Above Average |
| 2012 | Touring-1000 Blue- 50 | 2,384 | NULL | NULL | No Change | 178,800 | -176,416 | Below Average |
| 2013 | Touring-1000 Blue- 50 | 355,216 | 2,384 | 352,832 | Increase | 178,800 | 176,416 | Above Average |
| 2013 | Touring-1000 Blue- 54 | 381,440 | NULL | NULL | No Change | 381,440 | 0 | Average |
| 2012 | Touring-1000 Blue- 60 | 2,384 | NULL | NULL | No Change | 175,224 | -172,840 | Below Average |
| 2013 | Touring-1000 Blue- 60 | 348,064 | 2,384 | 345,680 | Increase | 175,224 | 172,840 | Above Average |
| 2013 | Touring-1000 Yellow- 46 | 410,048 | NULL | NULL | No Change | 410,048 | 0 | Average |
| 2012 | Touring-1000 Yellow- 50 | 4,768 | NULL | NULL | No Change | 179,992 | -175,224 | Below Average |
| 2013 | Touring-1000 Yellow- 50 | 355,216 | 4,768 | 350,448 | Increase | 179,992 | 175,224 | Above Average |
| 2013 | Touring-1000 Yellow- 54 | 376,672 | NULL | NULL | No Change | 376,672 | 0 | Average |
| 2013 | Touring-1000 Yellow- 60 | 333,760 | NULL | NULL | No Change | 333,760 | 0 | Average |
| 2012 | Touring-2000 Blue- 46 | 2,430 | NULL | NULL | No Change | 58,928 | -56,498 | Below Average |
| 2013 | Touring-2000 Blue- 46 | 115,425 | 2,430 | 112,995 | Increase | 58,928 | 56,497 | Above Average |
| 2012 | Touring-2000 Blue- 50 | 1,215 | NULL | NULL | No Change | 64,395 | -63,180 | Below Average |
| 2013 | Touring-2000 Blue- 50 | 127,575 | 1,215 | 126,360 | Increase | 64,395 | 63,180 | Above Average |
| 2013 | Touring-2000 Blue- 54 | 106,920 | NULL | NULL | No Change | 106,920 | 0 | Average |
| 2012 | Touring-2000 Blue- 60 | 1,215 | NULL | NULL | No Change | 49,208 | -47,993 | Below Average |
| 2013 | Touring-2000 Blue- 60 | 97,200 | 1,215 | 95,985 | Increase | 49,208 | 47,992 | Above Average |
| 2013 | Touring-3000 Blue- 44 | 39,326 | NULL | NULL | No Change | 39,326 | 0 | Average |
| 2013 | Touring-3000 Blue- 50 | 35,616 | NULL | NULL | No Change | 35,616 | 0 | Average |
| 2012 | Touring-3000 Blue- 54 | 742 | NULL | NULL | No Change | 20,405 | -19,663 | Below Average |
| 2013 | Touring-3000 Blue- 54 | 40,068 | 742 | 39,326 | Increase | 20,405 | 19,663 | Above Average |
| 2013 | Touring-3000 Blue- 58 | 42,294 | NULL | NULL | No Change | 42,294 | 0 | Average |
| 2013 | Touring-3000 Blue- 62 | 47,488 | NULL | NULL | No Change | 47,488 | 0 | Average |
| 2013 | Touring-3000 Yellow- 44 | 43,778 | NULL | NULL | No Change | 43,778 | 0 | Average |
| 2013 | Touring-3000 Yellow- 50 | 43,778 | NULL | NULL | No Change | 43,778 | 0 | Average |
| 2013 | Touring-3000 Yellow- 54 | 35,616 | NULL | NULL | No Change | 35,616 | 0 | Average |
| 2012 | Touring-3000 Yellow- 58 | 1,484 | NULL | NULL | No Change | 17,437 | -15,953 | Below Average |
| 2013 | Touring-3000 Yellow- 58 | 33,390 | 1,484 | 31,906 | Increase | 17,437 | 15,953 | Above Average |
| 2013 | Touring-3000 Yellow- 62 | 37,100 | NULL | NULL | No Change | 37,100 | 0 | Average |
| 2012 | Water Bottle - 30 oz. | 90 | NULL | NULL | No Change | 7,082 | -6,992 | Below Average |
| 2013 | Water Bottle - 30 oz. | 20,425 | 90 | 20,335 | Increase | 7,082 | 13,343 | Above Average |
| 2014 | Water Bottle - 30 oz. | 730 | 20,425 | -19,695 | Decrease | 7,082 | -6,352 | Below Average |
| 2013 | Women's Mountain Shorts- L | 23,800 | NULL | NULL | No Change | 12,705 | 11,095 | Above Average |
| 2014 | Women's Mountain Shorts- L | 1,610 | 23,800 | -22,190 | Decrease | 12,705 | -11,095 | Below Average |
| 2013 | Women's Mountain Shorts- M | 23,380 | NULL | NULL | No Change | 12,320 | 11,060 | Above Average |
| 2014 | Women's Mountain Shorts- M | 1,260 | 23,380 | -22,120 | Decrease | 12,320 | -11,060 | Below Average |
| 2013 | Women's Mountain Shorts- S | 20,230 | NULL | NULL | No Change | 10,640 | 9,590 | Above Average |
| 2014 | Women's Mountain Shorts- S | 1,050 | 20,230 | -19,180 | Decrease | 10,640 | -9,590 | Below Average |

---

