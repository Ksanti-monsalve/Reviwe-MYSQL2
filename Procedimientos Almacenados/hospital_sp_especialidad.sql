-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: especialidad
-- (Equivalente a AREA_MEDICA del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarEspecialidad$$
CREATE PROCEDURE sp_InsertarEspecialidad(
    IN p_cod_especialidad  VARCHAR(6),
    IN p_desc_especialidad VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarEspecialidad', 'especialidad', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO especialidad (cod_especialidad, desc_especialidad)
    VALUES (p_cod_especialidad, p_desc_especialidad);
    SELECT 'Especialidad insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerEspecialidades$$
CREATE PROCEDURE sp_ObtenerEspecialidades()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerEspecialidades', 'especialidad', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM especialidad;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerEspecialidadPorID$$
CREATE PROCEDURE sp_ObtenerEspecialidadPorID(
    IN p_cod_especialidad VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerEspecialidadPorID', 'especialidad', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM especialidad WHERE cod_especialidad = p_cod_especialidad;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarEspecialidad$$
CREATE PROCEDURE sp_ActualizarEspecialidad(
    IN p_cod_especialidad  VARCHAR(6),
    IN p_desc_especialidad VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarEspecialidad', 'especialidad', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE especialidad
    SET desc_especialidad = p_desc_especialidad
    WHERE cod_especialidad = p_cod_especialidad;
    SELECT 'Especialidad actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarEspecialidad$$
CREATE PROCEDURE sp_EliminarEspecialidad(
    IN p_cod_especialidad VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarEspecialidad', 'especialidad', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM especialidad WHERE cod_especialidad = p_cod_especialidad;
    SELECT 'Especialidad eliminada correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - especialidad
-- ============================================================

-- INSERT
CALL sp_InsertarEspecialidad('ESP004', 'Infectología');
CALL sp_InsertarEspecialidad('ESP005', 'Neurocirugía');
CALL sp_InsertarEspecialidad('ESP006', 'Dermatología');

-- VER TODOS
CALL sp_ObtenerEspecialidades();

-- VER UNO POR ID
CALL sp_ObtenerEspecialidadPorID('ESP004');

-- ACTUALIZAR
CALL sp_ActualizarEspecialidad('ESP004', 'Infectología General');

-- VER EL CAMBIO
CALL sp_ObtenerEspecialidadPorID('ESP004');

-- ELIMINAR
CALL sp_EliminarEspecialidad('ESP004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerEspecialidades();

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
