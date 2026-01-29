-- 02_reporting_breakdown_example.sql
-- Example reporting aggregation with a breakdown (replace with your tables)

SELECT
  DATE(e.encounter_datetime) AS visit_date,
  COUNT(DISTINCT e.patient_id) AS patients_seen
FROM encounter e
WHERE e.voided = 0
GROUP BY DATE(e.encounter_datetime)
ORDER BY visit_date DESC;
