-- Marcar equipamento como indisponível ao associar a episódio
DELIMITER $$
CREATE TRIGGER after_episode_equipment_insert
AFTER INSERT ON Episode_Equipment
FOR EACH ROW
BEGIN
    UPDATE Equipment SET state = 'unavailable' WHERE id = NEW.equipment_id;
END$$
DELIMITER ;

-- Libertar equipamento ao remover de episódio
DELIMITER $$
CREATE TRIGGER after_episode_equipment_delete
AFTER DELETE ON Episode_Equipment
FOR EACH ROW
BEGIN
    UPDATE Equipment SET state = 'available' WHERE id = OLD.equipment_id;
END$$
DELIMITER ;

-- Mesmo par para Procedure_Equipment
DELIMITER $$
CREATE TRIGGER after_procedure_equipment_insert
AFTER INSERT ON Procedure_Equipment
FOR EACH ROW
BEGIN
    UPDATE Equipment SET state = 'unavailable' WHERE id = NEW.equipment_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_procedure_equipment_delete
AFTER DELETE ON Procedure_Equipment
FOR EACH ROW
BEGIN
    UPDATE Equipment SET state = 'available' WHERE id = OLD.equipment_id;
END$$
DELIMITER ;
