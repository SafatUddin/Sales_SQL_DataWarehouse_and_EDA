# 🏢 Sales SQL Data Warehouse

<div align="center">

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)](https://www.microsoft.com/en-us/sql-server)
[![T-SQL](https://img.shields.io/badge/T--SQL-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)](https://docs.microsoft.com/en-us/sql/t-sql/)
[![Data Warehouse](https://img.shields.io/badge/Data%20Warehouse-FF6F00?style=for-the-badge&logo=apache%20spark&logoColor=white)](https://en.wikipedia.org/wiki/Data_warehouse)
[![Medallion Architecture](https://img.shields.io/badge/Medallion%20Architecture-4B0082?style=for-the-badge&logo=databricks&logoColor=white)](https://www.databricks.com/glossary/medallion-architecture)
[![Star Schema](https://img.shields.io/badge/Star%20Schema-FFD700?style=for-the-badge&logo=star&logoColor=black)](https://en.wikipedia.org/wiki/Star_schema)

**A modern, enterprise-grade data warehouse solution for sales analytics and business intelligence.**

[Getting Started](#-getting-started) • [Architecture](#-data-architecture) • [Documentation](#-documentation) • [Analytics](#-business-intelligence--analytics) • [Credits](#-credits)

</div>

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Data Architecture](#-data-architecture)
- [Project Structure](#-project-structure)
- [Data Sources](#-data-sources)
- [ETL Pipeline](#-etl-pipeline)
- [Data Modeling](#-data-modeling)
- [Business Intelligence & Analytics](#-business-intelligence--analytics)
- [Credits](#-credits)
- [Getting Started](#-getting-started)
- [Key Features](#-key-features)
- [Documentation](#-documentation)
- [Performance Optimization](#-performance-optimization)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## 🎯 Project Overview

This project demonstrates the end-to-end development of a **modern data warehouse** using Microsoft SQL Server, designed to consolidate disparate sales data into a unified, analytics-ready platform. By transforming raw operational data from multiple source systems into structured dimensional models, this warehouse enables high-performance business intelligence, trend analysis, and data-driven decision-making.

### 🎯 Objectives

- **Centralize** sales data from multiple operational systems (ERP & CRM) into a single source of truth
- **Cleanse & Standardize** raw data to ensure quality, consistency, and reliability
- **Model** data using industry-standard star schema optimized for analytical workloads
- **Enable** self-service business intelligence and advanced analytics capabilities
- **Deliver** actionable insights into customer behavior, product performance, and sales trends

---

## 🏗️ Data Architecture

The warehouse follows the **Medallion Architecture** pattern, organizing data into three distinct layers that progressively increase in quality and business value.

<div align="center">

![Data Architecture](./Docs/DataArchitecture.png)
*Figure 1: High-level Medallion Architecture showing data flow from source systems through Bronze, Silver, and Gold layers.*

</div>

### 🥉 Bronze Layer — Raw Data Ingestion

- **Purpose:** Landing zone for raw, unmodified data from source systems
- **Characteristics:**
  - Data ingested "as-is" from CSV exports
  - Preserves original source structure and granularity
  - Acts as the historical archive and single source of truth
  - Minimal transformations (only type casting if necessary)

### 🥈 Silver Layer — Cleansed & Integrated

- **Purpose:** Data cleansing, standardization, and integration
- **Characteristics:**
  - Handles data quality issues (nulls, duplicates, invalid formats)
  - Standardizes naming conventions, date formats, and categorical values
  - Merges related datasets from ERP and CRM systems
  - Applies business rules and derived calculations
  - Removes or quarantines anomalous records

### 🥇 Gold Layer — Business-Ready Analytics

- **Purpose:** Curated, business-level data models for reporting
- **Characteristics:**
  - Dimensional modeling using **Star Schema**
  - Optimized for fast analytical queries and BI tool consumption
  - Contains fully aggregated and enriched datasets
  - Serves as the primary interface for analysts and business users

<div align="center">

![Data Flow](./Docs/DataFlow.png)
*Figure 2: Detailed data flow diagram showing ETL processes between architecture layers.*

</div>

---

## 📂 Project Structure

```text
Sales_SQL_DataWarehouse/
│
├── 📁 datasets/                          # Raw source data files (CSV)
│   ├── crm/                              # Customer Relationship Management data
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── erp/                              # Enterprise Resource Planning data
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── 📁 docs/                              # Project documentation & diagrams
│   ├── data_architecture.drawio          # Architecture diagram source
│   ├── data_architecture.png             # High-level architecture visualization
│   ├── data_flow.drawio                  # Data flow diagram source
│   ├── data_flow.png                     # ETL process visualization
│   ├── data_models.drawio                # Star schema diagram source
│   ├── data_models.png                   # Dimensional model visualization
│   ├── data_catalog.md                   # Data dictionary and metadata
│   └── naming_conventions.md             # Standard naming guidelines
│
├── 📁 scripts/                           # SQL scripts organized by layer
│   ├── 🥉 bronze/
│   │   ├── create_bronze_schema.sql
│   │   ├── load_crm_data.sql
│   │   └── load_erp_data.sql
│   ├── 🥈 silver/
│   │   ├── create_silver_schema.sql
│   │   ├── clean_crm_customers.sql
│   │   ├── clean_crm_products.sql
│   │   ├── clean_erp_customers.sql
│   │   ├── clean_erp_locations.sql
│   │   └── merge_cleaned_data.sql
│   └── 🥇 gold/
│       ├── create_gold_schema.sql
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       ├── dim_date.sql
│       └── fact_sales.sql
│
├── 📄 README.md                          # Project documentation (this file)
├── 📄 LICENSE                            # MIT License
└── 📄 .gitignore                         # Git ignore rules
```

---

## 📊 Data Sources

This warehouse integrates data from two primary operational systems:

| Source System | Files | Description |
|--------------|-------|-------------|
| **CRM** | `cust_info.csv`, `prd_info.csv`, `sales_details.csv` | Customer profiles, product catalog, and transactional sales records |
| **ERP** | `CUST_AZ12.csv`, `LOC_A101.csv`, `PX_CAT_G1V2.csv` | Extended customer attributes, geographic locations, and product categorizations |

### Data Integration Strategy

<div align="center">

![Data Integration](./Docs/Data_Integration.png)
*Figure 3: Data integration mapping showing how CRM and ERP datasets are merged and enriched.*

</div>

---

## 🔄 ETL Pipeline

The Extract, Transform, Load (ETL) process is implemented entirely in **T-SQL**, ensuring optimal performance and maintainability within the SQL Server ecosystem.

### Phase 1: Extract (Bronze Layer)

```sql
-- Example: Loading raw CRM customer data
BULK INSERT bronze.crm_customers
FROM 'datasets/crm/cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
```

### Phase 2: Transform (Silver Layer)

- **Cleansing:** Remove duplicates, handle nulls, standardize formats
- **Integration:** Join CRM and ERP datasets using business keys
- **Enrichment:** Calculate derived fields (age groups, full addresses, product hierarchies)
- **Validation:** Apply data quality rules and quarantine invalid records

### Phase 3: Load (Gold Layer)

- **Dimensional Loading:** Populate dimension tables with surrogate keys
- **Fact Loading:** Insert transactional records linking to dimension keys
- **Indexing:** Apply clustered columnstore indexes for analytical performance

<div align="center">

![ETL Process](./Docs/DataLayers.png)
*Figure 4: ETL pipeline workflow showing transformation logic between layers.*

</div>

---

## 🎲 Data Modeling

The Gold Layer implements a **Star Schema** optimized for OLAP (Online Analytical Processing) workloads.

<div align="center">

![Star Schema](./Docs/DataModel.png)
*Figure 5: Dimensional model (Star Schema) showing relationships between fact and dimension tables.*

</div>

### Dimension Tables

| Table | Description | Key Attributes |
|-------|-------------|----------------|
| `dim_customers` | Customer master data | Customer ID, Name, Gender, Location, Age Group, Lifetime Value |
| `dim_products` | Product catalog | Product ID, Name, Category, Subcategory, Unit Price, Cost |
| `dim_date` | Time dimension | Date Key, Full Date, Day, Month, Quarter, Year, Fiscal Period |

### Fact Table

| Table | Description | Measures |
|-------|-------------|----------|
| `fact_sales` | Transactional sales records | Quantity, Unit Price, Discount, Sales Amount, Cost Amount, Profit |

### Schema Relationships

- **One-to-Many** relationships from dimensions to the central fact table
- **Surrogate Keys** used for optimal join performance and historical tracking
- **Foreign Key Constraints** ensure referential integrity

---

## 📈 Business Intelligence & Analytics

The warehouse supports comprehensive analytics across three key business domains:

### 1. Customer Behavior Analysis

- Customer segmentation by demographics and purchase patterns
- Cohort analysis and retention metrics
- Customer lifetime value (CLV) calculations
- RFM Analysis (Recency, Frequency, Monetary)

### 2. Product Performance Metrics

- Top-performing products and categories
- Product profitability and margin analysis
- Inventory turnover and demand forecasting inputs
- Cross-sell and upsell opportunity identification

### 3. Sales Trends & KPIs

- Year-over-year (YoY) and month-over-month (MoM) growth
- Seasonal trend analysis
- Regional sales performance comparison
- Revenue forecasting and target tracking

<!-- <div align="center">

![Analytics Dashboard](docs/analytics_dashboard.png)
*Figure 6: Sample analytics dashboard showing key business metrics and visualizations.*

</div> -->

---

## 📚 Credits

- **Inspired by**: [DatawithBaraa](https://github.com/DataWithBaraa)'s [Data Warehouse Tutorial](https://youtu.be/9GVqKuTVANE?si=MJRXLn7pgH_2yBRu)
- **Developed by**: Safat Uddin

---

## 🚀 Getting Started

### Prerequisites

- **Microsoft SQL Server / MySQL**
- **SQL Server Management Studio (SSMS)** or **Azure Data Studio** or **MySQL Workbench**
- **Git** for version control

### Installation & Setup

1. **Clone the repository**
   
   ```bash
   git clone https://github.com/SafatUddin/Sales_SQL_DataWarehouse.git
   cd Sales_SQL_DataWarehouse
   ```
2. **Create the database**
   
   ```sql
   -- For Microsft SQL Server
   CREATE DATABASE SalesDataWarehouse;
   GO
   USE SalesDataWarehouse;
   ```
3. **Execute scripts in order**
   
   ```sql
   -- 1. Initialize schemas
   :r scripts/bronze/create_bronze_schema.sql
   :r scripts/silver/create_silver_schema.sql
   :r scripts/gold/create_gold_schema.sql
   
   -- 2. Load Bronze layer
   :r scripts/bronze/load_crm_data.sql
   :r scripts/bronze/load_erp_data.sql
   
   -- 3. Transform to Silver
   :r scripts/silver/clean_crm_customers.sql
   :r scripts/silver/clean_crm_products.sql
   :r scripts/silver/merge_cleaned_data.sql
   
   -- 4. Build Gold layer
   :r scripts/gold/dim_customers.sql
   :r scripts/gold/dim_products.sql
   :r scripts/gold/dim_date.sql
   :r scripts/gold/fact_sales.sql
   ```

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **🏗️ Medallion Architecture** | Three-tier data organization ensuring data quality and traceability |
| **⭐ Star Schema Modeling** | Optimized dimensional model for fast analytical queries |
| **🔍 Data Quality Framework** | Comprehensive validation and cleansing rules |
| **📊 BI-Ready Datasets** | Gold layer designed for direct consumption by reporting tools |
| **⚡ Performance Tuned** | Strategic indexing and partitioning strategies |
| **📝 Full Documentation** | Complete data catalog and lineage documentation |
| **🔄 Reproducible ETL** | Idempotent SQL scripts for consistent deployments |

---

## 📚 Documentation

Comprehensive documentation is available in the `docs/` directory:

| Document | Description |
|----------|-------------|
| `data_catalog.md` | Complete data dictionary with field descriptions and metadata |
| `naming_conventions.md` | Standardized naming guidelines for maintainability |
| `data_architecture.png` | Architecture diagrams |
| `data_models.png` | Star schema diagrams |

---

## ⚡ Performance Optimization

The warehouse implements several performance strategies:

- **Clustered Columnstore Indexes** on fact tables for analytical compression and query speed
- **Non-clustered Indexes** on dimension table surrogate keys for efficient joins
- **Partitioning** on date columns for manageable data archiving and query pruning
- **Statistics Maintenance** automated for optimal query plan generation

---

## 🔮 Future Enhancements

- [ ] Implement Slowly Changing Dimensions (SCD Type 2) for historical tracking
- [ ] Add incremental load patterns for near real-time data ingestion
- [ ] Develop Power BI/Tableau dashboard templates
- [ ] Implement row-level security for multi-tenant access
- [ ] Add automated data quality monitoring and alerting
- [ ] Migrate to cloud-native Azure Synapse Analytics

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows the project's naming conventions and includes appropriate tests.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 📬 Contact

**Safat Uddin** — [GitHub Profile](https://github.com/SafatUddin)

**Project Link**: [Sales_SQL_DataWarehouse](https://github.com/SafatUddin/Sales_SQL_DataWarehouse)

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

</div>

