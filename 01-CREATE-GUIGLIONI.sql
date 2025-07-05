# CREACION DE BASE DE DATOS #

DROP DATABASE IF EXISTS creditosP2P;
CREATE DATABASE IF NOT EXISTS creditosP2P;
USE creditosP2P;

# CREACION DE TABLAS #

-- La primera tabla 'USUARIOS' corresponde a personas que pueden ser prestamistas, solicitantes o ambos.

CREATE TABLE Usuarios(
	id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    dni VARCHAR(20) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL,	-- prestamistas, solicitantes y ambos
    fecha_registro DATE NOT NULL
);
    
SELECT * FROM Usuarios;

-- La segunda tabla 'TASAS_INTERES_HISTORICAS' va a guardar la evolucion de las tasas de interes a lo largo del tiempo

CREATE TABLE Tasas_Interes_Historicas(
	id_tasa INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,						-- puede ser nula si está vigente
    tasa_anual DECIMAL(5,2) NOT NULL
);
	
SELECT * FROM Tasas_Interes_Historicas;

-- La tercera tabla 'SOLICITUD_PRESTAMOS' corresponde al registro de préstamos solicitados por un usuario.	

CREATE TABLE Solicitud_Prestamos(
	id_prestamo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_solicitante INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,	-- 10 numeros y 2 decimales
    tasa_interes DECIMAL (4,2) NOT NULL,	-- % anual
    plazo_meses INT NOT NULL,		-- equivale a total de cuotas
    motivo VARCHAR(50) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    estado VARCHAR(20) NOT NULL,	-- pendiente, pagado, vencido
    id_tasa INT NOT NULL,
    monto_final DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_solicitante) REFERENCES Usuarios(id_usuario),	
    FOREIGN KEY (id_tasa) REFERENCES Tasas_Interes_Historicas(id_tasa)	
);

SELECT * FROM Solicitud_Prestamos;

-- La cuarta tabla 'FINANCIAMIENTO' corresponde a los usuarios que financian los prestamos, en su totalidad o en parte. 

CREATE TABLE Financiamiento(
	id_financiamiento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_prestamista INT NOT NULL,
    id_prestamo INT NOT NULL,
    monto_aportado DECIMAL(10,2) NOT NULL,
    fecha_aporte DATE NOT NULL,
    FOREIGN KEY (id_prestamista) REFERENCES Usuarios(id_usuario),	
    FOREIGN KEY (id_prestamo) REFERENCES Solicitud_Prestamos(id_prestamo)	
);

SELECT * FROM Financiamiento;

-- La quinta tabla 'CUOTAS' corresponde a los pagos realizados por el solicitante para devolver el prestamo.

CREATE TABLE Cuotas(
	id_cuota INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    numero_cuota INT NOT NULL,
    monto_cuota DECIMAL(10,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_pago DATE,
    estado VARCHAR(20) NOT NULL,	-- pendiente, pagada o vencida
    FOREIGN KEY (id_prestamo) REFERENCES Solicitud_Prestamos(id_prestamo)	
);
 
SELECT * FROM Cuotas;

-- La sexta tabla 'CALIFICACIONES' corresponde a la evaluacion del usuario segun su comportamiento financiero, que puede variar con el tiempo.

CREATE TABLE Calificaciones(
	id_calificacion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_calificacion DATE NOT NULL,
    puntaje INT NOT NULL,	-- del 1 al 5
    comentario VARCHAR(50),
    tipo_calificacion VARCHAR(20) NOT NULL, 	-- como solicitante 
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)	
);
    
SELECT * FROM Calificaciones;

-- La septima tabla 'TRANSACCIONES' corresponde al registro de los movimientos de fondos individuales (ya sea por pago de cuotas, intereses, penalidades, etc)

CREATE TABLE Transacciones(
	id_transaccion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_transaccion VARCHAR(20) NOT NULL, 		-- aporte, pago, intereses, penalidad
    monto_transaccion DECIMAL(10,2) NOT NULL,
    fecha_transaccion DATE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)	
);
    
SELECT * FROM Transacciones;

-- La octava tabla 'PENALIDADES' corresponde al registro de las penalizaciones por incumplimientos o pagos atrasados

CREATE TABLE Penalidades(
	id_penalidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_cuota INT NOT NULL,
    monto_penalidad DECIMAL(10,2) NOT NULL,
    motivo_penalidad VARCHAR(100) NOT NULL,
    fecha_penalidad DATE NOT NULL,
    FOREIGN KEY (id_cuota) REFERENCES Cuotas(id_cuota)	
);
    
SELECT * FROM Penalidades;

-- La novena tabla 'SEGMENTOS_RIESGO' va a guardar los tipos de segmentos de riesgo disponibles (bajo riesgo (>=4 sin mora) , riesgo medio (2<>3) y alto riesgo (<=1 con mora))

CREATE TABLE Segmentos_Riesgo(
	id_segmento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre_segmento VARCHAR(50) NOT NULL UNIQUE,	-- bajo riesgo, riesgo medio o alto riesgo
	criterios VARCHAR(100)							-- >=4 sin mora, 2<>3 o <=1 con mora
);
		-- Es una tabla estatica sin FKs. No incluye solicitantes porque estos pueden cambiar de segmento con el tiempo
        
SELECT * FROM Segmentos_Riesgo;

-- La decima tabla 'USUARIOS_SEGMENTO' va a especificar qué solicitante de prestamo pertenece a cada segmento y desde cuando

CREATE TABLE Usuarios_Segmento(
	id_solicitante INT NOT NULL,
    id_segmento INT NOT NULL,
    fecha_asignacion DATE NOT NULL,
    PRIMARY KEY (id_solicitante, id_segmento, fecha_asignacion),	-- para mantener el historial de un usuario si este cambia de segmento
    FOREIGN KEY (id_solicitante) REFERENCES Usuarios(id_usuario),	
    FOREIGN KEY (id_segmento) REFERENCES Segmentos_Riesgo(id_segmento)	
);

SELECT * FROM Usuarios_Segmento;

-- La undecima tabla 'RENTABILIDAD_ESPERADA' corresponde a la rentabilidad obtenida por cada prestamista en cada aporte de dinero

CREATE TABLE Rentabilidad_Esperada (
    id_rentabilidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_financiamiento INT NOT NULL,
    retorno_total DECIMAL(10,2) NOT NULL,         -- Monto recuperado (capital + intereses)
    tasa_retorno DECIMAL(5,2) NOT NULL,           -- Retorno % sobre monto_aportado
    fecha_calculo DATE NOT NULL,
    FOREIGN KEY (id_financiamiento) REFERENCES Financiamiento(id_financiamiento) 
);

SELECT * FROM Rentabilidad_Esperada;

