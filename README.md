# Retail Sales Analytics — SQL Project

## Overview
End-to-end data analytics project analyzing **9,994 retail transactions** from a 
US superstore using MySQL. This project demonstrates real-world business analytics 
using advanced SQL techniques.

## Business Questions Answered
- What is the overall revenue, profit, and profit margin?
- How has revenue grown year over year?
- Which regions and customer segments perform best?
- Who are the top customers and most profitable products?
- How do discounts impact profitability?
- What shipping modes are most efficient?

## SQL Concepts Used
- Window Functions: `ROW_NUMBER()`, `DENSE_RANK()`, `LAG()`
- Common Table Expressions (CTEs)
- Aggregate Functions with `GROUP BY`
- `CASE WHEN` for conditional bucketing
- `DATEDIFF()` for time-based analysis
- Running totals and cumulative revenue

## Project Structure
retail-sales-analytics/
│
├── Data/
│   └── superstore.csv        # Raw dataset (9,994 rows)
│
├── SQL/
│   ├── setup.sql             # Database and table creation
│   └── analysis.sql          # 15 business analytics queries
│
└── README.md
## Key Insights Found
- **West region** has highest revenue ($725K) and best profit margin (14.94%)
- **High discounts (40%+)** cause average loss of -$106 per order
- **Technology** category has highest profit margins
- **Tables** sub-category consistently loses money despite high sales
- Business revenue grew **29.47%** in 2020 and **20.36%** in 2021

## Dataset
- Source: Sample Superstore Dataset
- Rows: 9,994 transactions
- Period: 2018–2021
- Fields: Orders, Customers, Products, Sales, Profit, Region, Shipping

## Tools Used
- MySQL 8.0
- MySQL Workbench
- Git & GitHub
