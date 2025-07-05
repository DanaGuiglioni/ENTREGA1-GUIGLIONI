# CREACION DE VISTAS #

-- VISTA 1: Distribución del Credito por Provincia

CREATE OR REPLACE VIEW Distribucion_Credito_Por_Provincia AS
SELECT
    u.provincia,
    COUNT(sp.id_prestamo) AS total_solicitudes,
    COUNT(u.id_usuario) AS total_usuarios,
    SUM(sp.monto) AS total_credito_solicitado,
    ROUND(AVG(sp.monto), 2) AS promedio_credito_por_solicitud
FROM
    Solicitud_Prestamos sp
JOIN
    Usuarios u ON sp.id_solicitante = u.id_usuario
GROUP BY
    u.provincia
ORDER BY
    total_credito_solicitado DESC;


SELECT * FROM Distribucion_Credito_Por_Provincia;


-- VISTA 2: Volumen de Prestamos por año

CREATE OR REPLACE VIEW Volumen_Prestamos_Por_Anio AS
SELECT
    YEAR(fecha_solicitud) AS anio,
    COUNT(*) AS cantidad_prestamos,
    SUM(monto) AS monto_total_prestado,
    ROUND(AVG(monto), 2) AS promedio_monto_prestado
FROM
    Solicitud_Prestamos
GROUP BY
    YEAR(fecha_solicitud)
ORDER BY
    anio;


SELECT * FROM Volumen_Prestamos_Por_Anio;
    
    
-- VISTA 3: Segmento de Riesgo Actual (más reciente)

CREATE OR REPLACE VIEW Segmento_Riesgo_Actual AS
SELECT 
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.provincia,
    u.localidad,
    sr.nombre_segmento,
    sr.criterios,
    us.fecha_asignacion			
FROM 
    Usuarios u			

LEFT JOIN ( 			-- Relacionamos la tabla Usuarios con Usuarios_Segmento. Buscamos el ultimo segmento asignado a cada usuario:
	SELECT us1.* 										
	FROM Usuarios_Segmento us1
	JOIN (
		SELECT id_solicitante, MAX(fecha_asignacion) AS max_fecha		/* 1° SUBCONSULTA us2: devuelve la ultima fecha en que se le asigno un segmento a cada usuario */
		FROM Usuarios_Segmento
		GROUP BY id_solicitante
	) us2 
	ON us1.id_solicitante = us2.id_solicitante 
	AND us1.fecha_asignacion = us2.max_fecha 	/* 2° us1 JOIN us2: obtiene la fila completa de Usuarios_Segmento correspondiente a la ultima fecha */
) us 
ON u.id_usuario = us.id_solicitante		/* 3° SUBCONSULTA us: une las tablas Usuarios y Usuarios_Segmento */
                  
LEFT JOIN Segmentos_Riesgo sr 		-- Relacionamos la tabla Usuarios con Segmentos_Riesgo. Traduce el id_segmento a un nombre de segmento y su criterio. 
ON us.id_segmento = sr.id_segmento
WHERE u.tipo_usuario IN ('solicitante', 'ambos');   -- El analisis de riesgo se realiza solo para usuarios solicitantes o ambos, no para prestamistas


SELECT * FROM Segmento_Riesgo_Actual;


-- VISTA 4: Morosidad de Prestamos segun el Estado de la Cuota

CREATE OR REPLACE VIEW Morosidad_Prestamos AS
SELECT 
    sp.id_prestamo,
    sp.id_solicitante,
    sp.monto AS monto_original,
    sp.monto_final,
    sp.fecha_solicitud,
    COUNT(c.id_cuota) AS cuotas_atrasadas,
    SUM(c.monto_cuota) AS total_pendiente,
    MAX(DATEDIFF(c.fecha_pago, c.fecha_vencimiento)) AS max_dias_atraso
FROM 
    Solicitud_Prestamos sp
JOIN 
    Cuotas c ON sp.id_prestamo = c.id_prestamo
WHERE 
    c.estado = 'vencida'
GROUP BY 
    sp.id_prestamo, sp.id_solicitante, sp.monto, sp.monto_final, sp.fecha_solicitud;


SELECT * FROM Morosidad_Prestamos;


-- VISTA 5: Objetivos Financieros de los Usuarios

CREATE OR REPLACE VIEW Objetivos_Financieros_Usuarios AS
SELECT 
    motivo AS tipo_objetivo,
    COUNT(*) AS cantidad_prestamos,
    SUM(monto) AS monto_total,
    ROUND(AVG(monto), 2) AS promedio_monto
FROM 
    Solicitud_Prestamos
GROUP BY 
    motivo
ORDER BY 
    monto_total DESC;


SELECT * FROM Objetivos_Financieros_Usuarios;