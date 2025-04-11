# **Splunk: Uploading & Visualizing Log Files**

---

## **Pre-requisite**

Ensure your Splunk Dashboard is already running and accessible on `http://<EC2-Public-IP>:8000`.

---

## **Step 0: Add Data (Log File Upload)**

1. Open the Splunk Dashboard in a browser.
2. Navigate to:  
   **Settings → Add Data**
3. Choose:  
   **Upload → Select a file from your local PC**  
   (Use the log file located at `data/applicationlog` or any `.csv`)
4. Set Source Type:
   - Choose **CSV** as the source type.
5. Set Host:
   - Enter your **host IP address** (e.g., `52.66.252.215`).
6. Click **Next → Review → Submit**

---

## **Step 1: Search the Log Data**

### 1. Basic Search Query

```spl
index="main" host="52.66.252.215" 
| table timestamp, client_ip, request_method, request_url, status_code, response_size
```

- This fetches key fields from logs and presents them in a table.

### 2. Visualize

- Click on the **Visualization** tab to generate graphs or pie charts from the search results.

### 3. Save the Visualization as a Dashboard

- Click **Save As → Dashboard Panel**
- Provide:
  - **Dashboard Name**
  - **Panel Title**
- Click **Save**, then **View Dashboard**

---

## **Useful Queries for Log Analysis**

---

### **1. View Logs with Deduplication:**

```spl
index="_internal" 
| dedup 1000 sourcetype 
| stats count(date_hour) by sourcetype
```

- Deduplicates by sourcetype and shows event count by hour.

---

### **2. Find Only ERROR Logs:**

```spl
source="large_application_logs.csv" host="52.54.217.182" index="summary" sourcetype="csv"
| search level="ERROR"
| table timestamp level service message user_id ip_address
| sort -timestamp
```

- Filters only `ERROR` level logs and sorts them with the most recent first.

---

### **3. Count Logs by Severity Level:**

```spl
source="large_application_logs.csv" host="52.54.217.182" index="summary" sourcetype="csv"
| stats count by level
```

- Shows how many times each log level (INFO, WARN, ERROR, etc.) occurred.

---

### **4. Find Logs by User ID:**

```spl
source="large_application_logs.csv" host="52.54.217.182" index="summary" sourcetype="csv"
| search user_id=1500
| table timestamp level service message ip_address
| sort -timestamp
```

- Fetches all logs for a specific user, sorted by time.

---

## **Explanation**

This practical covers how to:

- Upload CSV-based log data to Splunk
- Perform search queries using Splunk's Search Processing Language (SPL)
- Visualize logs with graphs and charts
- Build dashboards for monitoring and analysis

### **Why This Is Useful**

- Centralized log analysis helps debug services quickly.
- Dashboards provide real-time insights and are shareable with teams.
- Search filters (e.g., by level or user) make it easy to drill down into specific issues.
