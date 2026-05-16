DELIMITER $$
	CREATE TRIGGER check_equipment_status
	BEFORE UPDATE ON Equipment
	FOR EACH ROW
	BEGIN
		IF NEW.category = 'discardable' AND NEW.use_time > 0 THEN
			SET NEW.state = 'inoperable';
		ELSEIF NEW.use_time >= 3600*10 THEN
			SET NEW.state = 'maintenance';
            SET NEW.last_repair = NOW();
		END IF;
	END$$
DELIMITER ;
		