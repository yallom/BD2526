DELIMITER $$

CREATE FUNCTION fn_vitals_status(
    pulse      FLOAT,
    sistolic   FLOAT,
    diastolic  FLOAT,
    oxygen     FLOAT,
    temp       FLOAT,
    breathing  FLOAT
)

RETURNS INT
DETERMINISTIC

BEGIN
    DECLARE score INT DEFAULT 0;

    -- VALORES CRITICOS
    IF pulse     < 20  OR pulse     > 250 THEN RETURN 5; END IF;
    IF oxygen    < 70                     THEN RETURN 5; END IF;
    IF sistolic  < 50  OR sistolic  > 220 THEN RETURN 5; END IF;
    IF temp      < 32  OR temp      > 42  THEN RETURN 5; END IF;
    IF breathing < 4   OR breathing > 40  THEN RETURN 5; END IF;

    -- Valores Graves (chegam para nível 4 por si só)
    IF pulse     < 30  OR pulse     > 180 THEN RETURN GREATEST(4, score); END IF;
    IF oxygen    < 80                     THEN RETURN GREATEST(4, score); END IF;
    IF sistolic  < 60  OR sistolic  > 200 THEN RETURN GREATEST(4, score); END IF;
    IF temp      < 33  OR temp      > 41  THEN RETURN GREATEST(4, score); END IF;
    IF breathing < 6   OR breathing > 35  THEN RETURN GREATEST(4, score); END IF;~

    -- Cada parametro conta até 4 pntos para o total

    -- Pulse (normal: 55-100)
    SET score = score + CASE
        WHEN pulse BETWEEN 55  AND 100 THEN 0
        WHEN pulse BETWEEN 45  AND 54  OR pulse BETWEEN 101 AND 110 THEN 1
        WHEN pulse BETWEEN 35  AND 44  OR pulse BETWEEN 111 AND 140 THEN 2
        WHEN pulse BETWEEN 25  AND 34  OR pulse BETWEEN 141 AND 179 THEN 3
        ELSE 4
    END;

    -- Systolic (normal: 90-140)
    SET score = score + CASE
        WHEN sistolic BETWEEN 90  AND 140 THEN 0
        WHEN sistolic BETWEEN 80  AND 89  OR sistolic BETWEEN 141 AND 159 THEN 1
        WHEN sistolic BETWEEN 70  AND 79  OR sistolic BETWEEN 160 AND 179 THEN 2
        WHEN sistolic BETWEEN 60  AND 69  OR sistolic BETWEEN 180 AND 199 THEN 3
        ELSE 4
    END;

    -- Diastolic (normal: 60-90)
    SET score = score + CASE
        WHEN diastolic BETWEEN 60 AND 90  THEN 0
        WHEN diastolic BETWEEN 50 AND 59  OR diastolic BETWEEN 91  AND 100 THEN 1
        WHEN diastolic BETWEEN 40 AND 49  OR diastolic BETWEEN 101 AND 110 THEN 2
        WHEN diastolic BETWEEN 30 AND 39  OR diastolic BETWEEN 111 AND 120 THEN 3
        ELSE 4
    END;

    -- Oxygen / SpO2 (normal: 95-100)
    SET score = score + CASE
        WHEN oxygen BETWEEN 95 AND 100 THEN 0
        WHEN oxygen BETWEEN 92 AND 94  THEN 1
        WHEN oxygen BETWEEN 88 AND 91  THEN 2
        WHEN oxygen BETWEEN 80 AND 87  THEN 3
        ELSE 4
    END;

    -- Temperature (normal: 36.0-37.5)
    SET score = score + CASE
        WHEN temp BETWEEN 36.0 AND 37.5 THEN 0
        WHEN temp BETWEEN 35.5 AND 35.9 OR temp BETWEEN 37.6 AND 38.0 THEN 1
        WHEN temp BETWEEN 35.0 AND 35.4 OR temp BETWEEN 38.1 AND 39.0 THEN 2
        WHEN temp BETWEEN 33.0 AND 34.9 OR temp BETWEEN 39.1 AND 41.0 THEN 3
        ELSE 4
    END;

    -- Breathing (normal: 12-20)
    SET score = score + CASE
        WHEN breathing BETWEEN 12 AND 20 THEN 0
        WHEN breathing BETWEEN 10 AND 11 OR breathing BETWEEN 21 AND 24 THEN 1
        WHEN breathing BETWEEN 8  AND 9  OR breathing BETWEEN 25 AND 29 THEN 2
        WHEN breathing BETWEEN 5  AND 7  OR breathing BETWEEN 30 AND 34 THEN 3
        ELSE 4
    END;

    -- Avaliacao com o score
    RETURN CASE
        WHEN score <= 2  THEN 1  -- Normal
        WHEN score <= 6  THEN 2  -- Ligeiro
        WHEN score <= 11 THEN 3  -- Moderado
        WHEN score <= 17 THEN 4  -- Serio
        ELSE                  5  -- Critico
    END;

END$$

DELIMITER;