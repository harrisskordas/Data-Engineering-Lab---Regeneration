# Data Engineering Lab, powered by TITAN and ReGeneration

# Team Members:
Georgos Valavanis, Michael Voutyritsas, Elisavet Kavoura, Evaggelos Stergiou, Charisis Skordas

# Final Project Report: Data Warehouse Development for "Cataschevastika"

## Project Overview

In this final project, we developed a robust Data Warehouse for a company called **Cataschevastika**. The project was divided into three main phases:

1. **Data Lake Creation and Deployment**
2. **Advanced Analytical Capabilities for Sales Decision-Making**
3. **Business Insights Enhancement Using Power BI**

## Detailed Project Timeline

### 1. Update of the OLTP Database
We began by updating the **Online Transaction Processing (OLTP)** database to meet the new requirements. This involved adding additional tables to our existing OLTP database, which was insufficient for our needs.

### 2. Creation of the Data Warehouse
The creation of the Data Warehouse was a multi-step process:
1. **Staging**: Data was extracted from the OLTP system and loaded into the staging area.
2. **Fact Tables**: Fact tables were designed and created to store quantitative data for analysis.
3. **View of Tables**: Logical views of tables were created to simplify complex queries.
4. **Slowly Changing Dimensions (SCD) Type 2**: Implemented row versioning to handle historical data changes over time.

### 3. Creation of the Data Lake
We deployed the local Data Warehouse to **Azure Data Lake**, which provided scalable and secure storage for structured and unstructured data.

### 4. Databricks ML for Sales Prediction
Utilizing **Databricks** and **PySpark**, we developed a sales prediction model using **K-Means clustering**. This machine learning model helped in forecasting sales and identifying trends.

### 5. Visualization of Results Using Power BI
The final phase involved visualizing the results and insights gained from the Data Warehouse and ML models using **Power BI**. This enabled stakeholders to make data-driven decisions through interactive and intuitive dashboards.

## Conclusion

This project significantly enhanced the data capabilities of **Cataschevastika**, providing them with a modern Data Warehouse, advanced analytical tools, and insightful visualizations. These improvements are expected to drive better business decisions and strategic planning.

Feel free to customize or add any additional details to this report as needed.

