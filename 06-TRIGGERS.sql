# IMPLEMENTACION DE TRIGGERS #

-- TRIGGER 1: Actualizar el Estado de una Cuota

DELIMITER $$

CREATE TRIGGER tr_actualizar_estado_cuota
BEFORE UPDATE ON Cuotas
FOR EACH ROW
BEGIN
  
  IF NEW.fecha_pago IS NOT NULL THEN
  
    -- Si se pagó antes o en la fecha límite → 'pagada'
    IF NEW.fecha_pago <= NEW.fecha_vencimiento THEN
      SET NEW.estado = 'Pagada';
    ELSE
      SET NEW.estado = 'Pagada'; 			-- igual es pagada, aunque tarde. Podria ser 'Retrasada'
    END IF;
  
  ELSE
  
    -- Si aún no se pagó
    IF NEW.fecha_vencimiento < CURDATE() THEN
      SET NEW.estado = 'Vencida';
    ELSE
      SET NEW.estado = 'Pendiente';
    END IF;
  END IF;
  
END$$

DELIMITER ;


# Para corroborar el Trigger 1, ubico alguna cuota que este pendiente de pago (que no tenga fecha de pago) y actualizo la fecha de pago a HOY. Esto actualiza el campo Estado de la tabla Cuotas

SELECT id_cuota, id_prestamo FROM Cuotas WHERE fecha_pago IS NULL;

UPDATE Cuotas
SET fecha_pago = CURDATE()
WHERE id_cuota = 7;

SELECT * FROM Cuotas WHERE id_cuota = 7;


-- TRIGGER 2: Insertar Transaccion por Nuevo Aporte de dinero

DELIMITER $$

CREATE TRIGGER tr_insertar_transaccion_aporte
AFTER INSERT ON Financiamiento
FOR EACH ROW
BEGIN

    INSERT INTO Transacciones (
        id_usuario,
        tipo_transaccion,
        monto_transaccion,
        fecha_transaccion,
        descripcion
    )
    VALUES (
        NEW.id_prestamista,
        'aporte',
        NEW.monto_aportado,
        NEW.fecha_aporte,
        CONCAT('Aporte al préstamo ', NEW.id_prestamo)
    );
    
END$$

DELIMITER ;


# Para corroborar el Trigger 2, inserto un nuevo registro en la tabla Financiamiento y compruebo su correcta insercion en la tabla Transacciones

INSERT INTO Financiamiento (id_prestamista, id_prestamo, monto_aportado, fecha_aporte)
VALUES (11, 9, 20000.00, CURDATE());

SELECT * FROM Transacciones WHERE id_transaccion = 46;



