{% macro diag_category(col) %}

case
    when {{ col }} between 250 and 251 then 'Diabetes'
    when {{ col }} between 390 and 459 then 'Circulatory'
    when {{ col }} between 460 and 519 then 'Respiratory'
    when {{ col }} between 520 and 579 then 'Digestive'
    when {{ col }} between 710 and 739 then 'Musculoskeletal'
    when {{ col }} between 780 and 799 then 'Symptoms'
    when {{ col }} between 800 and 999 then 'Injury'
    else 'Other'
end

{% endmacro %}
