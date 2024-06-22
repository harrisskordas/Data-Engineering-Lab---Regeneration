# Databricks notebook source
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.clustering import KMeans
from pyspark.ml.evaluation import ClusteringEvaluator
from pyspark.sql.functions import when

# Create Spark session
spark = SparkSession.builder.appName("Databricks Table Access").getOrCreate()

# Load table into DataFrame
table_name = "default.clients_orders_volume_csv"
df = spark.table(table_name)

# Display the DataFrame
df.show()
# Drop the unnecessary columns
df = df.drop("company_name", "email")

# Create a VectorAssembler to transform the feature column
vector_assembler = VectorAssembler(inputCols=["total_products_ordered"], outputCol="features")

# Transform the DataFrame
feature_df = vector_assembler.transform(df)

# Set the number of clusters
kmeans = KMeans(k=2, seed=1)  # Adjust k as needed

# Fit the model
model = kmeans.fit(feature_df)

# Make predictions
predictions = model.transform(feature_df)

# Display the predictions
predictions.show()

# Evaluate clustering by computing Silhouette score
evaluator = ClusteringEvaluator()

silhouette = evaluator.evaluate(predictions)
print(f"Silhouette with squared euclidean distance = {silhouette}")

# Display the cluster centers
centers = model.clusterCenters()
print("Cluster Centers: ")
for center in centers:
    print(center)


# Extract cluster centers
center_values = [center[0] for center in centers]
biggest_center = max(center_values)
smallest_center = min(center_values)

# Add new columns based on cluster centers
predictions = predictions.withColumn("big_client", when(predictions["total_products_ordered"] > biggest_center, 1).otherwise(0))
predictions = predictions.withColumn("mid_client", when((predictions["total_products_ordered"] <= biggest_center) & (predictions["total_products_ordered"] > smallest_center), 1).otherwise(0))
predictions = predictions.withColumn("small_client", when(predictions["total_products_ordered"] <= smallest_center, 1).otherwise(0))

# Show the updated DataFrame
display(predictions)



# Define the path to save the CSV file
output_path = "/Shared/clients_new.csv"  # Adjust the path as needed

# Write to CSV
predictions.select("custID", "total_products_ordered", "big_client", "mid_client", "small_client").write.csv(output_path, header=True)
