CREATE OR REPLACE VIEW equipment_usage_stats AS
SELECT 
    e.id AS id_equipamento,
    e.serial_number AS numero_serie,
    e.brand AS marca,
    e.model AS modelo,
    e.category AS categoria,
    e.state AS estado,
    e.use_time AS tempo_uso_horas,
    -- Uso em episódios
    COUNT(DISTINCT ee.episode_id) AS total_episodios,
    -- Uso em procedimentos
    COUNT(DISTINCT pe.procedure_id) AS total_procedimentos,
    -- Última utilização
    GREATEST(
        COALESCE((SELECT MAX(ep.time) FROM episode_equipment ee2 
                  JOIN episode ep ON ee2.episode_id = ep.id 
                  WHERE ee2.equipment_id = e.id), '1900-01-01'),
        COALESCE((SELECT MAX(mp.time) FROM procedure_equipment pe2 
                  JOIN medicalprocedure mp ON pe2.procedure_id = mp.id 
                  WHERE pe2.equipment_id = e.id), '1900-01-01')
    ) AS ultima_utilizacao,
    DATEDIFF(NOW(), e.last_repair) AS dias_desde_ultima_reparacao
FROM equipment e
LEFT JOIN episode_equipment ee ON e.id = ee.equipment_id
LEFT JOIN procedure_equipment pe ON e.id = pe.equipment_id
WHERE e.deleted_at IS NULL
GROUP BY e.id
ORDER BY e.use_time DESC;