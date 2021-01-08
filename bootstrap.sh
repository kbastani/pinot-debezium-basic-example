#!/bin/bash

# Copy the Pinot table and schema configurations for the debezium change log to the Pinot container and execute the add table command
docker cp pinot/debezium-table-definition.json pinot-debezium-basic-example_pinot_1:/opt/pinot
docker cp pinot/debezium-schema-definition.json pinot-debezium-basic-example_pinot_1:/opt/pinot
docker exec pinot-debezium-basic-example_pinot_1 bash -c "/opt/pinot/bin/pinot-admin.sh AddTable -tableConfigFile /opt/pinot/debezium-table-definition.json -schemaFile /opt/pinot/debezium-schema-definition.json -exec"

# Create the Debezium connector using register-mysql.json
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json

# Issue some updates and inserts to the MySQL customer database
docker-compose exec mysql bash -c 'mysql -u $MYSQL_USER -p$MYSQL_PASSWORD inventory -e "UPDATE customers SET first_name=\"Anne Sue\" WHERE id=1004;"'
docker-compose exec mysql bash -c 'mysql -u $MYSQL_USER -p$MYSQL_PASSWORD inventory -e "UPDATE customers SET first_name=\"Kyle\" WHERE id=1003;"'
docker-compose exec mysql bash -c 'mysql -u $MYSQL_USER -p$MYSQL_PASSWORD inventory -e "UPDATE customers SET last_name=\"Johannson\" WHERE id=1002;"'
docker-compose exec mysql bash -c 'mysql -u $MYSQL_USER -p$MYSQL_PASSWORD inventory -e "UPDATE customers SET first_name=\"Jane\", last_name=\"Appleseed\" WHERE id=1001;"'

# Open the browser for Pinot
open http://localhost:9000
