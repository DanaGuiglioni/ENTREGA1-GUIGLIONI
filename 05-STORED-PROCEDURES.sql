# STORED PROCEDURES #

-- STORED PROCEDURE 1: Actualizar el Estado de un Prestamo 

DELIMITER //

CREATE PROCEDURE ActualizarEstadoPrestamo(IN p_id_prestamo INT)		-- Parametro de entrada: p_id_prestamo
BEGIN
    DECLARE cuotas_sin_pagar INT;		-- Declaro dos variables que van a almacenar valores a utilizar en el sp
    DECLARE cuotas_vencidas INT;

    -- Cuotas que no han sido pagadas
    SELECT COUNT(*) INTO cuotas_sin_pagar
    FROM Cuotas
    WHERE id_prestamo = p_id_prestamo AND fecha_pago IS NULL;

    -- Cuotas no pagadas que ya están vencidas
    SELECT COUNT(*) INTO cuotas_vencidas
    FROM Cuotas
    WHERE id_prestamo = p_id_prestamo AND fecha_pago IS NULL AND fecha_vencimiento < CURDATE();
	
    -- Condicional
    IF cuotas_sin_pagar = 0 THEN
        -- Todas las cuotas están pagadas
        UPDATE Solicitud_Prestamos
        SET estado = 'Pagado'
        WHERE id_prestamo = p_id_prestamo;

    ELSEIF cuotas_vencidas > 0 THEN
        -- Hay cuotas no pagadas y vencidas
        UPDATE Solicitud_Prestamos
        SET estado = 'En Mora'
        WHERE id_prestamo = p_id_prestamo;

    ELSE
        -- Hay cuotas no pagadas pero no están vencidas
        UPDATE Solicitud_Prestamos
        SET estado = 'Pendiente'
        WHERE id_prestamo = p_id_prestamo;
    END IF;
END //

DELIMITER ;


# Para corroborar el Stored Procedure 1, ejecuto los CALL para cada prestamo con el objetivo de actualizar su Estado 

SELECT * FROM Solicitud_Prestamos;

CALL ActualizarEstadoPrestamo(1);
CALL ActualizarEstadoPrestamo(2);
CALL ActualizarEstadoPrestamo(3);
CALL ActualizarEstadoPrestamo(4);
CALL ActualizarEstadoPrestamo(5);
CALL ActualizarEstadoPrestamo(6);
CALL ActualizarEstadoPrestamo(7);
CALL ActualizarEstadoPrestamo(8);


-- STORED PROCEDURE 2: Registrar un Nuevo Prestamo, asignando automaticamente la tasa, el monto final con intereses

DELIMITER //

CREATE PROCEDURE RegistrarNuevoPrestamo(	-- Cuatro parametros de entrada: p_id_solicitante, p_monto, p_plazo_meses y p_motivo
    IN p_id_solicitante INT,
    IN p_monto DECIMAL(10,2),
    IN p_plazo_meses INT,
    IN p_motivo VARCHAR(50)
)
BEGIN
    DECLARE v_id_tasa INT;					-- Declaro tres variables que van a almacenar valores a utilizar en el sp
    DECLARE v_tasa_anual DECIMAL(5,2);
    DECLARE v_monto_final DECIMAL(10,2);

    -- Obtener la tasa vigente
    SELECT id_tasa, tasa_anual INTO v_id_tasa, v_tasa_anual
    FROM Tasas_Interes_Historicas
    WHERE fecha_fin IS NULL
    LIMIT 1;

    -- Calcular monto final con interés simple
    SET v_monto_final = p_monto + (p_monto * (v_tasa_anual / 100) * (p_plazo_meses / 12));

    -- Insertar nuevo préstamo
    INSERT INTO Solicitud_Prestamos (id_solicitante, monto, tasa_interes, plazo_meses, motivo, fecha_solicitud, estado, id_tasa, monto_final)
    VALUES (p_id_solicitante, p_monto, v_tasa_anual, p_plazo_meses, p_motivo, CURDATE(), 'Pendiente', v_id_tasa, v_monto_final);
    
END //

DELIMITER ;


# Para corroborar el Stored Procedure 2, ejecuto un CALL para insertar un nuevo prestamo y luego verifico que se haya insertado correctamente en Solicitud_Prestamos

SELECT * FROM Solicitud_Prestamos;

CALL RegistrarNuevoPrestamo(10, 20000.00, 2, 'Vivienda');

SELECT * FROM Solicitud_Prestamos WHERE id_solicitante = 10 ORDER BY id_prestamo DESC LIMIT 1;







