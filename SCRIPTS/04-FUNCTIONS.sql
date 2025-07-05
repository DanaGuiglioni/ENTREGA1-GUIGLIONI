# FUNCIONES #

-- FUNCTION 1: Calcular la Rentabilidad Promedio de un prestamista segun sus aportes

DELIMITER //

CREATE FUNCTION CalcularRentabilidadPromedio(id_prestamista_input INT)		-- Parametro de entrada: id_prestamista_input
RETURNS DECIMAL(5,2)
DETERMINISTIC					
READS SQL DATA					
BEGIN
    DECLARE rentabilidad_promedio DECIMAL(5,2);		-- Variable que vamos a usar en la funcion para almacenar el dato

    SELECT ROUND(AVG(re.tasa_retorno), 2)
    INTO rentabilidad_promedio
    FROM Rentabilidad_Esperada re
    JOIN Financiamiento f ON re.id_financiamiento = f.id_financiamiento
    WHERE f.id_prestamista = id_prestamista_input;

    RETURN rentabilidad_promedio;
END //

DELIMITER ;


SELECT CalcularRentabilidadPromedio(1) AS retorno_promedio;		-- El id_prestamista 1 (ambos) financió tres prestamos (2, 3, 7). Las tasas de retorno son: 8.33, 13.5 y 4.88
SELECT CalcularRentabilidadPromedio(3) AS retorno_promedio;		-- El id_prestamista 3 (prestamista) financió tres prestamos (1, 5, 8). Las tasas de retorno son: 8.33, 7.33 y 4.88
SELECT CalcularRentabilidadPromedio(2) AS retorno_promedio;		-- Devuelve NULL porque el id_prestamista 2 es solicitante


-- FUNCTION 2: Obtener el Monto de la Penalidad por Usuario

DELIMITER $$

CREATE FUNCTION ObtenerMontoPenalidadPorUsuario(p_id_usuario INT)		-- Parametro de entrada: p_id_usuario
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_penalidades DECIMAL(10,2);

    SELECT COALESCE(SUM(p.monto_penalidad), 0)		-- COALESCE: asegura que, si el usuario no tiene ninguna penalidad, devuelva 0 en vez de NULL. Evita problemas en calculos posteriores
    INTO total_penalidades
    FROM Usuarios u
    JOIN Solicitud_Prestamos sp ON u.id_usuario = sp.id_solicitante
    JOIN Cuotas c ON sp.id_prestamo = c.id_prestamo
    JOIN Penalidades p ON c.id_cuota = p.id_cuota
    WHERE u.id_usuario = p_id_usuario;

    RETURN total_penalidades;
END $$

DELIMITER ;


SELECT ObtenerMontoPenalidadPorUsuario(1) AS penalidades_totales;
SELECT ObtenerMontoPenalidadPorUsuario(5) AS penalidades_totales;
SELECT ObtenerMontoPenalidadPorUsuario(2) AS penalidades_totales;		-- El usuario 2 tiene dos prestamos: uno pagado y otro con mora
SELECT ObtenerMontoPenalidadPorUsuario(9) AS penalidades_totales;		-- El id_solicitante 9 no tiene penalidades


