### How I Learned to Optimize Databricks Code at Scale  

When I first started with Databricks, I wrote code that worked, but it wasn’t efficient. Large datasets would take forever to process, and I didn’t know why. After spending time with Spark documentation and looking at example notebooks, I started optimizing my workflows. Later, when working at an enterprise level, I realized there were even more ways to improve. Let me share my journey and the lessons I learned.

---

#### How I Used to Write Code  
In the beginning, my focus was on getting things to work. For example, I’d process data in one go, ignoring how Spark handles memory or execution.  

**My Early Code:**  
```python  
# Scale features  
scaler = StandardScaler(inputCol="features", outputCol="scaled_features")  
scaler_model = scaler.fit(df)  
df = scaler_model.transform(df)  

# Save output  
df.write.parquet("path/to/output.parquet")  
```  

This worked fine for small datasets. But when the data got bigger, the pipeline slowed down.  

---

#### What I Changed After Learning More  
Once I understood Spark better, I started focusing on optimization.  

1. **Caching**: I learned to cache intermediate results, so Spark didn’t have to recompute them.  
2. **Unpersisting**: After saving the results, I unpersisted data to free up memory.  
3. **Optimized Storage**: I used Snappy compression to reduce file size and speed up reads/writes.  

**My Improved Code:**  
```python  
# Cache data  
df.cache()  

# Scale features  
scaler = StandardScaler(inputCol="features", outputCol="scaled_features")  
scaler_model = scaler.fit(df)  
df = scaler_model.transform(df)  

# Save with compression  
df.write.parquet("path/to/output.parquet", compression="snappy")  

# Free up memory  
df.unpersist()  
```  

---

#### What I Learned at an Enterprise Level  
When I started working on larger projects with more complex pipelines, I learned additional ways to optimize:  

1. **Partitioning Data**: Writing large datasets into smaller, evenly distributed partitions improved parallel processing.  
    - Example: Partitioning by a column like `date` to make queries faster.  
    ```python  
    df.write.partitionBy("date").parquet("path/to/output.parquet", compression="snappy")  
    ```  

2. **Broadcast Joins**: For smaller datasets, broadcasting them to all workers reduced the cost of shuffling.  
    ```python  
    from pyspark.sql.functions import broadcast  

    joined_df = large_df.join(broadcast(small_df), "key_column")  
    ```  

3. **Adaptive Query Execution (AQE)**: Enabling AQE allowed Spark to optimize the query plan dynamically based on runtime statistics.  
    ```python  
    spark.conf.set("spark.sql.adaptive.enabled", "true")  
    ```  

4. **Monitoring and Tuning**: Using tools like the Spark UI, I monitored job stages, shuffle sizes, and execution times to identify bottlenecks. Adjusting configurations, like increasing executor memory or tweaking partition sizes, often solved performance issues.

5. **Delta Lake**: Switching to Delta Lake for storage helped with ACID compliance and made updates and deletes efficient.  
    ```python  
    df.write.format("delta").save("path/to/delta_table")  
    ```  

---

#### Why These Optimizations Matter  
- **Partitioning**: Keeps processing distributed and avoids hotspots.  
- **Broadcast Joins**: Cuts down on shuffle operations, which can be a bottleneck.  
- **Adaptive Query Execution**: Lets Spark make smarter decisions about processing during runtime.  
- **Delta Lake**: Adds transactional support, making pipelines more robust.  

---

#### My Takeaway  
Writing good code in Databricks is about understanding how Spark processes data and using its tools effectively. At an enterprise level, it’s also about scaling those practices for bigger datasets and more users.  

If you’re starting out, focus on the basics like caching and unpersisting. As you grow, look into partitioning, broadcast joins, and tools like Delta Lake. Small changes can save hours of processing time and make your workflows much smoother.  

What optimizations have worked for you? I’d love to hear! 🚀  
