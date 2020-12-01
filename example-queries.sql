SELECT JSONEXTRACTSCALAR(payload_json, '$.ts_ms', 'LONG') as ts_ms,
       JSONEXTRACTSCALAR(payload_json, '$.op', 'STRING') as operation,
	     JSONEXTRACTSCALAR(payload_json, '$..before.first_name', 'STRING_ARRAY') as first_name_before,
       JSONEXTRACTSCALAR(payload_json, '$..after.first_name', 'STRING_ARRAY') as first_name_after,
       JSONEXTRACTSCALAR(payload_json, '$..before.last_name', 'STRING_ARRAY') as last_name_before,
       JSONEXTRACTSCALAR(payload_json, '$..after.last_name', 'STRING_ARRAY') as last_name_after
FROM debezium
LIMIT 1000
