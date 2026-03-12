# Lakehouse Data Processing

## Overview

This document describes the data processing workflow implemented in the **Microsoft Fabric Lakehouse layer**.

The purpose of this layer is to transform the **raw CSV dataset** into a **clean, structured Delta table** that can be used as the source for the downstream **Fabric Data Warehouse**.

The transformation process is implemented using **PySpark notebooks** inside Microsoft Fabric.

---

# Architecture Flow

The Lakehouse processing layer follows a structured transformation pipeline.

```
Raw CSV Dataset
        ↓
Lakehouse Files Storage
        ↓
Data Profiling Notebook
        ↓
Data Quality Analysis Notebook
        ↓
Data Cleaning & Transformation Notebook
        ↓
Delta Table (clean_exim_authorizations)
        ↓
Fabric Warehouse (Staging Layer)
```

This approach separates **data exploration**, **data validation**, and **data transformation**, which is a common best practice in modern data engineering pipelines.

---

# Source Dataset

The dataset is uploaded as a CSV file into the Fabric Lakehouse file storage.

```
Files/exim_authorizations.csv
```

Dataset characteristics:

| Property       | Value                          |
| -------------- | ------------------------------ |
| Rows           | 51,122                         |
| Columns        | 34                             |
| Format         | CSV                            |
| Initial Schema | All columns inferred as STRING |

Because CSV files do not store schema information, all fields are initially ingested as **string types**.

The Lakehouse processing pipeline converts these fields into appropriate data types.

---

# Notebook Pipeline

The transformation workflow is implemented using three separate notebooks.

---

# 1. Data Profiling Notebook

Notebook:

```
lakehouse/notebooks/01_data_profiling.ipynb
```

## Purpose

The profiling notebook performs an **initial structural analysis** of the dataset.

This step helps engineers understand the dataset before applying any transformations.

## Operations Performed

* Row count validation
* Column count verification
* Schema inspection
* Basic statistical summary

Example checks performed:

```
df.count()
len(df.columns)
df.printSchema()
df.describe()
```

This notebook **does not modify the dataset**.

It is purely exploratory.

---

# 2. Data Quality Analysis Notebook

Notebook:

```
lakehouse/notebooks/02_data_quality_analysis.ipynb
```

## Purpose

The goal of this notebook is to evaluate **data quality issues** that must be addressed before transformation.

## Quality Checks

The following checks are performed:

### Missing Value Analysis

Counts NULL values across all columns.

### Duplicate Detection

Verifies whether duplicate records exist.

### Categorical Cardinality

Examines unique values for important categorical fields such as:

* Country
* Program

### Numeric Field Inspection

Certain numeric columns are stored as strings in the raw dataset.

Examples:

* Approved/Declined Amount
* Disbursed/Shipped Amount
* Outstanding Exposure Amount
* Loan Interest Rate

These fields must be converted to numeric types during the cleaning phase.

---

# 3. Data Cleaning and Transformation Notebook

Notebook:

```
lakehouse/notebooks/03_data_cleaning.ipynb
```

## Purpose

This notebook performs the core data transformation process required to prepare the dataset for analytical workloads.

## Transformations Applied

### Missing Value Handling

Values such as:

```
N/A
```

are replaced with NULL values.

### Data Type Conversion

Columns are converted to appropriate types.

Examples:

| Column               | Target Type |
| -------------------- | ----------- |
| Fiscal Year          | integer     |
| Decision Date        | date        |
| Effective Date       | date        |
| Expiration Date      | date        |
| Approved Amount      | double      |
| Disbursed Amount     | double      |
| Outstanding Exposure | double      |

### Boolean Conversion

Columns containing Yes/No values are converted to boolean types.

Examples:

* brokered
* deal_cancelled

### Column Name Standardization

All column names are converted to **snake_case** to follow standard data engineering naming conventions.

Example transformations:

```
Fiscal Year → fiscal_year
Decision Date → decision_date
Primary Exporter City → primary_exporter_city
Approved/Declined Amount → approved_declined_amount
```

This improves compatibility with SQL-based analytical tools and warehouse modeling.

---

# Delta Table Creation

After the transformations are complete, the cleaned dataset is written to a **Delta Lake table**.

```
clean_exim_data
```

Example write operation:

```
df.write.format("delta") \
.mode("overwrite") \
.saveAsTable("clean_exim_authorizations")
```

## Why Delta Format?

Delta Lake provides several advantages for analytical workloads:

* ACID transactions
* Schema enforcement
* Efficient query performance
* Compatibility with SQL engines
* Incremental processing support

Delta tables are the recommended storage format for structured data in Microsoft Fabric Lakehouse environments.

---

# Output Dataset

The final cleaned dataset is stored as:

```
clean_exim_data
```

This dataset serves as the **source table for the Fabric Warehouse ingestion process**, where the dimensional data model will be implemented.

---

# Next Step in the Architecture

After the Lakehouse transformation stage, the dataset will be ingested into the **Fabric Data Warehouse** using SQL-based ingestion.

```
Lakehouse Delta Table
        ↓
COPY INTO
        ↓
Warehouse Staging Layer
        ↓
Dimensional Model (Star Schema)
        ↓
Power BI Semantic Model
```

