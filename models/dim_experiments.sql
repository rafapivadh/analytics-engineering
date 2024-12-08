SELECT 
  experiment.key AS experiment_id,
  experiment.variation AS variation,
  MIN(blg.partition_date) AS start_date,
  MAX(blg.partition_date) AS end_date
 FROM `dh-codapro-analytics-2460.hiring_search_analytics.backend_logging_data` blg
 INNER JOIN UNNEST(blg.fun_with_flags_client.response.experiments) AS experiment
 
 GROUP BY experiment.key,experiment.variation