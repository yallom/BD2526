DELIMITER $$

CREATE VIEW vw_location_occupancy AS
SELECT 
    lp.location_id, 
    l.type AS tipo_sala,
    lp.patient_id, 
    p.name AS nome_paciente,
    lp.arrived_at, 
    lp.left_at 
FROM Location_Patient lp
JOIN Patient p ON lp.patient_id = p.id
JOIN Location l ON lp.location_id = l.id;

$$
DELIMITER ;