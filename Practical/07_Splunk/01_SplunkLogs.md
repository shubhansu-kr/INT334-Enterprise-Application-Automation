# Use Logs file

Use this command to load the logs:

index="_internal"  | dedup 1000 sourcetype | stats count(date_hour) by sourcetype

Once the logs are loaded, use visualisation to see the graphs, pie charts respective to the logs.

Open Splunk Dashboard

Step 0 : Add data

1. Click on settings > Add data
2. Select file from your local pc (data/applciationlog)
3. Set source type to csv
4. Paste the host ip address in the next window
5. Click on review & then submit

Step 1 : Start Searching

1. In the new search field use the following command
    - `index="main" host="52.66.252.215" | table timestamp, client_ip, request_method, request_url, status_code, response_size`
2. Go to visualisation to see the charts
3. Save as New Dashboard
4. Fill the details for the dashboard.
5. View Dashboard.

Error Log Query

```query
source="large_application_logs.csv" host="52.54.217.182" index="summary" sourcetype="csv"
| search level="ERROR"
| table timestamp level service message user_id ip_address
| sort -timestamp
```

Count log by occurence level

```query
source="large_application_logs.csv" host="52.54.217.182" index="summary" sourcetype="csv"
| stats count by level
```

Find logs for specific user

```query
source="large_application_logs.csv" host="52.54.217.182" index="summary" sourcetype="csv"
| search user_id=1500
| table timestamp level service message ip_address
| sort -timestamp
```
