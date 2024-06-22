# Replace the placeholders below with your own data
storage_account_name = "<Storage_Account_Name>"
container_name = "<Container_Name>"
blob_name = "<File_Name>.csv"
sas_token = "<SAS_Token>"

# Create the URL
wasbs_path = f"wasbs://{container_name}@{storage_account_name}.blob.core.windows.net/{blob_name}"

# Set the Spark configuration parameters for accessing Azure Blob Storage
spark.conf.set(
    f"fs.azure.sas.{container_name}.{storage_account_name}.blob.core.windows.net",
    sas_token
)

# Read the CSV file
df = spark.read.format("csv").option("header", "true").load(wasbs_path)

# Display the first rows of the DataFrame
df.show()
