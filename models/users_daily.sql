WITH user_type AS (
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
         ELSE "Returning" END AS user_type
FROM
    `dh-codapro-analytics-2460.hiring_search_analytics.behavioural_customer_data` bcd
LEFT JOIN user_type AS ut ON (bcd.customer_id = ut.customer_id)
WHERE
      bcd.customer_id IS NOT NULL

QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id, partition_date ORDER BY partition_date DESC) = 1;
