SELECT
    bcd.partition_date,
    bcd.session_id,
    bcd.customer_id,
    COUNT(bcd.event_id) AS event_count,
    COUNT(CASE WHEN bcd.event_name IN ("app.open","add_cart.click","shop_list.loaded","transaction")
               THEN bcd.event_id END) AS engagement_score,
    COUNT(DISTINCT bcd.transaction_id) AS num_of_transactions
FROM
    `dh-codapro-analytics-2460.hiring_search_analytics.behavioural_customer_data` bcd
GROUP BY
    bcd.partition_date, bcd.session_id, bcd.customer_id;
