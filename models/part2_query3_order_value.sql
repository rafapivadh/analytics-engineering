SELECT
fe.experiment_id,
fe.variation,
fe.session_id,
ud.global_entity_id,
ud.device,

AVG(fe.order_value_eur) AS avg_order_value_eur,
SUM(fe.discounted_order_value_eur) AS discounted_order_value_eur,
AVG(fe.discounted_order_value_eur) AS avg_discounted_order_value_eur

FROM `fulfillment-dwh-staging.pandata_temporary.fact_experiments` AS fe
LEFT JOIN `fulfillment-dwh-staging.pandata_temporary.users_daily` AS ud
ON
  fe.partition_date = ud.partition_date
AND
  fe.customer_id = ud.customer_id

WHERE fe.is_successful

GROUP BY 
fe.experiment_id,
fe.variation,
fe.session_id,
ud.global_entity_id,
ud.device
;
