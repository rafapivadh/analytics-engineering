SELECT
    cod.order_id,
    cod.customer_id,
    cod.order_value_eur,
    cod.discount_value_eur,
    cod.order_value_eur - COALESCE(cod.discount_value_eur,0) - COALESCE(cod.voucher_value_eur,0) AS discounted_order_value_eur,
    cod.is_successful,
    cod.partition_date,
    cod.placed_at_utc,
    CASE WHEN cod.customer_contact IS NOT NULL THEN TRUE
         ELSE FALSE END AS has_customer_care_contact
FROM
    `dh-codapro-analytics-2460.hiring_search_analytics.customer_orders_data` cod
WHERE
    order_id IS NOT NULL;
    