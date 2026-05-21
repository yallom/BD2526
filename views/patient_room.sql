CREATE OR REPLACE VIEW vw_mapa_internamento AS
SELECT 
    p.id AS id_paciente,
    p.name AS nome_paciente,
    p.nif AS nif,
    p.blood_type AS tipo_sanguineo,
    l.floor AS piso,
    l.number AS numero_quarto,
    l.state AS estado_quarto
FROM hospital_db.patient p
JOIN hospital_db.location_patient lp ON p.id = lp.patient_id
JOIN hospital_db.location l ON lp.location_id = l.id;

