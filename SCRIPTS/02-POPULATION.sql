# INSERCION DE DATOS CON CHATGPT #

-- 1) Usuarios:

INSERT INTO Usuarios (nombre, apellido, email, fecha_nacimiento, dni, direccion, localidad, provincia, tipo_usuario, fecha_registro) VALUES
('Ana', 'Gomez', 'ana.gomez@example.com', '1985-07-12', '31881371', 'Calle Falsa 123', 'Buenos Aires', 'Buenos Aires', 'ambos', '2019-01-10'),
('Bruno', 'Perez', 'bruno.perez@example.com', '1990-03-22', '35332337', 'Av. Siempre Viva 742', 'Rosario', 'Santa Fe', 'solicitante', '2020-04-15'),
('Carla', 'Lopez', 'carla.lopez@example.com', '1978-11-30', '27016997', 'Calle Mitre 456', 'Córdoba', 'Córdoba', 'prestamista', '2019-11-30'),
('Diego', 'Martinez', 'diego.martinez@example.com', '1982-02-18', '29384755', 'Av. Belgrano 789', 'Mendoza', 'Mendoza', 'ambos', '2022-07-20'),
('Elena', 'Ramirez', 'elena.ramirez@example.com', '1995-06-08', '39165850', 'Calle Rivadavia 321', 'La Plata', 'Buenos Aires', 'solicitante', '2023-12-01'),
('Federico', 'Sanchez', 'federico.sanchez@example.com', '1988-09-14', '34216914', 'Av. Santa Fe 1500', 'Buenos Aires', 'Buenos Aires', 'prestamista', '2021-09-25'),
('Gabriela', 'Diaz', 'gabriela.diaz@example.com', '1992-01-05', '36649101', 'Calle San Martin 222', 'Resistencia', 'Chaco', 'ambos', '2025-06-09'),
('Hector', 'Torres', 'hector.torres@example.com', '1975-04-27', '24373404', 'Av. 9 de Julio 1000', 'Buenos Aires', 'Buenos Aires', 'prestamista', '2019-06-20'),
('Ivana', 'Herrera', 'ivana.herrera@example.com', '1987-10-05', '33522291', 'Calle Laprida 99', 'San Juan', 'San Juan', 'ambos', '2022-02-14'),
('Javier', 'Morales', 'javier.morales@example.com', '1993-12-17', '38082641', 'Av. Corrientes 1234', 'Buenos Aires', 'Buenos Aires', 'solicitante', '2023-08-30'),
('Karina', 'Vega', 'karina.vega@example.com', '1980-05-23', '28104233', 'Calle San Luis 456', 'Salta', 'Salta', 'prestamista', '2019-03-22'),
('Luis', 'Ocampo', 'luis.ocampo@example.com', '1972-08-14', '22388192', 'Av. Roca 789', 'Neuquén', 'Neuquén', 'ambos', '2020-12-05');

-- 2) Tasas_Interes_Historicas:

INSERT INTO Tasas_Interes_Historicas (fecha_inicio, fecha_fin, tasa_anual) VALUES
('2019-01-01', '2019-12-31', 27.00),
('2018-01-01', '2018-12-31', 28.50),
('2020-01-01', '2020-12-31', 25.00),
('2021-01-01', '2021-12-31', 23.50),
('2022-01-01', '2022-12-31', 22.00),
('2023-01-01', '2024-06-01' , 20.00),
('2024-06-02', NULL , 19.50);

-- 3) Solicitud_Prestamos:

INSERT INTO Solicitud_Prestamos (id_solicitante, monto, tasa_interes, plazo_meses, motivo, fecha_solicitud, estado, id_tasa, monto_final) VALUES
(2, 50000.00, 25.00, 2, 'capital', '2020-06-01', 'pagado', 3, 54166.67),
(5, 30000.00, 20.00, 1, 'consumo', '2024-01-15', 'vencido', 6, 32500.00),
(1, 100000.00, 27.00, 3, 'capital', '2019-06-15', 'pagado', 1, 113500.00),
(7, 25000.00, 19.50, 1, 'consumo', '2025-06-09', 'pendiente', 7, 26218.75),
(4, 75000.00, 22.00, 2, 'educacion', '2022-08-20', 'vencido', 5, 80500.00),
(2, 15000.00, 20.00, 1, 'educacion', '2023-03-01', 'pagado', 6, 15500.00),
(9, 40000.00, 19.50, 2, 'capital', '2024-06-06', 'pagado', 7, 41950.00), --
(10, 60000.00, 19.50, 3, 'vivienda', '2024-09-01', 'pagado', 7, 62925.00); --

-- 4) Financiamiento:

INSERT INTO Financiamiento (id_prestamista, id_prestamo, monto_aportado, fecha_aporte) VALUES
(3, 1, 30000.00, '2020-05-30'),  
(6, 1, 20000.00, '2020-05-31'),  
(1, 2, 15000.00, '2024-01-13'),  --
(11, 2, 15000.00, '2024-01-14'), 
(1, 3, 50000.00, '2019-06-12'),  --
(8, 3, 30000.00, '2019-06-13'),  
(11, 3, 20000.00, '2019-06-14'), 
(6, 4, 10000.00, '2025-06-07'),  
(9, 4, 15000.00, '2025-06-08'),  
(3, 5, 25000.00, '2022-08-17'),  
(6, 5, 25000.00, '2022-08-18'),  
(11, 5, 25000.00, '2022-08-19'), 
(8, 6, 15000.00, '2023-02-27'),  
(9, 7, 20000.00, '2024-06-04'),  
(1, 7, 20000.00, '2024-06-05'), -- 
(3, 8, 20000.00, '2024-08-28'),  
(6, 8, 20000.00, '2024-08-29'),  
(9, 8, 20000.00, '2024-08-30'); 

-- 5) Cuotas:

INSERT INTO Cuotas (id_prestamo, numero_cuota, monto_cuota, fecha_vencimiento, fecha_pago, estado) VALUES
(1, 1, 27083.33, '2020-07-01', '2020-07-01', 'pagada'),
(1, 2, 27083.34, '2020-08-01', '2020-08-01', 'pagada'),
(2, 1, 32500.00, '2024-02-15', '2024-02-20', 'vencida'),
(3, 1, 37833.34, '2019-07-15', '2019-07-16', 'vencida'),
(3, 2, 37833.33, '2019-08-15', '2019-08-15', 'pagada'),
(3, 3, 37833.33, '2019-09-15', '2019-09-14', 'pagada'),
(4, 1, 26218.75, '2025-12-09', NULL, 'pendiente'),
(5, 1, 40250.00, '2022-09-20', '2022-10-05', 'vencida'),
(5, 2, 40250.00, '2022-11-01', '2022-11-01', 'pagada'),
(6, 1, 15500.00, '2023-04-01', '2023-04-02', 'vencida'),
(7, 1, 20975.00, '2024-07-06', '2024-07-06', 'pagada'),
(7, 2, 20975.00, '2024-08-06', '2024-08-06', 'pagada'),
(8, 1, 20975.00, '2024-10-01', '2024-11-01', 'vencida'),
(8, 2, 20975.00, '2024-11-01', '2024-12-01', 'vencida'),
(8, 3, 20975.00, '2024-12-01', '2025-01-01', 'vencida');

-- 6) Calificaciones:

INSERT INTO Calificaciones (id_usuario, fecha_calificacion, puntaje, comentario, tipo_calificacion) VALUES
(2, '2020-09-01', 5, 'Pagó todo en término', 'solicitante'),
(5, '2024-05-01', 1, 'Mora en la devolución', 'solicitante'),
(1, '2019-10-01', 3, 'Pagó con demora', 'solicitante'),
(4, '2022-12-01', 2, 'Tiene cuotas vencidas', 'solicitante'),
(2, '2023-05-01', 3, 'Pagó con demora', 'solicitante'),
(9, '2025-01-01', 5, 'Pagó todo en término', 'solicitante'), --
(10, '2025-02-01', 1, 'Tiene todos los pagos vencidos', 'solicitante');
    
-- 7) Transacciones:

INSERT INTO Transacciones (id_usuario, tipo_transaccion, monto_transaccion, fecha_transaccion, descripcion) VALUES
(3, 'aporte', 30000.00, '2020-06-05', 'Aporte al préstamo 1'),
(6, 'aporte', 20000.00, '2020-06-06', 'Aporte al préstamo 1'),
(1, 'aporte', 15000.00, '2024-01-16', 'Aporte al préstamo 2'),
(11, 'aporte', 15000.00, '2024-01-17', 'Aporte al préstamo 2'),
(1, 'aporte', 50000.00, '2019-06-20', 'Aporte al préstamo 3'),
(8, 'aporte', 30000.00, '2019-06-22', 'Aporte al préstamo 3'),
(11, 'aporte', 20000.00, '2019-06-25', 'Aporte al préstamo 3'),
(6, 'aporte', 10000.00, '2025-06-10', 'Aporte al préstamo 4'),
(9, 'aporte', 15000.00, '2025-06-11', 'Aporte al préstamo 4'),
(3, 'aporte', 25000.00, '2022-08-22', 'Aporte al préstamo 5'),
(6, 'aporte', 25000.00, '2022-08-23', 'Aporte al préstamo 5'),
(11, 'aporte', 25000.00, '2022-08-24', 'Aporte al préstamo 5'),
(8, 'aporte', 15000.00, '2023-03-05', 'Aporte al préstamo 6'),
(9, 'aporte', 20000.00, '2024-06-07', 'Aporte al préstamo 7'),
(1, 'aporte', 20000.00, '2024-06-08', 'Aporte al préstamo 7'),
(3, 'aporte', 20000.00, '2024-09-03', 'Aporte al préstamo 8'),
(6, 'aporte', 20000.00, '2024-09-04', 'Aporte al préstamo 8'),
(9, 'aporte', 20000.00, '2024-09-05', 'Aporte al préstamo 8'),
(2, 'pago', 27083.33, '2020-07-01', 'Pago de cuota 1 del préstamo 1'),
(2, 'pago', 27083.34, '2020-08-01', 'Pago de cuota 2 del préstamo 1'),
(5, 'pago', 32500.00, '2024-02-20', 'Pago de cuota 1 del préstamo 2'),
(1, 'pago', 37833.34, '2019-07-16', 'Pago de cuota 1 del préstamo 3'),
(1, 'pago', 37833.33, '2019-08-15', 'Pago de cuota 2 del préstamo 3'),
(1, 'pago', 37833.33, '2019-09-14', 'Pago de cuota 3 del préstamo 3'),
(4, 'pago', 40250.00, '2022-10-05', 'Pago de cuota 1 del préstamo 5'),
(4, 'pago', 40250.00, '2022-11-01', 'Pago de cuota 2 del préstamo 5'),
(2, 'pago', 15500.00, '2023-04-02', 'Pago de cuota 1 del préstamo 6'),
(10, 'pago', 20975.00, '2024-11-01', 'Pago de cuota 1 del préstamo 8'),
(10, 'pago', 20975.00, '2024-12-01', 'Pago de cuota 2 del préstamo 8'),
(10, 'pago', 20975.00, '2025-01-01', 'Pago de cuota 3 del préstamo 8'),
(2, 'intereses', 4166.67, '2020-06-01', 'Interés generado por préstamo 1'),
(5, 'intereses', 2500.00, '2024-01-15', 'Interés generado por préstamo 2'),
(1, 'intereses', 13500.00, '2019-06-15', 'Interés generado por préstamo 3'),
(7, 'intereses', 1218.75, '2025-06-09', 'Interés generado por préstamo 4'),
(4, 'intereses', 5500.00, '2022-08-20', 'Interés generado por préstamo 5'),
(2, 'intereses', 500.00, '2023-03-01', 'Interés generado por préstamo 6'),
(9, 'intereses', 1950.00, '2024-06-06', 'Interés generado por préstamo 7'),
(10, 'intereses', 2925.00, '2024-09-01', 'Interés generado por préstamo 8'),
(5, 'penalidad', 1500.00, '2024-02-20', 'Penalidad por mora en cuota 1 del préstamo 2'),
(4, 'penalidad', 1750.00, '2022-10-05', 'Penalidad por mora en cuota 1 del préstamo 5'),
(1, 'penalidad', 1450.00, '2019-07-16', 'Penalidad por mora en cuota 1 del préstamo 3'),
(2, 'penalidad', 1200.00, '2023-04-02', 'Penalidad por mora en cuota 1 del préstamo 6'),
(10, 'penalidad', 950.00, '2024-11-01', 'Penalidad por mora en cuota 1 del préstamo 8'),
(10, 'penalidad', 950.00, '2024-12-01', 'Penalidad por mora en cuota 2 del préstamo 8'),
(10, 'penalidad', 950.00, '2025-01-01', 'Penalidad por mora en cuota 3 del préstamo 8');

-- 8) Penalidades:

INSERT INTO Penalidades (id_cuota, monto_penalidad, motivo_penalidad, fecha_penalidad) VALUES
(3, 1500.00, 'Penalidad por mora en cuota 1 del préstamo 2', '2024-02-20'),
(4, 1450.00, 'Penalidad por mora en cuota 1 del préstamo 3', '2019-07-16'),
(8, 1750.00, 'Penalidad por mora en cuota 1 del préstamo 5', '2022-10-05'),
(10, 1200.00, 'Penalidad por mora en cuota 1 del préstamo 6', '2023-04-02'),
(13, 950.00, 'Penalidad por mora en cuota 1 del préstamo 8', '2024-11-01'),
(14, 950.00, 'Penalidad por mora en cuota 2 del préstamo 8', '2024-12-01'),
(15, 950.00, 'Penalidad por mora en cuota 3 del préstamo 8', '2025-01-01');

-- 9) Segmentos_Riesgo:

INSERT INTO Segmentos_Riesgo (nombre_segmento, criterios) VALUES 
('Bajo Riesgo', '>= 4 sin mora'),
('Riesgo Medio', 'entre 2<>3'),
('Alto Riesgo', '<= 1 con mora');

-- 10) Usuarios_Segmento:

INSERT INTO Usuarios_Segmento (id_solicitante, id_segmento, fecha_asignacion) VALUES
(1, 2, '2019-09-14'),  -- Riesgo Medio (3 cuotas, 1 vencida) 
(2, 2, '2023-04-02'),  -- Riesgo Medio (3 cuotas, 1 vencida) 
(4, 2, '2022-11-01'),  -- Riesgo Medio (2 cuotas, 1 vencida) 
(5, 3, '2024-02-20'),  -- Alto Riesgo (1 cuota, vencida) 
(9, 1, '2025-01-01'), -- Bajo Riesgo (2 cuotas, 0 vencidas) --
(10, 2, '2024-08-06');  -- Alto Riesgo (3 cuotas, 3 vencidas) --

-- 11) Rentabilidad_Esperada:

INSERT INTO Rentabilidad_Esperada (id_financiamiento, retorno_total, tasa_retorno, fecha_calculo) VALUES
(1, 32500.00, 8.33, '2020-05-30'),
(2, 21666.67, 8.33, '2020-05-31'),
(3, 16250.00, 8.33, '2024-01-13'),  --
(4, 16250.00, 8.33, '2024-01-14'),
(5, 56750.00, 13.50, '2019-06-12'),  --
(6, 34050.00, 13.50, '2019-06-13'),
(7, 22700.00, 13.50, '2019-06-14'),
(8, 10487.50, 4.88, '2025-06-07'),
(9, 15731.25, 4.88, '2025-06-08'),
(10, 26833.33, 7.33, '2022-08-17'),
(11, 26833.33, 7.33, '2022-08-18'),
(12, 26833.33, 7.33, '2022-08-19'),
(13, 15500.00, 3.33, '2023-02-27'),
(14, 20975.00, 4.88, '2024-06-04'),
(15, 20975.00, 4.88, '2024-06-05'),  --
(16, 20975.00, 4.88, '2024-08-28'),
(17, 20975.00, 4.88, '2024-08-29'),
(18, 20975.00, 4.88, '2024-08-30');
