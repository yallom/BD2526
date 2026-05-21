CREATE OR REPLACE VIEW vw_alerta_manutencao_equipamento AS
SELECT 
    id AS id_equipamento,
    category AS categoria,
    brand AS marca,
    model AS modelo,
    serial_number AS n_serie,
    state AS estado_atual,
    next_repair AS data_limite_manutencao
FROM hospital_db.equipment
WHERE state IN ('maintenance', 'inoperable') 
   OR next_repair <= DATE_ADD(CURDATE(), INTERVAL 15 DAY);

   