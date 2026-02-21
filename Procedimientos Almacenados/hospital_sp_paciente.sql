-- ============================================================
-- CRUD STORED PROCEDURES - TABLA: paciente
-- (Equivalente a REGISTRO_PACIENTE del modelo original)
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarPaciente$$
CREATE PROCEDURE sp_InsertarPaciente(
    IN p_cod_paciente    VARCHAR(6),
    IN p_primer_nombre   VARCHAR(45),
    IN p_primer_apellido VARCHAR(45),
    IN p_num_contacto    VARCHAR(15)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_InsertarPaciente', 'paciente', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    INSERT INTO paciente (cod_paciente, primer_nombre, primer_apellido, num_contacto)
    VALUES (p_cod_paciente, p_primer_nombre, p_primer_apellido, p_num_contacto);
    SELECT 'Paciente insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPacientes$$
CREATE PROCEDURE sp_ObtenerPacientes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerPacientes', 'paciente', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM paciente;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPacientePorID$$
CREATE PROCEDURE sp_ObtenerPacientePorID(
    IN p_cod_paciente VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ObtenerPacientePorID', 'paciente', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SELECT * FROM paciente WHERE cod_paciente = p_cod_paciente;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarPaciente$$
CREATE PROCEDURE sp_ActualizarPaciente(
    IN p_cod_paciente    VARCHAR(6),
    IN p_primer_nombre   VARCHAR(45),
    IN p_primer_apellido VARCHAR(45),
    IN p_num_contacto    VARCHAR(15)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_ActualizarPaciente', 'paciente', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    UPDATE paciente
    SET primer_nombre   = p_primer_nombre,
        primer_apellido = p_primer_apellido,
        num_contacto    = p_num_contacto
    WHERE cod_paciente = p_cod_paciente;
    SELECT 'Paciente actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarPaciente$$
CREATE PROCEDURE sp_EliminarPaciente(
    IN p_cod_paciente VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO bitacora_errores (nom_rutina, nom_tabla, codigo_error, mensaje_error, fecha_hora)
        VALUES ('sp_EliminarPaciente', 'paciente', @cod, @msg, NOW());
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    DELETE FROM paciente WHERE cod_paciente = p_cod_paciente;
    SELECT 'Paciente eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'hospital_db';

-- ============================================================
-- PRUEBAS - paciente
-- ============================================================

-- INSERT
CALL sp_InsertarPaciente('PAC004', 'Juan',       'Rivas', '3001110001');
CALL sp_InsertarPaciente('PAC005', 'Ana',         'Soto',  '3002220002');
CALL sp_InsertarPaciente('PAC006', 'Luis',        'Paz',   '3003330003');

-- VER TODOS
CALL sp_ObtenerPacientes();

-- VER UNO POR ID
CALL sp_ObtenerPacientePorID('PAC004');

-- ACTUALIZAR
CALL sp_ActualizarPaciente('PAC004', 'Juan Carlos', 'Rivas', '3009990004');

-- VER EL CAMBIO
CALL sp_ObtenerPacientePorID('PAC004');

-- ELIMINAR
CALL sp_EliminarPaciente('PAC004');

-- VER TODOS TRAS ELIMINAR
CALL sp_ObtenerPacientes();

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
