--PRIMERA VISTA
CREATE VIEW MEDIOS_PAGO_CLIENTES AS 
(
	SELECT C.customer_id  AS CLIENTE_ID
		   ,U.user_fullname AS NOMBRE_CLIENTE
		   ,P.payment_id AS MEDIO_PAGO_ID
		   ,P.payment_type AS TIPO 
		   ,P.payment_detail AS DETALLES_MEDIO_PAGO
		   ,CASE WHEN CP.company_id IS NO NULL THEN TRUE ELSE FALSE END AS EMPRESARIAL
		   ,CASE WHEN CP.company_id IS NO NULL THEN CP.company_name ELSE NULL END AS EMPRESARIAL
	FROM  Customers AS C
	INNER JOIN Users AS U ON U.user_id=C.user_id  
	INNER JOIN PaymentMethod AS P  ON P.user_id=U.user_id
	LEFT OUTER JOIN Company AS CP ON CP.company_id=C.company_id;
)

--SEGUNDA VISTA
CREATE VIEW  VIAJES_CLIENTES AS 
(
	SELECT T.travel_date AS FECHA_VIAJE
		   ,U.user_fullname  AS NOMBRE_CONDUCTOR
		   ,V.vehicle_brand AS PLACA_VEHICULO
		   ,U2.user_fullname AS NOMBRE_CLIENTE
		   ,T.travel_totalvalue AS VALOR TOTAL
		   ,CASE WHEN TD.detail_value_dinamic =0 THEN FALSO THEN TRUE END TARIFA_DINAMICA
		   ,S.type_description AS TIPO_SERVICIO
		   --,T.travel_origin AS CIUDAD_VIAJE  --?
	FROM Travels AS T 
	INNER JOIN VehiclesDrivers AS VD ON VD.vdriver_id=T.vdriver_id
	INNER JOIN Drivers AS D ON D.driver_id=VD.driver_id 
	INNER JOIN Users AS U ON U.user_id=D.user_id 
	INNER JOIN Vehicles AS V ON V.vehicle_id=VD.vehicle_id 
	INNER JOIN Customers AS C ON C.custumer_id=T.custumer_id
	INNER JOIN Users AS U2 ON U.user_id=C.user_id 
	INNER JOIN TravelDetail TD ON TD.travel_id=T.travel_id
	INNER JOIN ServiceType S ON S.type_id=T.type_id;
)

--CREACION FUNCION KILOMETROS
CREATE OR REPLACE FUNCTION VALOR_DISTANCIA (DISTANCIAK NUMBER,CIUDAD VARCHAR2(20))
  RETURN VARCHAR2
 IS
  VALORRETORNADO NUMBER;
 BEGIN
   VALORRETORNADO:=0;
   
   DECLARE EXIST = (SELECT city_id  FROM City WHERE city_description = CIUDAD )
   
   IF (EXIST IS NOT NULL AND DISTANCIAK < 0) AND  THEN
      RETURN VALORRETORNADO:=(SELECT (rate_km * DISTANCIAK) AS VALOR   FROM City WHERE city_description = CIUDAD );
   ELSE 
       DBMS_OUTPUT.PUT_LINE('CAMPOS NO VALIDOS PARA CALCULOS DENTRO DE LA FUNCION ');
   END IF;
   
   EXCEPTION
	WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001,'No se puede dividir por cero');
 END;
 
 
--CREACION FUNCION MINUTOS
CREATE OR REPLACE FUNCTION VALOR_DISTANCIA (MINUTOS NUMBER,CIUDAD VARCHAR2(20))
  RETURN VARCHAR2
 IS
  VALORRETORNADO NUMBER;
 BEGIN
   VALORRETORNADO:=0;
   
   DECLARE EXIST = (SELECT city_id  FROM City WHERE city_description = CIUDAD )
   
   IF (EXIST IS NOT NULL AND MINUTOS < 0) AND  THEN
      RETURN VALORRETORNADO:=(SELECT (rate_mn * MINUTOS) AS VALOR   FROM City WHERE city_description = CIUDAD );
   ELSE 
       DBMS_OUTPUT.PUT_LINE('CAMPOS NO VALIDOS PARA CALCULOS DENTRO DE LA FUNCION ');
   END IF;
   
   EXCEPTION
	WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001,'No se puede dividir por cero');
 END;

 
 --CREACION PROCEDIMIENTO ALMACENADO
CREATE OR REPLACE 
PROCEDURE  CALCULAR_TARIFA(ID_VIAJE NUMBER)
IS
  -- Declaracion de variables locales
BEGIN
  -- Sentencias
  --Se debe crear una tabla temporal la cual guardara la informacion ya calculadas para trabajar en los puntos siguientes
  --Conel query en una tabla temporal se realizan los if con las peticiones de los puntos
  --a. Si el estado del viaje es diferente a REALIZADO, deberá insertar 0 en el valor de la tarifa. 
	
  --b. Buscar el valor de la tarifa base dependiendo de la ciudad donde se haya hecho el servicio. 
  
  --Se envian parametros  a las funciones y se almacena el resultado en variables declaradas
  --c. Invocar la función VALOR_DISTANCIA 
  --d. Invocar la función VALOR_TIEMPO 
  
  --Este se realiza en el query principal que se almacena en la tabla temporal con un calculo de funciones de agregacion
  --e. Deberá buscar todos los detalles de cada viaje y sumarlos. 
  
  --f. Sumar la tarifa base más el resultado de la función VALOR_DISTANCIA más el resultado de la función VALOR_TIEMPO 
  --y el resultado de la sumatoria de los detalles del viaje. g. Actualizar el registro del viaje con el resultado obtenido. h. Si alguna de las funciones levanta una excepción, esta deberá ser controlada y actualizar el               valor del viaje con 0.

END Actualiza_Saldo; 
