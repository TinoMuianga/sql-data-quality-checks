-- 01_duplicate_identifiers.sql
-- Finds duplicate identifiers (replace table/column names with your schema)

SELECT
  pi.identifier,
  pi.identifier_type,
  COUNT(*) AS total
FROM patient_identifier pi
WHERE pi.voided = 0
GROUP BY pi.identifier, pi.identifier_type
HAVING COUNT(*) > 1
ORDER BY total DESC, pi.identifier;
