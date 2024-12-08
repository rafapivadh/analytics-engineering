WITH experiments AS (
  SELECT 
  experiment.key AS experiment_id,
  experiment.variation AS variation,
  blg.request_id,
  blg.perseus_id,
  blg.perseus_session_id

 FROM `dh-codapro-analytics-2460.hiring_search_analytics.backend_logging_data` blg
 INNER JOIN UNNEST(blg.fun_with_flags_client.response.experiments) AS experiment
 WHERE blg.perseus_id IS NOT NULL 
 AND experiment.key IS NOT NULL
),

SELECT
    experiments.experiment_id,
    experiments.variation,
    bcd.customer_id,
    bcd.client_id,
    bcd.session_id,
    cod.order_id,
    bcd.partition_date,
    MAX(CASE WHEN cod.customer_contact IS NOT NULL THEN TRUE
         ELSE FALSE END) AS has_customer_care_contact,
    MAX(cod.is_successful) AS is_successful,
    SUM(cod.order_value_eur) AS order_value_eur,
    SUM(cod.order_value_eur - cod.discount_value_eur) AS discounted_order_value_eur,
    COUNT(bcd.event_id) AS event_count,
    COUNT(CASE WHEN bcd.event_name IN ("app.open","add_cart.click","shop_list.loaded","transaction")
               THEN bcd.event_id END) AS engagement_score,
    COUNT(DISTINCT bcd.transaction_id) AS num_of_transactions
FROM
    experiments
INNER JOIN
    `dh-codapro-analytics-2460.hiring_search_analytics.behavioural_customer_data` bcd
ON
    experiments.perseus_session_id = bcd.session_id
AND experiments.perseus_id = bcd.client_id

LEFT JOIN
    `dh-codapro-analytics-2460.hiring_search_analytics.customer_orders_data` cod
ON  bcd.transaction_id IS NOT NULL
AND bcd.transaction_id = cod.order_id

GROUP BY 
experiments.experiment_id,
experiments.variation,
bcd.customer_id,
bcd.session_id,
bcd.client_id,
cod.order_id,
bcd.partition_date