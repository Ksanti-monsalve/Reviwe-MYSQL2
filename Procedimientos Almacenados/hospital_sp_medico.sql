-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: medico
-- (Equivalente a PERSONAL_MEDICO del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarMedico$$
CREATE PROCEDURE sp_InsertarMedico(
    IN p_cod_medico        VARCHAR(6),
    IN p_nom_medico        VARCHAR(100),
    IN p_cod_especialidad  VARCHAR(6),
    IN p_cod_departamento  VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarMedico', 'medico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO medico (cod_medico, nom_medico, cod_especialidad, cod_departamento)
    VALUES (p_cod_medico, p_nom_medico, p_cod_especialidad, p_cod_departamento);
    SELECT 'Médico insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerMedicos$$
CREATE PROCEDURE sp_ObtenerMedicos()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerMedicos', 'medico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT
        m.cod_medico,
        m.nom_medico,
        e.desc_especialidad,
        d.nom_departamento,
        d.director_depto
    FROM medico m
    INNER JOIN especialidad  e ON m.cod_especialidad = e.cod_especialidad
    INNER JOIN departamento  d ON m.cod_departamento = d.cod_departamento;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerMedicoPorID$$
CREATE PROCEDURE sp_ObtenerMedicoPorID(
    IN p_cod_medico VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerMedicoPorID', 'medico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT
        m.cod_medico,
        m.nom_medico,
        e.desc_especialidad,
        d.nom_departamento,
        d.director_depto
    FROM medico m
    INNER JOIN especialidad  e ON m.cod_especialidad = e.cod_especialidad
    INNER JOIN departamento  d ON m.cod_departamento = d.cod_departamento
    WHERE m.cod_medico = p_cod_medico;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarMedico$$
CREATE PROCEDURE sp_ActualizarMedico(
    IN p_cod_medico        VARCHAR(6),
    IN p_nom_medico        VARCHAR(100),
    IN p_cod_especialidad  VARCHAR(6),
    IN p_cod_departamento  VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarMedico', 'medico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE medico
    SET nom_medico       = p_nom_medico,
        cod_especialidad = p_cod_especialidad,
        cod_departamento = p_cod_departamento
    WHERE cod_medico = p_cod_medico;
    SELECT 'Médico actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarMedico$$
CREATE PROCEDURE sp_EliminarMedico(
    IN p_cod_medico VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarMedico', 'medico', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM medico WHERE cod_medico = p_cod_medico;
    SELECT 'Médico eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - medico
-- ============================================================

-- INSERT
CALL sp_InsertarMedico('MED004', 'Dr. House',   'ESP001', 'DEP001');
CALL sp_InsertarMedico('MED005', 'Dra. Grey',   'ESP002', 'DEP001');
CALL sp_InsertarMedico('MED006', 'Dr. Strange', 'ESP003', 'DEP002');

-- VER TODOS (con JOIN a especialidad y departamento)
CALL sp_ObtenerMedicos();

-- VER UNO POR ID
CALL sp_ObtenerMedicoPorID('MED004');

-- ACTUALIZAR (cambia de especialidad y departamento)
CALL sp_ActualizarMedico('MED004', 'Dr. House', 'ESP003', 'DEP002');

-- VER EL CAMBIO
CALL sp_ObtenerMedicoPorID('MED004');

-- ELIMINAR
CALL sp_EliminarMedico('MED004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerMedicos();

-- VER LOGS
SELECT
    log_id,
    nom_rutina,
    CASE
        WHEN nom_rutina LIKE 'sp_%' THEN 'Procedimiento'
        WHEN nom_rutina LIKE 'fn_%' THEN 'Función'
        ELSE 'Desconocido'
    END AS tipo_rutina,
    nom_tabla,
    codigo_error,
    mensaje_error,
    fecha_hora
FROM bitacora_errores
ORDER BY fecha_hora DESC;
