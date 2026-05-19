CREATE OR REPLACE VIEW vw_relatorio_procedimentos AS
SELECT 
    mp.id AS id_procedimento,
    mp.time AS data_hora,
    mp.type AS tipo_procedimento,
    mp.duration AS duracao_minutos,
    pac.name AS nome_paciente,
    loc.floor AS piso,
    loc.number AS sala,
    GROUP_CONCAT(prof.name SEPARATOR ', ') AS equipa_medica
FROM hospital_db.medicalprocedure mp
JOIN hospital_db.patient pac ON mp.patient_id = pac.id
JOIN hospital_db.location loc ON mp.location_id = loc.id
LEFT JOIN hospital_db.procedure_professional pp ON mp.id = pp.procedure_id
LEFT JOIN hospital_db.professional prof ON pp.professional_id = prof.id
GROUP BY mp.id;

