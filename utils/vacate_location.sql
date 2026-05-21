DELIMITER $$

CREATE PROCEDURE vacate_location(
    IN p_location_id INT
)
BEGIN
    DECLARE done          BOOLEAN DEFAULT FALSE;
    DECLARE v_patient_id  INT;
    DECLARE v_loc_type    ENUM('room','operating_room','emergency_room','examination_room');
    DECLARE v_loc_floor   INT;
    DECLARE v_loc_number  INT;
    DECLARE v_loc_capacity INT;
    DECLARE v_target_id   INT;
    DECLARE v_target_count INT;

    -- Cursor over every patient currently in this location
    DECLARE patient_cursor CURSOR FOR
        SELECT patient_id
        FROM Location_Patient
        WHERE location_id = p_location_id
          AND left_at IS NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- -------------------------
    -- Validate source location
    -- -------------------------
    IF NOT EXISTS (
        SELECT 1 FROM Location WHERE id = p_location_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Location not found.';
    END IF;

    SELECT type, floor, number INTO v_loc_type, v_loc_floor, v_loc_number
    FROM Location
    WHERE id = p_location_id;

    SET v_loc_capacity = CASE v_loc_type
        WHEN 'room'             THEN 3
        WHEN 'operating_room'   THEN 1
        WHEN 'emergency_room'   THEN 4
        WHEN 'examination_room' THEN 2
    END;

    -- -------------------------
    -- Relocate each patient
    -- -------------------------
    OPEN patient_cursor;

    relocation_loop: LOOP
        FETCH patient_cursor INTO v_patient_id;
        IF done THEN LEAVE relocation_loop; END IF;

        -- Find the best available destination:
        -- same type, not full, closest floor first, then closest number
        SET v_target_id = NULL;

        SELECT l.id INTO v_target_id
        FROM Location l
        WHERE l.type  = v_loc_type
          AND l.state = 'available'
          AND l.id   != p_location_id
          AND (
              SELECT COUNT(*)
              FROM Location_Patient lp
              WHERE lp.location_id = l.id
                AND lp.left_at IS NULL
          ) < v_loc_capacity
        ORDER BY
            ABS(l.floor  - v_loc_floor)  ASC,
            ABS(l.number - v_loc_number) ASC
        LIMIT 1;

        IF v_target_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Cannot vacate: no available room of the same type found for one or more patients.';
        END IF;

        -- Close the current stay
        UPDATE Location_Patient
        SET left_at = NOW()
        WHERE location_id = p_location_id
          AND patient_id  = v_patient_id
          AND left_at IS NULL;

        -- Open a new stay in the target location
        INSERT INTO Location_Patient (location_id, patient_id, arrived_at)
        VALUES (v_target_id, v_patient_id, NOW());

    END LOOP;

    CLOSE patient_cursor;

    -- Mark the source location as unavailable
    UPDATE Location
    SET state = 'unavailable'
    WHERE id = p_location_id;

END$$

DELIMITER ;