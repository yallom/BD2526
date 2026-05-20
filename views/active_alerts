CREATE OR REPLACE VIEW active_alerts AS
SELECT 
    id AS alerta_id,
    timestamp AS data_alerta,
    severity AS gravidade,
    entity_type AS tipo_entidade,
    entity_id AS id_entidade,
    reason AS motivo,
    message AS mensagem
FROM Alert
WHERE resolved_at IS NULL
-- Ordena por gravidade (critical primeiro) e depois por data
ORDER BY FIELD(severity, 'critical', 'warning', 'info'), timestamp DESC;