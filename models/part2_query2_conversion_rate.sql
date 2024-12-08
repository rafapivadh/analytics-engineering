SELECT
fe.experiment_id,
fe.variation,
ud.global_entity_id,
ud.device,

COUNT(DISTINCT fe.customer_id) AS total_customers,
COUNT(DISTINCT CASE WHEN fe.is_successful THEN fe.customer_id END) AS total_converted_customers,

SAFE_DIVIDE(COUNT(DISTINCT CASE WHEN fe.is_successful THEN fe.customer_id END),COUNT(DISTINCT fe.customer_id)) AS conversion_rate

FROM {{fact_experiments}} AS fe
LEFT JOIN {{users_daily}} AS ud
ON
  fe.partition_date = ud.partition_date
AND
  fe.customer_id = ud.customer_id

GROUP BY 
fe.experiment_id,
fe.variation,
ud.global_entity_id,
ud.device
