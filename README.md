PROYECTO FINAL: PLATAFORMA DE MICROCREDITOS PEER-TO-PEER (P2P) - MySQL

INTRODUCCION

El surgimiento y avance de la economía digital, junto con la introducción de nuevas fuentes de financiamiento, están cambiando la forma en la que manejamos nuestro dinero. Los sistemas de financiamiento entre pares (Peer-to-Peer o P2P) representan una gran alternativa frente al crédito tradicional. Estos modelos conectan de manera directa a personas que necesitan dinero con aquellas dispuestas a prestarlo a través de plataformas digitales, que se encargan de gestionar, evaluar, asignar y devolver los fondos, eliminando la necesidad de intermediación bancaria.

Este trabajo propone el diseño de una plataforma de microcréditos P2P en MySQL Workbench que permita almacenar, organizar y analizar información clave sobre los usuarios del sistema, así como de las solicitudes de préstamos y su financiamiento, encargándose de la gestión integral del proceso de otorgamiento desde la presentación inicial hasta la devolución de los fondos.

DIAGRAMA ENTIDAD-RELACION (DER)

![Diagrama Entidad-Relacion](Diagrama-ER.png)

LISTADO DE TABLAS

1. Usuarios: almacena la información de las personas que utilizan el servicio, ya sea como prestamistas, solicitantes o ambos.

    - id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - nombre VARCHAR(50) NOT NULL
    - apellido VARCHAR(50) NOT NULL
    - email VARCHAR(50) NOT NULL UNIQUE
    - fecha_nacimiento DATE NOT NULL
    - dni VARCHAR(20) NOT NULL
    - direccion VARCHAR(100) NOT NULL
    - localidad VARCHAR(50) NOT NULL
    - provincia VARCHAR(50) NOT NULL
    - tipo_usuario VARCHAR(20) NOT NULL
    - fecha_registro DATE NOT NULL

2. Tasas_Interes_Historicas: guarda la evolución de las tasas de interés a lo largo del tiempo. Sirve para conocer bajo qué condiciones se otorgó cada préstamo. Aquella que no tenga fecha_fin será la vigente.

    - id_tasa INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - fecha_inicio DATE NOT NULL
    - fecha_fin DATE					
    - tasa_anual DECIMAL(5,2) NOT NULL

3. Solicitud_Prestamos: registra los préstamos solicitados por los usuarios. El estado del préstamo puede ser pagado, vencido o pendiente.

    - id_prestamo INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_solicitante INT NOT NULL
    - monto DECIMAL(10,2) NOT NULL
    - tasa_interes DECIMAL (4,2) NOT NULL
    - plazo_meses INT NOT NULL
    - motivo VARCHAR(50) NOT NULL
    - fecha_solicitud DATE NOT NULL
    - estado VARCHAR(20) NOT NULL
    - id_tasa INT NOT NULL
    - monto_final DECIMAL(10,2) NOT NULL
    - FOREIGN KEY (id_solicitante) REFERENCES Usuarios(id_usuario)	
    - FOREIGN KEY (id_tasa) REFERENCES Tasas_Interes_Historicas(id_tasa)

4. Financiamiento: registra los aportes de dinero que hacen los usuarios prestamistas a los préstamos solicitados. Un préstamo puede ser financiado por uno o varios prestamistas y un prestamista puede participar en uno o varios préstamos.

    - id_financiamiento INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_prestamista INT NOT NULL
    - id_prestamo INT NOT NULL
    - monto_aportado DECIMAL(10,2) NOT NULL
    - fecha_aporte DATE NOT NULL
    - FOREIGN KEY (id_prestamista) REFERENCES Usuarios(id_usuario)
    - FOREIGN KEY (id_prestamo) REFERENCES Solicitud_Prestamos(id_prestamo)

5. Cuotas: contiene las cuotas que el usuario solicitante debe pagar para devolver el préstamo. El estado de las cuotas puede ser pagada, vencida o pendiente.

    - id_cuota INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_prestamo INT NOT NULL
    - numero_cuota INT NOT NULL
    - monto_cuota DECIMAL(10,2) NOT NULL
    - fecha_vencimiento DATE NOT NULL
    - fecha_pago DATE
    - estado VARCHAR(20) NOT NULL
    - FOREIGN KEY (id_prestamo) REFERENCES Solicitud_Prestamos(id_prestamo)	

6. Calificaciones: almacena las evaluaciones del comportamiento financiero de los usuarios como solicitantes de préstamos. El puntaje va del 1 (baja calificación) al 5 (alta calificación).

    - id_calificacion INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_usuario INT NOT NULL
    - fecha_calificacion DATE NOT NULL
    - puntaje INT NOT NULL
    - comentario VARCHAR(50)
    - tipo_calificacion VARCHAR(20) NOT NULL
    - FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)

7. Transacciones: registra los movimientos financieros de cada individuo, ya sea por aportes de fondos, pago de cuotas, intereses o penalidades.

    - id_transaccion INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_usuario INT NOT NULL
    - tipo_transaccion VARCHAR(20) NOT NULL
    - monto_transaccion DECIMAL(10,2) NOT NULL
    - fecha_transaccion DATE NOT NULL
    - descripcion TEXT
    - FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)	

8. Penalidades: registra las penalizaciones por incumplimientos o atrasos en los pagos.

    - id_penalidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_cuota INT NOT NULL
    - monto_penalidad DECIMAL(10,2) NOT NULL
    - motivo_penalidad VARCHAR(100) NOT NULL
    - fecha_penalidad DATE NOT NULL
    - FOREIGN KEY (id_cuota) REFERENCES Cuotas(id_cuota)	

9. Segmentos_Riesgo: tabla estática que almacena los tipos de segmentos de riesgo de impago disponibles según el siguiente criterio: bajo riesgo (>= 4 sin mora), riesgo medio (2<>3) y alto riesgo (<=1 con mora).

    - id_segmento INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - nombre_segmento VARCHAR(50) NOT NULL UNIQUE
    - criterios VARCHAR(100)	

10. Usuarios_Segmento: tabla dinámica que especifica a qué segmento pertenece cada usuario y desde cuándo, para guardar el historial de clasificación de riesgo de cada uno.

    - id_solicitante INT NOT NULL
    - id_segmento INT NOT NULL
    - fecha_asignacion DATE NOT NULL
    - PRIMARY KEY (id_solicitante, id_segmento, fecha_asignacion)
    - FOREIGN KEY (id_solicitante) REFERENCES Usuarios(id_usuario)
    - FOREIGN KEY (id_segmento) REFERENCES Segmentos_Riesgo(id_segmento)	

11. Rentabilidad_Esperada: almacena la rentabilidad obtenida por cada prestamista en cada aporte de dinero.

    - id_rentabilidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    - id_financiamiento INT NOT NULL
    - retorno_total DECIMAL(10,2) NOT NULL
    - tasa_retorno DECIMAL(5,2) NOT NULL
    - fecha_calculo DATE NOT NULL
    - FOREIGN KEY (id_financiamiento) REFERENCES Financiamiento(id_financiamiento) 


OBJETOS

A. VISTAS

      1. Distribucion_Credito_Por_Provincia

- Descripción: vista que agrupa y resume la información de las solicitudes de crédito realizadas por los usuarios según la provincia de residencia. Muestra, para cada provincia, el total de solicitudes de  préstamo realizadas, el número total de usuarios que realizaron solicitudes, el monto total solicitado en créditos y el promedio del monto solicitado por solicitud.

- Objetivo: brindar un análisis geográfico de la distribución del crédito en la plataforma. Esto permite identificar las provincias con mayor demanda de fondos, lo que facilita la toma de decisiones de mercado, de gestión de riesgos y de asignación de recursos.

- Tablas/Datos: las tablas involucradas son Usuarios, que contiene la información geográfica necesaria, y Solicitud_Prestamos, para conocer los detalles de los préstamos realizados.

- Codigo:

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

- Ejemplo de uso:

SELECT * FROM Distribucion_Credito_Por_Provincia;

      2. Volumen_Prestamos_Por_Anio

- Descripción: vista que resume los datos de solicitud de préstamos para mostrar el volumen anual de préstamos solicitados. Muestra, para cada año, la cantidad de préstamos solicitados, el monto prestado total y el promedio del monto por préstamo.

- Objetivo: facilitar el análisis histórico y la toma de decisiones sobre la actividad crediticia anual, sin la necesidad de realizar consultas complejas sobre la tabla de solicitudes de préstamo. Esto ayuda a monitorear tendencias en la demanda de créditos y a planificar estrategias financieras basadas en datos agregados anuales.

- Tablas/Datos: la tabla involucrada es Solicitud_Prestamos, ya que contiene la información sobre la fecha de solicitud y el monto de los préstamos solicitados.
   
      3. Segmento_Riesgo_Actual

- Descripción: vista que muestra el segmento de riesgo más reciente asignado a cada solicitante de préstamos. Incluye información básica como nombre, apellido, provincia, localidad, además del nombre del segmento de riesgo asignado, el criterio de segmentación correspondiente y la fecha de asignación del mismo. Si el segmento de riesgo es nulo, significa que ese usuario aún no tiene asignado uno.

- Objetivo: facilitar el análisis del nivel de riesgo de los solicitantes según los criterios predefinidos de la plataforma, para mejorar el proceso de toma de decisiones de los prestamistas y minimizar el riesgo de impago.

- Tablas/Datos: las tablas involucradas son Usuarios, que brinda la información básica necesaria sobre cada uno de ellos, Usuarios_Segmento, que contiene el historial de segmentos asignados, y Segmentos_Riesgo, que contiene el criterio de clasificación y el nombre de cada segmento.

      4. Morosidad_Prestamos

- Descripción: vista que muestra los préstamos que tienen cuotas vencidas, teniendo en cuenta los datos básicos del préstamo como el solicitante, el monto original y final del préstamo y la fecha de solicitud, así como el número total de cuotas vencidas, el monto total pendiente de pago y los días de atraso máximos.

- Objetivo: identificar aquellos préstamos con morosidad activa para priorizar la cobranza de las cuotas o ajustar el riesgo de impago.

- Tablas/Datos: las tablas involucradas son Solicitud_Prestamos, que se utiliza para obtener la información general del préstamo y del solicitante, y Cuotas, que permite filtrar las cuotas ‘vencidas’ para contabilizarlas y calcular tanto el monto adeudado como los días de atraso en el pago.

      5. Objetivos_Financieros_Usuarios

- Descripción: vista que agrupa las solicitudes de préstamos según el motivo de solicitud de los usuarios, ya sea para vivienda, educación, consumo o capital. Incluye, para cada tipo de objetivo financiero, la cantidad de préstamos otorgados, el monto total de los mismos y el monto promedio destinado de cada uno.

- Objetivo: registrar las metas financieras de los usuarios al solicitar préstamos, facilitando la identificación de patrones de uso de fondos, tendencias de demanda por tipo de necesidad y la priorización de recursos financieros según el destino más frecuente o costoso. Esto permite ajustar la estrategia de financiamiento y segmentar a los solicitantes según sus necesidades de fondos, útil para análisis de impacto social.

- Tablas/Datos: la tabla involucrada es Solicitud_Prestamos, que se utiliza para acceder al campo Motivo, y para calcular las métricas de cantidad, suma y promedio de los préstamos asociados a cada objetivo.

FUNCIONES

