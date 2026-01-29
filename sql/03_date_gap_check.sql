-- 03_date_gap_check.sql
-- Detects gaps > 30 days between consecutive encounters per patient
-- Classic MySQL approach (no window functions)

SELECT
    e.patient_id,
    e.encounter_datetime AS current_date,
    (
        SELECT MAX(e2.encounter_datetime)
        FROM encounter e2
        WHERE e2.voided = 0
          AND e2.patient_id = e.patient_id
          AND e2.encounter_datetime < e.encounter_datetime
    ) AS prev_date,
    DATEDIFF(
        e.encounter_datetime,
        (
            SELECT MAX(e3.encounter_datetime)
            FROM encounter e3
            WHERE e3.voided = 0
              AND e3.patient_id = e.patient_id
              AND e3.encounter_datetime < e.encounter_datetime
        )
    ) AS gap_days
FROM encounter e
WHERE e.voided = 0
HAVING prev_date IS NOT NULL
   AND gap_days > 30
ORDER BY e.patient_id, e.encounter_datetime;
