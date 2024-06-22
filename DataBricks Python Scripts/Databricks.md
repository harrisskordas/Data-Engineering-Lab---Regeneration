# Databricks

After the CSV was exported from the view, containing attributes such as **total_products_ordered**, **custID**, **company_name**, **email**,
a new table was created in **Databricks**. Columns **email** and **company_name** were dropped because we did not need them for clustering. 
**Total products ordered** were used as a feature for the following clustering.

A **KMeans algorithm** was initiated with **2 clusters**, after transforming the feature column DataFrame to Vector. After training, 
a **silhouette evaluator** was used to confirm that the number of clusters chosen for KMeans was appropriate.

After cluster center extraction, new columns were added to the prediction DataFrame so that the clients could be categorized into 3 categories:
- **Big clients** if the number of products ordered by the client exceeded the value of the biggest center.
- **Mid clients** if the number of products were in the range \[big center, small center).
- **Small clients** otherwise.

Then the DataFrame was extracted as CSV and saved into **Databricks**.
