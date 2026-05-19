CREATE OR REPLACE VIEW vw_monitor_sinais_vitais AS
SELECT 
    e.id AS id_registo,
    p.name AS paciente,
    l.number AS quarto,
    e.pulse AS batimento_cardiaco,
    CONCAT(e.sistolic, '/', e.diastolic) AS tensao_arterial,
    e.oxygen AS oxigenio_SpO2,
    e.temp AS temperatura,
    e.time AS data_hora_medicao
FROM hospital_db.episode e
JOIN hospital_db.patient p ON e.patient_id = p.id
-- Usamos LEFT JOIN para garantir que mostra o doente mesmo que ele ainda não tenha quarto atribuído
LEFT JOIN hospital_db.location_patient lp ON p.id = lp.patient_id
LEFT JOIN hospital_db.location l ON lp.location_id = l.id
ORDER BY e.time DESC;