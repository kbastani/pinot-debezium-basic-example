# Apache Pinot and Debezium Example for MySQL

This is a basic Apache Pinot example for ingesting real-time MySQL change logs using Debezium. To get started, follow the instructions below. This example is a reference for getting up and running using Docker compose. Please provide comments as issues to this repository, and feel free to make pull requests with useful recipes for querying change logs ingested from Debezium.

### Example architecture

The following diagram is a useful mental model to understand the nuts and bolts of a microservices architecture that uses Debezium and Pinot for change data capture and query.

![https://i.imgur.com/SQqumLd.png](https://i.imgur.com/SQqumLd.png)

For this example, we'll only focus on a single MySQL database and Debezium's MySQL Kafka Connector.

## Usage

First, start up the Docker compose recipe. The compose file contains multiple containers, including Apache Pinot and MySQL, in addition to Apache Kafka and Zookeeper. Debezium also has a connector service that manages configurations for the different connectors that you plan to use for a variety of different databases. In this example we use MySQL.

    $ docker-compose up

Run the following command in a different terminal tab after you've verified that all of the containers are started and warmed up. You can verify the state of the cluster by navigating to Apache Pinot's cluster manager at http://localhost:9000.

    $ sh ./bootstrap.sh

That should do it. Now, check out the Pinot query console (http://localhost:9000/#/query) and run the following SQL command.

```sql
SELECT JSONEXTRACTSCALAR(payload_json, '$.ts_ms', 'LONG') as ts_ms,
       JSONEXTRACTSCALAR(payload_json, '$.op', 'STRING') as operation,
       JSONEXTRACTSCALAR(payload_json, '$..before.first_name', 'STRING_ARRAY') as first_name_before,
       JSONEXTRACTSCALAR(payload_json, '$..after.first_name', 'STRING_ARRAY') as first_name_after,
       JSONEXTRACTSCALAR(payload_json, '$..before.last_name', 'STRING_ARRAY') as last_name_before,
       JSONEXTRACTSCALAR(payload_json, '$..after.last_name', 'STRING_ARRAY') as last_name_after
FROM debezium
LIMIT 1000
```

You should see the following results:

|ts_ms        |operation|first_name_before|first_name_after|last_name_before|last_name_after|
|-------------|---------|-----------------|----------------|----------------|---------------|
|1606845341847|c        |[]               |["Sally"]       |[]              |["Thomas"]     |
|1606845341848|c        |[]               |["George"]      |[]              |["Bailey"]     |
|1606845341848|c        |[]               |["Edward"]      |[]              |["Walker"]     |
|1606845341848|c        |[]               |["Anne Marie"]  |[]              |["Kretchmar"]  |
|1606845381108|u        |["Anne Marie"]   |["Anne"]        |["Kretchmar"]   |["Kretchmar"]  |
|1606846436120|u        |["Anne"]         |["Anne Sue"]    |["Kretchmar"]   |["Kretchmar"]  |
|1606846525859|u        |["Edward"]       |["Kyle"]        |["Walker"]      |["Walker"]     |
|1606846526614|u        |["George"]       |["George"]      |["Bailey"]      |["Johannson"]  |
|1606846595073|u        |["Sally"]        |["Jane"]        |["Thomas"]      |["Appleseed"]  |

## License

This library is an open source product licensed under Apache License 2.0.
