CREATE OR REPLACE VIEW daily_hospital_stats AS
SELECT 
    CURDATE() AS data,
    (SELECT COUNT(*) FROM patient WHERE deleted_at IS NULL) AS total_pacientes_ativos,
    (SELECT COUNT(*) FROM location_patient) AS pacientes_com_quarto,
    (SELECT COUNT(*) FROM patient p 
     WHERE deleted_at IS NULL 
       AND NOT EXISTS (SELECT 1 FROM location_patient lp WHERE lp.patient_id = p.id)) AS pacientes_sem_quarto,
    (SELECT COUNT(*) FROM episode WHERE DATE(time) = CURDATE()) AS registos_sinais_hoje,
    (SELECT COUNT(*) FROM medicalprocedure WHERE DATE(time) = CURDATE()) AS procedimentos_hoje,
    (SELECT COUNT(*) FROM alert WHERE DATE(timestamp) = CURDATE()) AS alertas_hoje,
    (SELECT COUNT(*) FROM equipment WHERE state = 'available') AS equipamentos_disponiveis,
    (SELECT COUNT(*) FROM location WHERE state = 'available') AS quartos_disponiveis;
