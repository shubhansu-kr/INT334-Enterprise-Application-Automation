# **Splunk Alerts Practical**

---

## **Pre-requisite**

Launch the Splunk dashboard using the setup script:

```bash
bash ./../../Script/SplunkDashboard.sh
```

Open Splunk Dashboard in your browser at:  
`http://<Public-IP>:8000`

---

## **Step-by-Step: Creating Alerts in Splunk**

---

### **Step 0: Add Data**

1. Click **Settings** on the top navigation bar.
2. Select **Add Data**.
3. Upload or configure the desired data source.

---

### **Step 1: Run a Search Query**

1. Navigate to **Search & Reporting** on the dashboard.
2. In the search bar, enter your query. Example:

    ```spl
    source="138066_1_MOUNT BLUE1.xls" host="ip-172-31-28-3" sourcetype="mount"
    | table *
    ```

3. Click **Search** and confirm that the output matches your expectation.

---

### **Step 2: Save the Search as an Alert**

1. Click **Save As → Alert** from the top-right corner of the search result.
2. In the *Save As Alert* window:
   - **Title**: Example - `New Registration Alert`
   - **Description**: (Optional) Short note about the alert.
   - **Permissions**: Choose `Private` (only visible to you) or `Shared in App`.
   - **Alert Type**:
     - Choose `Scheduled` to run it at intervals.
     - Or select `Real-time` to trigger immediately.

---

### **Step 3: Set Alert Conditions**

1. **Time Range**: Choose a relevant one like `Last 24 hours`.
2. **Schedule**:  
   - Select **Run on Cron Schedule**.
   - Example Cron for 12:34 PM every day:

   ```cron
   34 12 * * *
   ```

3. **Trigger Condition**:
   - Use: `Trigger alert when` → `Number of Results` > 0  
   - This ensures the alert fires only when data is found.

---

### **Step 4: Add Trigger Actions (Log Event)**

1. Under **Trigger Actions**, click **Add Actions**.
2. Select **Log Event**.
3. Enter a custom message in the event text box. Example:

    ```text
    New Registration Data Found
    ```

4. Click **Save** to finish setting up the alert.

---

### **Step 5: Verify the Alert**

1. Navigate to:  
   **Settings → Searches, Reports, and Alerts**
2. Locate your created alert and check its status and activity.
3. To confirm that it triggered, run this query:

    ```spl
    index=_internal source="scheduler.log"
    ```

4. You should find a log entry indicating the alert was executed.

---

## **Explanation**

### **Why Set Up Alerts in Splunk?**

- Alerts help monitor critical conditions automatically.
- They notify you when specific patterns or values appear in logs.
- Useful for detecting system anomalies, registration events, failures, or error spikes in real-time or on a schedule.

### **What You Achieve With This Practical**

- Gain hands-on experience with creating and configuring alerts.
- Understand how to automate monitoring workflows.
- Learn how to validate alert execution through internal log tracking.
