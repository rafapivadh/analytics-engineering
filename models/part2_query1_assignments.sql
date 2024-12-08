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

user_type AS (
  SELECT
  customer_id,
  MIN(partition_date) AS first_app_open_date

  FROM `dh-codapro-analytics-2460.hiring_search_analytics.behavioural_customer_data` bcd
  WHERE customer_id IS NOT NULL
  AND event_name = "app.open"
  GROUP BY customer_id

)


SELECT
    bcd.partition_date,
    bcd.customer_id,
    bcd.global_entity_id,
    COALESCE(bcd.device, 'Unknown') AS device,
    CASE WHEN bcd.partition_date = ut.first_app_open_date THEN "NEW"
         ELSE "Returning" END AS user_type,
    experiments.experiment_id,
    experiments.variation,
    
FROM
    `dh-codapro-analytics-2460.hiring_search_analytics.behavioural_customer_data` bcd
LEFT JOIN user_type AS ut 
ON 
    bcd.customer_id = ut.customer_id
LEFT JOIN experiments
ON 
    bcd.session_id = experiments.perseus_session_id
AND bcd.client_id = experiments.perseus_id
WHERE
      bcd.customer_id IS NOT NULL

QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id, partition_date ORDER BY partition_date DESC) = 1;