Lab - Logging
---

### Table of contents
[1. Introduction to kubectl logging commands](#kubcetl)

[2. Introduction to using Kibana](#intro)

## Overview
In this lab exercise, you gain some experience using **kubectl** to view logs and **Kibana** to review and analyze logs collected from your ICP Cluster.

### Introduction to kubectl logging commands <a name="kubectl"></a>
In this section, you use kubcetl commands to view logs from your ICP CLUSTER.

1. If you do not already have one open, open a **terminal** session connected to your `master` node as the **root** user.

2. Configure the kubectl command line to connect to your ICP Cluster. Click the **User** icon on the navigation bar in the ICP Admin Console, and then select **Configure Client**. Copy the commands and paste them in to the terminal window.

3. Enter the following command to view the logs for the nodejs sample (that you deployed earlier in the workshop) by using the **Deployment**:

  ```
  kubectl logs deployment/nodejs-sample-nodejssample-nodejs --namespace nodejs-lab
  ```

  The output is similar to the output shown below:

  ```
  # kubectl logs deployment/nodejs-sample-nodejssample-nodejs --namespace nodejs-lab

  > nodejs-sample@1.0.0 start /app
  > node server/server.js

  [Wed May 30 16:23:56 2018] com.ibm.diagnostics.healthcenter.loader INFO: Node Application Metrics 3.1.3.201711070422 (Agent Core 3.2.6)
  [2018-05-30 16:23:57.135] [INFO] ibm-cloud-env - Initializing with /app/server/config/mappings.json
  [2018-05-30 16:23:57.138] [WARN] ibm-cloud-env - File does not exist /app/server/config/mappings.json
  [Wed May 30 16:23:57 2018] com.ibm.diagnostics.healthcenter.mqtt INFO: Connecting to broker localhost:1883
  [2018-05-30 16:23:57.190] [INFO] nodejs-sample - Node.js sample listening on http://localhost:3000

  ```

4. Another way to access the same logs is by using the **app label**. Enter the following command to view the logs for the nodejs sample (that you deployed earlier in the workshop) by using the **app label**:

  ```
  kubectl logs -lapp=nodejsSample --namespace=nodejs-lab
  ```

5. Another way to access the same logs is by using the **pod name**. Enter the following commands to get the pod name, and then get the logs for the pod:

  ```
  export PODNAME=$(kubectl get pods -l app=nodejsSample --namespace=nodejs-lab -o=jsonpath="{.items[0].metadata.name}")

  kubectl logs $PODNAME --namespace=nodejs-lab
  ```

### Introduction to using Kibana <a name="intro"></a>
In this section, you use Kibana to review infrastructure and application logs and create some simple charts and graphs.

#### Access Kibana
Kibana was installed in the **kube-system** namespace during IBM Cloud Private installation and integrated into the ICP Admin Console.

1. If you are not already logged in to the ICP Admin Console from a previous exercise, open a browser and navigate to `https://10.10.1.2:8443`. Log in by using `username: admin` and `password: passw0rd`.

2. Click **Menu**, and then select **Platform > Logging** to access Kibana.

#### View the logs for the nodejs sample
In this section, you use Kibana to view the logs for the nodejs sample, and modify the fields that are displayed on the screen.

1. In the search field, enter ```kubernetes.namespace: nodejs-lab``` to see the logs for the nodejs sample.

  ![NodeJS Logs](images/logging101/nodejs.jpg)

2. Modify the fields that are shown on the screen. Click the **Settings icon** on the **Available Fields** line, and add the following fields: ``` kubernetes.container_name, log, stream ```

  ![NodeJS Log Fields](images/logging101/fields.jpg)

#### Import a Dashboard and some Visualizations
In this section, you import some basic visualizations and a dashboard that demonstrates some of the capabilities of Kibana.

1. Copy the following **visualization** definitions in to a local file named ```kibana-visualations.txt```.  

  ```
  [
    {
      "_id": "4f7f5670-4a04-11e8-bc77-89cc76c243c4",
      "_type": "visualization",
      "_source": {
        "title": "Number of messages per namespace",
        "visState": "{\"title\":\"Number of messages per namespace\",\"type\":\"histogram\",\"params\":{\"grid\":{\"categoryLines\":false,\"style\":{\"color\":\"#eee\"}},\"categoryAxes\":[{\"id\":\"CategoryAxis-1\",\"type\":\"category\",\"position\":\"bottom\",\"show\":true,\"style\":{},\"scale\":{\"type\":\"linear\"},\"labels\":{\"show\":true,\"truncate\":100,\"filter\":false,\"rotate\":0},\"title\":{\"text\":\"Namespace\"}}],\"valueAxes\":[{\"id\":\"ValueAxis-1\",\"name\":\"LeftAxis-1\",\"type\":\"value\",\"position\":\"left\",\"show\":true,\"style\":{},\"scale\":{\"type\":\"linear\",\"mode\":\"normal\"},\"labels\":{\"show\":true,\"rotate\":0,\"filter\":false,\"truncate\":100},\"title\":{\"text\":\"Number of messages per namespace\"}}],\"seriesParams\":[{\"show\":\"true\",\"type\":\"histogram\",\"mode\":\"stacked\",\"data\":{\"label\":\"Number of messages per namespace\",\"id\":\"1\"},\"valueAxis\":\"ValueAxis-1\",\"drawLinesBetweenPoints\":true,\"showCircles\":true}],\"addTooltip\":true,\"addLegend\":true,\"legendPosition\":\"bottom\",\"times\":[],\"addTimeMarker\":false},\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{\"customLabel\":\"Number of messages per namespace\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"kubernetes.namespace.keyword\",\"size\":5,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Namespace\"}}],\"listeners\":{}}",
        "uiStateJSON": "{}",
        "description": "",
        "version": 1,
        "kibanaSavedObjectMeta": {
          "searchSourceJSON": "{\"index\":\"logstash-*\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"
        }
      }
    },
    {
      "_id": "b68e64f0-4a04-11e8-bc77-89cc76c243c4",
      "_type": "visualization",
      "_source": {
        "title": "Top 10 - Number of messages per container",
        "visState": "{\"title\":\"Top 10 - Number of messages per container\",\"type\":\"histogram\",\"params\":{\"grid\":{\"categoryLines\":false,\"style\":{\"color\":\"#eee\"}},\"categoryAxes\":[{\"id\":\"CategoryAxis-1\",\"type\":\"category\",\"position\":\"bottom\",\"show\":true,\"style\":{},\"scale\":{\"type\":\"linear\"},\"labels\":{\"show\":true,\"truncate\":100,\"rotate\":0},\"title\":{\"text\":\"Namespace\"}}],\"valueAxes\":[{\"id\":\"ValueAxis-1\",\"name\":\"LeftAxis-1\",\"type\":\"value\",\"position\":\"left\",\"show\":true,\"style\":{},\"scale\":{\"type\":\"linear\",\"mode\":\"normal\"},\"labels\":{\"show\":true,\"rotate\":0,\"filter\":false,\"truncate\":100},\"title\":{\"text\":\"Number of messages per container\"}}],\"seriesParams\":[{\"show\":\"true\",\"type\":\"histogram\",\"mode\":\"stacked\",\"data\":{\"label\":\"Number of messages per container\",\"id\":\"1\"},\"valueAxis\":\"ValueAxis-1\",\"drawLinesBetweenPoints\":true,\"showCircles\":true}],\"addTooltip\":true,\"addLegend\":true,\"legendPosition\":\"right\",\"times\":[],\"addTimeMarker\":false},\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{\"customLabel\":\"Number of messages per container\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"segment\",\"params\":{\"field\":\"kubernetes.container_name.keyword\",\"size\":10,\"order\":\"desc\",\"orderBy\":\"1\",\"customLabel\":\"Namespace\"}}],\"listeners\":{}}",
        "uiStateJSON": "{}",
        "description": "",
        "version": 1,
        "kibanaSavedObjectMeta": {
          "searchSourceJSON": "{\"index\":\"logstash-*\",\"query\":{\"query_string\":{\"query\":\"*\",\"analyze_wildcard\":true}},\"filter\":[]}"
        }
      }
    }
  ]
  ```

2. Copy the following **dashboard** definitions in to a local file named ```kibana-dashboard.txt```.

  ```
  [
    {
      "_id": "ba2d8f40-4a05-11e8-bc77-89cc76c243c4",
      "_type": "dashboard",
      "_source": {
        "title": "Message counts",
        "hits": 0,
        "description": "",
        "panelsJSON": "[{\"col\":1,\"id\":\"4f7f5670-4a04-11e8-bc77-89cc76c243c4\",\"panelIndex\":1,\"row\":1,\"size_x\":12,\"size_y\":4,\"type\":\"visualization\"},{\"col\":1,\"id\":\"b68e64f0-4a04-11e8-bc77-89cc76c243c4\",\"panelIndex\":2,\"row\":5,\"size_x\":12,\"size_y\":4,\"type\":\"visualization\"}]",
        "optionsJSON": "{\"darkTheme\":false}",
        "uiStateJSON": "{\"P-1\":{\"vis\":{\"legendOpen\":true}},\"P-2\":{\"vis\":{\"colors\":{\"Number of messages per container\":\"#1F78C1\"}}}}",
        "version": 1,
        "timeRestore": false,
        "kibanaSavedObjectMeta": {
          "searchSourceJSON": "{\"filter\":[{\"query\":{\"query_string\":{\"analyze_wildcard\":true,\"query\":\"*\"}}}],\"highlightAll\":true,\"version\":true}"
        }
      }
    }
  ]
  ```

3. Click **Management** on the left-hand menu.

4. Click **Kibana --> Saved Objects**, and then click **Import**.

5. Select `kibana-visualizations.txt`, and when prompted, select **Yes, overwrite all**.

6. Click the **Visualizations** tab to see the newly imported visualizations.

  ![Visualizations](images/logging101/visualizations.jpg)

7. Click **Import**.

8. Select `kibana-dashboard.txt`, and when prompted, select **Yes, overwrite all**.

9. Click the **Dashboards** tab to see the newly imported visualizations.

  ![Dashboards](images/logging101/dashboard.jpg)

#### Open the Dashboard
In this section, you open the dashboard that you just imported.

1. Click **Dashboard** on the left-hand menu, and then select **Message counts** to display the dashboard that you imported. It has two visualizations: one shows the number of messages per namespace, and the other shows the number of message per container.

  ![Dashboards](images/logging101/dashboard1.jpg)

2. Click **Last 15 minutes** in the top right-hand corner, and change the time selector to 7 days. Watch how the data changes automatically.

  ![Time Select](images/logging101/timeselect.jpg)

3. Close the Kibana browser tab.

#### End of Lab Review
In this lab exercise, you looked at logging in IBM Cloud Private. You:
- Used kubcetl to view the logs for a deployed application in a variety of different ways
- Accessed Kibana and created an initial Index pattern
- Viewed the most recent log messages for the ICP Cluster
- Filtered the log messages to view those only for the nodejs sample application
- Imported some simple Visualizations and Dashboards to Kibana
- Accessed the imported Dashboard

## End of Lab Exercise
