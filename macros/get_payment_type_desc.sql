{% macro get_payment_type_desc(payment_type) -%}
CASE {{ payment_type }}
    WHEN 1 THEN 'Credit Card'
    WHEN 2 THEN 'Cash'
    WHEN 3 THEN 'No Charge'
    WHEN 4 THEN 'Dispute'
    WHEN 5 THEN 'Unknown'
    WHEN 6 THEN 'Voided Trip'
    ELSE 'Other'
END
{%- endmacro %}