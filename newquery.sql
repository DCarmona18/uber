--PRIMERA VISTA
CREATE OR REPLACE VIEW MEDIOS_PAGO_CLIENTES AS 
SELECT C.customer_id  AS CLIENTE_ID
       ,U.user_fullname AS NOMBRE_CLIENTE
       ,P.payment_id AS MEDIO_PAGO_ID
       ,P.payment_type AS TIPO 
       ,P.payment_detail AS DETALLES_MEDIO_PAGO
       ,CASE
        WHEN CP.company_id IS NOT NULL THEN 'TRUE'
        ELSE 'FALSE' END AS IS_EMPRESARIAL
       ,CASE 
       WHEN CP.company_id IS NOT NULL THEN CP.company_name 
       ELSE NULL END AS EMPRESARIAL
  FROM  Customers C
  INNER JOIN Users U ON U.user_id=C.user_id  
  INNER JOIN PaymentMethod P  ON P.user_id=U.user_id
  LEFT OUTER JOIN Company CP ON CP.company_id=C.company_id;

--SEGUNDA VISTA
CREATE OR REPLACE VIEW  VIAJES_CLIENTES AS 
	SELECT T.travel_date AS FECHA_VIAJE
       ,U.user_fullname  AS NOMBRE_CONDUCTOR
       ,V.vehicle_brand AS PLACA_VEHICULO
       ,U2.user_fullname AS NOMBRE_CLIENTE
       ,T.travel_totalvalue AS VALOR_TOTAL
       ,CASE WHEN TD.detail_valuedinamic =0 THEN 'FALSO' ELSE 'TRUE' END TARIFA_DINAMICA
       ,S.type_description AS TIPO_SERVICIO
       ,Y.CITY_DESCRIPTION  AS CIUDAD_VIAJE
  FROM Travels T
  INNER JOIN VehiclesDrivers VD ON VD.vdriver_id = T.vdriver_id
  INNER JOIN Drivers D ON D.driver_id=VD.driver_id 
  INNER JOIN Users U ON U.user_id=D.user_id 
  INNER JOIN Vehicles V ON V.vehicle_id=VD.vehicle_id 
  INNER JOIN Customers C ON C.customer_id=T.customer_id
  INNER JOIN Users U2 ON U2.user_id=C.user_id 
  INNER JOIN TravelDetail TD ON TD.detail_id=T.detail_id
  INNER JOIN ServiceType S ON S.type_id=T.type_id
  INNER JOIN City Y ON Y.city_id=T.city_id;


--CREACION FUNCION KILOMETROS
CREATE OR REPLACE FUNCTION VALOR_DISTANCIA (DISTANCIAK IN NUMBER,CIUDAD IN VARCHAR2)
  RETURN NUMBER
 AS
  city_id CITY.city_id%TYPE;
  rate_km CITY.rate_km%TYPE;
  VALOR NUMBER := 0;
  invalid_id_exception EXCEPTION;
 BEGIN
   
   SELECT city_id, rate_km INTO city_id, rate_km FROM City WHERE city_description = CIUDAD;

   IF (city_id <= 0 OR DISTANCIAK < 0)  THEN
      RAISE invalid_id_exception;
    ELSE   
    RETURN (DISTANCIAK*rate_km);
   END IF;
   
   EXCEPTION
    WHEN invalid_id_exception THEN
    DBMS_OUTPUT.PUT_LINE('City not found');
 END;

 
--CREACION FUNCION MINUTOS
CREATE OR REPLACE FUNCTION VALOR_TIEMPO (MINUTOSK IN NUMBER,CIUDAD IN VARCHAR2)
  RETURN NUMBER
 AS
  city_id CITY.city_id%TYPE;
  rate_mn CITY.rate_mn%TYPE;
  VALOR NUMBER := 0;
  invalid_id_exception EXCEPTION;
 BEGIN
   
   SELECT city_id, rate_mn INTO city_id, rate_mn FROM City WHERE city_description = CIUDAD;

   IF (city_id <= 0 OR MINUTOSK < 0)  THEN
      RAISE invalid_id_exception;
    ELSE   
    RETURN (MINUTOSK*rate_mn);
   END IF;
   
   EXCEPTION
    WHEN invalid_id_exception THEN
    DBMS_OUTPUT.PUT_LINE('City not found');
 END;

--CREACION PROCEDIMIENTO ALMACENADO
CREATE OR REPLACE 
PROCEDURE CALCULAR_TARIFA(ID_VIAJE IN NUMBER)
AS
  -- Declaracion de variables locales
  status TRAVELS.TRAVEL_STATUS%TYPE;
  city_id TRAVELS.CITY_ID%TYPE;
  timestart TRAVELS.TRAVEL_TIMESTART%TYPE;
  timeend TRAVELS.TRAVEL_TIMEEND%TYPE;
  
  base CITY.BASE%TYPE;
  rate_km CITY.RATE_KM%TYPE;
  rate_mn CITY.RATE_MN%TYPE;
  city CITY.city_description%TYPE;
  trip_second TRIPDETAIL.TRIP_SECOND%TYPE;
  sum_detail NUMBER :=0;
  minutos NUMBER := 0;
  valor_distancia NUMBER:= 0;
  valor_tiempo NUMBER:= 0;
  VALOR NUMBER := 0;
  CURSOR c_travels IS SELECT * FROM TRAVELS
BEGIN
  -- Sentencias
    --e. Deberá buscar todos los detalles de cada viaje y sumarlos. 
  SELECT T.travel_status
         ,T.city_id
         ,T.travel_timestart
         ,T.travel_timeend
         ,TD.TRIP_SECOND 
         ,sum(TV.DETAIL_VALUEEND+TV.DETAIL_VALUEDINAMIC/*+TV.IVA+TV.DESCUENTO*/) AS sum_detail 
  INTO   status
         ,city_id
         ,timestart
         ,timeend 
         ,trip_second 
         ,sum_detail
  FROM Travels T
  INNER JOIN TripDetail TD ON TD.TRIP_ID = T.TRIP_ID
  INNER JOIN TravelDetail TV ON TV.detail_id = T.detail_id
  WHERE travel_id = ID_VIAJE;
  
  --a. Si el estado del viaje es diferente a REALIZADO, deberá insertar 0 en el valor de la tarifa. 
  IF status = 'REALIZADO' THEN
    UPDATE Travels SET TRAVEL_TOTALVALUE = 0 
    WHERE travel_id = ID_VIAJE;
  END IF;
  
  --b. Buscar el valor de la tarifa base dependiendo de la ciudad donde se haya hecho el servicio. 
  SELECT city_description
         ,base
         ,rate_km
         ,rate_mn 
  INTO   city
         ,base
         ,rate_km
         ,rate_mn 
  FROM City 
  WHERE city_id = city_id;
  --Se envian parametros  a las funciones y se almacena el resultado en variables declaradas
  --c. Invocar la función VALOR_DISTANCIA 
  valor_distancia := VALOR_DISTANCIA(trail,city);
  --d. Invocar la función VALOR_TIEMPO 
  
  valor_tiempo := VALOR_TIEMPO(trip_second,city);
  --CONTROLAR ERRORES EN RETORNOS DEJAR POR DEFECTO VALOR CERO 
  
  --Este se realiza en el query principal que se almacena en la tabla temporal con un calculo de funciones de agregacion
  --f. Sumar la tarifa base más el resultado de la función VALOR_DISTANCIA más el resultado de la función VALOR_TIEMPO 
  VALOR := (valor_distancia+valor_tiempo+sum_detail+base);
  --y el resultado de la sumatoria de los detalles del viaje. 
  --g. Actualizar el registro del viaje con el resultado obtenido. 
    IF VALOR > 0 THEN
      UPDATE Travels SET TRAVEL_TOTALVALUE = VALOR
      WHERE travel_id = ID_VIAJE;
    END IF;
  --h. Si alguna de las funciones levanta una excepción, esta deberá ser controlada y actualizar el valor del viaje con 0.

END; 