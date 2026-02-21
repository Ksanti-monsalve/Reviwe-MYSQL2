-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: departamento
-- (Equivalente a UNIDAD_ACADEMICA del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarDepartamento$$
CREATE PROCEDURE sp_InsertarDepartamento(
    IN p_cod_departamento VARCHAR(6),
    IN p_nom_departamento VARCHAR(45),
    IN p_director_depto   VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarDepartamento', 'departamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO departamento (cod_departamento, nom_departamento, director_depto)
    VALUES (p_cod_departamento, p_nom_departamento, p_director_depto);
    SELECT 'Departamento insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerDepartamentos$$
CREATE PROCEDURE sp_ObtenerDepartamentos()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerDepartamentos', 'departamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM departamento;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerDepartamentoPorID$$
CREATE PROCEDURE sp_ObtenerDepartamentoPorID(
    IN p_cod_departamento VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerDepartamentoPorID', 'departamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM departamento
    WHERE cod_departamento = p_cod_departamento;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarDepartamento$$
CREATE PROCEDURE sp_ActualizarDepartamento(
    IN p_cod_departamento VARCHAR(6),
    IN p_nom_departamento VARCHAR(45),
    IN p_director_depto   VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarDepartamento', 'departamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE departamento
    SET nom_departamento = p_nom_departamento,
        director_depto   = p_director_depto
    WHERE cod_departamento = p_cod_departamento;
    SELECT 'Departamento actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarDepartamento$$
CREATE PROCEDURE sp_EliminarDepartamento(
    IN p_cod_departamento VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarDepartamento', 'departamento', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM departamento
    WHERE cod_departamento = p_cod_departamento;
    SELECT 'Departamento eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - departamento
-- ============================================================

-- INSERT
CALL sp_InsertarDepartamento('DEP004', 'Oncología',      'Dr. Wilson');
CALL sp_InsertarDepartamento('DEP005', 'Rehabilitación', 'Dr. Palmer');

-- VER TODOS
CALL sp_ObtenerDepartamentos();

-- VER UNO POR ID
CALL sp_ObtenerDepartamentoPorID('DEP004');

-- ACTUALIZAR
CALL sp_ActualizarDepartamento('DEP004', 'Oncología', 'Dr. House');

-- VER EL CAMBIO
CALL sp_ObtenerDepartamentoPorID('DEP004');

-- ELIMINAR
CALL sp_EliminarDepartamento('DEP004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerDepartamentos();

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
