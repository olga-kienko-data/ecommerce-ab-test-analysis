Total


WITH session_info AS (
SELECT
    s.ga_session_id,
    ab.test,
    ab.test_group
FROM `DA.session` AS s
JOIN `DA.ab_test` AS ab
ON s.ga_session_id = ab.ga_session_id
),


-- DENOMINATOR (рахуємо сесії)
session_cnt AS (
SELECT
    test,
    test_group,
    COUNT(DISTINCT ga_session_id) AS denominator
FROM session_info
GROUP BY test, test_group
),


-- NUMERATOR для подій
event_cnt AS (
SELECT
    si.test,
    si.test_group,
    ep.event_name AS metric,
    COUNT(ep.ga_session_id) AS numerator
FROM `DA.event_params` AS ep
JOIN session_info AS si
ON si.ga_session_id = ep.ga_session_id
WHERE ep.event_name IN (
    'add_payment_info',
    'add_shipping_info',
    'begin_checkout'
)
GROUP BY
    si.test,
    si.test_group,
    ep.event_name
),


--  NUMERATOR для new_accounts
accounts_cnt AS (
SELECT
    si.test,
    si.test_group,
    'new_accounts' AS metric,
    COUNT(DISTINCT acs.ga_session_id) AS numerator
FROM `DA.account_session` AS acs
JOIN session_info AS si
ON acs.ga_session_id = si.ga_session_id
GROUP BY
    si.test,
    si.test_group
),


--  Об'єднуємо всі метрики
metrics_cnt AS (
SELECT
    test,
    test_group,
    metric,
    numerator
FROM event_cnt


UNION ALL


SELECT
    test,
    test_group,
    metric,
    numerator
FROM accounts_cnt
)


--  Фінальна таблиця
SELECT
    m.test,
    m.test_group,
    m.metric,
    m.numerator,
    s.denominator
FROM metrics_cnt AS m
JOIN session_cnt AS s
ON m.test = s.test
AND m.test_group = s.test_group
ORDER BY m.test, m.metric;



Segments



WITH session_info AS (
    SELECT
        s.ga_session_id,
        sp.continent,
        sp.device,
        sp.channel,
        sp.operating_system,
        ab.test,
        ab.test_group
    FROM `DA.session` s
    JOIN `DA.ab_test` ab
        ON s.ga_session_id = ab.ga_session_id
    JOIN `DA.session_params` sp
        ON s.ga_session_id = sp.ga_session_id
),


session_cnt AS (
    SELECT
        test,
        test_group,
        continent,
        device,
        channel,
        operating_system,
        COUNT(DISTINCT ga_session_id) AS denominator
    FROM session_info
    GROUP BY test, test_group,
             continent, device, channel, operating_system
),


event_cnt AS (
    SELECT
        si.test,
        si.test_group,
        si.continent,
        si.device,
        si.channel,
        si.operating_system,
        ep.event_name AS metric,
        COUNT(DISTINCT ep.ga_session_id) AS numerator
    FROM `DA.event_params` ep
    JOIN session_info si
        ON ep.ga_session_id = si.ga_session_id
    WHERE ep.event_name IN (
        'add_payment_info',
        'add_shipping_info',
        'begin_checkout'
    )
    GROUP BY si.test, si.test_group,
             si.continent, si.device, si.channel, si.operating_system,
             ep.event_name
),


accounts_cnt AS (
    SELECT
        si.test,
        si.test_group,
        si.continent,
        si.device,
        si.channel,
        si.operating_system,
        'new_accounts' AS metric,
        COUNT(DISTINCT acs.ga_session_id) AS numerator
    FROM `DA.account_session` acs
    JOIN session_info si
        ON acs.ga_session_id = si.ga_session_id
    GROUP BY si.test, si.test_group,
             si.continent, si.device, si.channel, si.operating_system
),


metrics_cnt AS (
    SELECT * FROM event_cnt
    UNION ALL
    SELECT * FROM accounts_cnt
)


SELECT
    m.test,
    m.test_group,
    m.metric,
    m.continent,
    m.device,
    m.channel,
    m.operating_system,
    m.numerator,
    s.denominator
FROM metrics_cnt m
JOIN session_cnt s
    ON m.test = s.test
   AND m.test_group = s.test_group
   AND m.continent = s.continent
   AND m.device = s.device
   AND m.channel = s.channel
   AND m.operating_system = s.operating_system
ORDER BY
    m.test,
    m.test_group,
    m.metric;





