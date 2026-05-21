DELIMITER $$

CREATE VIEW vw_archived_locations AS
SELECT 
    id, 
    number, 
    deleted_at 
FROM Location 
WHERE deleted_at IS NOT NULL;

$$
DELIMITER ;