-- 03_date_gap_check.sql
-- Detect gaps > 30 days between consecutive encounters per patient
-- MySQL-compatible approach (no window functions)

SELECT
    e.patient_id,
    e.encounter_datetime AS current_date,
    prev.prev_date,
    DATEDIFF(e.encounter_datetime, prev.prev_date) AS gap_days
FROM encounter e
JOIN (
    SELECT
        e1.encounter_id,
        (
            SELECT MAX(e2.encounter_datetime)
            FROM encounter e2
            WHERE e2.voided = 0
              AND e2.patient_id = e1.patient_id
              AND e2.encounter_datetime < e1.encounter_datetime
        ) AS prev_date
    FROM encounter e1
    WHERE e1.voided = 0
) prev ON prev.encounter_id = e.encounter_id
WHERE e.voided = 0
  AND prev.prev_date IS NOT NULL
  AND DATEDIFF(e.encounter_datetime, prev.prev_date) > 30
ORDER BY e.patient_id, e.encounter_datetime;
