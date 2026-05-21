--APRESENTAÇÃO

-- PROCEDURES

-- CRIAR

CALL create_episode(2, '2026-05-21 15:30:00', 85.0, 130.0, 85.0, 97.0, 36.8, 18.0);

CALL create_equipment('SN-006', 'Zoll', 'X Series', 'defibrillator', 'available', 0, '2026-05-20', '2027-05-20');

CALL create_patient(
    'Tiago Mendes', 
    'Rua da Boavista', 
    'tiago.mendes@email.com', 
    '912345678', 
    '123456789', 
    '1992-05-15', 
    'male', 
    175, 
    75, 
    'A+'
);

-- DELETE

CALL delete_patient(5, FALSE);

-- Prova visual de que a paciente continua na base de dados, mas marcada como eliminada:
SELECT id, name, status, deleted_at FROM Patient WHERE id = 5;


CALL delete_patient(3, TRUE);

-- A paciente desapareceu da tabela principal
SELECT * FROM Patient WHERE id = 3;

-- A paciente desapareceu automaticamente do quarto onde estava alocada
SELECT * FROM Location_Patient WHERE patient_id = 3;

-- O episódio UCI (que era o ID 3 no seeder) continua a existir, mas anónimo!
SELECT id AS Episodio_UCI, patient_id, time, pulse 
FROM Episode 
WHERE id = 3;

-- ASSIGN

CALL assign_patient_to_location(5, 5);

-- FUNÇÕES

-- chamar a função para calcular a idade do paciente com id x
SELECT name, fn_age(birthdate) AS idade_calculada 
FROM Patient 
WHERE id = 1;


-- chamar a função para calcular o imc do paciente com id x
SELECT name, fn_bmi(weight, height) AS imc_calculado 
FROM Patient 
WHERE id = 4;


-- chamar a função para calcular o nível de risco do paciente com id x
SELECT patient_id, fn_vitals_status(pulse, sistolic, diastolic, oxygen, temp, breathing) AS nivel_risco 
FROM Episode 
WHERE id = 4;

-- chamar a função para calcular o número de segundos decorridos desde o início do episódio com id x
SELECT patient_id, fn_seconds(time) AS segundos_decorridos 
FROM Episode 
WHERE id = 1;

-- chamar a função para calcular o número de dias que o paciente com id x ficou internado
SELECT name, fn_length_of_stay(id) AS dias_internado 
FROM Patient 
WHERE id = 3;


-- VIEWS


-- Ver o mapa de internamento do piso 1
SELECT * FROM vw_mapa_internamento WHERE piso = 1;

-- Ver todos os equipamentos que precisam de atenção (manutençao atrasada ou daqui a 15 dias)
SELECT * FROM vw_alerta_manutencao_equipamento;

-- Ver cirurgias com duração superior a x minutos
SELECT * FROM vw_relatorio_procedimentos WHERE tipo_procedimento = 'surgery' AND duracao_minutos > 60;

-- Ver cirurgias marcadas nos próximos 7 dias
SELECT * FROM upcoming_procedures;

-- Ver os sinais vitais dos pacientes internados
SELECT * FROM vw_monitor_sinais_vitais;

-- Ver as estatísticas diárias do hospital
SELECT * FROM daily_hospital_stats;

-- Ver as estatísticas de uso dos equipamentos
SELECT * FROM equipment_usage_stats;


-- TRIGGERS

-- Verificar se a trigger de atualização do status do equipamento está a funcionar

-- A equipa técnica atualiza o estado para 'maintenance'
UPDATE Equipment SET state = 'maintenance' WHERE id = 3;
-- ou
CALL update_equipment(3, NULL, NULL, NULL, NULL, 'maintenance', NULL, NULL, NULL);

-- Ficou em manutenção:
SELECT id, brand, category, state FROM Equipment WHERE id = 3;

-- O enfermeiro tenta alocar o ventilador ao Episódio 2

CALL assign_equipment_to_episode (2, 3);


-- Trigger: não agendar procedimentos cirúrgicos em salas inoperaveis

CALL create_medical_procedure(2, 1, '2026-05-25 09:00:00', 'surgery', 120);

UPDATE Location SET state = 'unavailable' WHERE id = 4;

CALL get_location(4, NULL, NULL, NULL);

CALL create_medical_procedure(2, 4, '2026-05-26 10:00:00', 'surgery', 90);


-- Trigger: Atualizar status de acordo com o episodio mais recente

CALL get_patient(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CALL create_episode(1, '2026-05-22 10:00:00', 180.0, 90.0, 60.0, 80.0, 39.5, 30.0);

CALL get_patient(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- Trigger: Altera o estado do equipamento

-- Descarte um cateter

CALL create_equipment('SN-DESC-01', 'MedX', 'Catheter', 'discardable', 'available', 0, NULL, NULL);

CALL update_equipment(7, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL);

CALL get_equipment(7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- Tempo de uso de um equipamento ultrapassa o limite recomendado

CALL update_equipment(1, NULL, NULL, NULL, NULL, NULL, 36000, NULL, NULL);

CALL get_equipment(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



-- trigger: lotação de um local


-- Sala Exames tem capacidade para 2 pacientes
CALL assign_patient_to_location(4, 1);


-- Bloco Operatório tem capacidade para 1 paciente
CALL assign_patient_to_location(2, 4);


-- Quarto tem capacidade para 3 pacientes
CALL assign_patient_to_location(5, 2);



-- trigger: eliminar um local e os pacientes alocados a esse local ficam sem localização (ou seja alta)

SELECT * FROM vw_location_occupancy 
WHERE location_id = 4;

CALL delete_location(4);

SELECT * FROM vw_location_occupancy WHERE location_id = 4;

CALL get_location(4, NULL, NULL, NULL);

-- Trigger: Desocupar um quarto arquivando-o (desativado)

SELECT * FROM vw_location_occupancy WHERE location_id = 1;

UPDATE Location SET deleted_at = NOW() WHERE id = 1;

SELECT * FROM vw_archived_locations;

SELECT * FROM vw_location_occupancy WHERE location_id = 1;

