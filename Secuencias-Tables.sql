CREATE TABLE countries
(
  country_id INT PRIMARY KEY,
  country_coin VARCHAR2(250) NOT NULL,
  country_description VARCHAR2(250)NOT NULL
);

CREATE TABLE cities
(
  city_id INT PRIMARY KEY,
  city_description VARCHAR2(250)NOT NULL,
  country_id NOT NULL, 
  CONSTRAINT fk_city_country FOREIGN KEY(country_id) REFERENCES countries(country_id)
);

CREATE TABLE lenguages
(
  lenguage_id INT PRIMARY KEY,
  lenguage_description VARCHAR2(250)NOT NULL
);

CREATE TABLE profiles
(
  profile_id INT PRIMARY KEY,
  profile_login VARCHAR2(250) NOT NULL,
  profile_password VARCHAR2(250)NOT NULL,
  profile_fullname VARCHAR2(250)NOT NULL,
  profile_protourl VARCHAR2(500)NOT NULL,
  profile_phone VARCHAR2(250) NOT NULL,
  city_id INT NOT NULL, 
  lenguage_id INT NOT NULL, 
  CONSTRAINT fk_profile_city FOREIGN KEY(city_id) REFERENCES cities(city_id),
  CONSTRAINT fk_profile_lenguage FOREIGN KEY(lenguage_id) REFERENCES lenguages(lenguage_id)
);

CREATE TABLE drivers
(
  driver_id INT PRIMARY KEY,
  profile_id INT NOT NULL, 
  CONSTRAINT fk_driver_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE vehicles
(
  vehicle_id INT PRIMARY KEY,
  vehicle_number VARCHAR2(250) NOT NULL,
  vehicle_brand VARCHAR2(250)NOT NULL,
  vehicle_model VARCHAR2(250)NOT NULL,
  vehicle_year DATE NOT NULL,
  driver_id INT NOT NULL, 
  CONSTRAINT fk_vehicle_driver FOREIGN KEY(driver_id) REFERENCES drivers(driver_id)
);

CREATE TABLE consignaments
(
  consignament_id INT PRIMARY KEY,
  consignament_valuegain FLOAT NOT NULL,
  travel_number INT NOT NULL,
  consignament_percentuber FLOAT NOT NULL,
  consignament_totalvalue FLOAT NOT NULL,
  driver_id INT NOT NULL,
  CONSTRAINT fk_consignament_driver FOREIGN KEY(driver_id) REFERENCES drivers(driver_id)
);

CREATE TABLE customers
(
  customer_id INT PRIMARY KEY,
  reference_code VARCHAR2(250) NOT NULL,
  profile_id INT NOT NULL, 
  CONSTRAINT fk_customer_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE emails
(
  email_id INT PRIMARY KEY,
  email_address VARCHAR2(250) NOT NULL,
  email_notification VARCHAR2(250) NOT NULL,
  payment_number VARCHAR2(250) NOT NULL,
  profile_id INT NOT NULL, 
  CONSTRAINT fk_emails_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE billscompanies
(
  bill_id INT PRIMARY KEY,
  bill_number VARCHAR2(250)NOT NULL,
  bill_nit INT NOT NULL,
  bill_descrption VARCHAR2(250) NOT NULL,
  payment_id INT NOT NULL,
  payment_number INT NOT NULL,
  profile_id INT NOT NULL, 
  CONSTRAINT fk_billscompanies_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE serviceTypes
(
  type_id INT PRIMARY KEY,
  type_description VARCHAR2(250)NOT NULL
);

CREATE TABLE invitations
(
  invitation_id INT PRIMARY KEY,
  invitation_code INT NOT NULL,
  invitation_status VARCHAR2(250) NOT NULL,
  customer_id INT NOT NULL, 
  CONSTRAINT fk_invitation_customer FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE paymentMethods
(
  payment_id INT PRIMARY KEY,
  payment_description VARCHAR2(250)NOT NULL,
  payment_number INT NOT NULL,
  payment_date DATE NOT NULL,
  profile_id INT NOT NULL, 
  CONSTRAINT fk_payment_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE tripsDetail
(
  trip_id INT PRIMARY KEY,
  trip_datetimestart TIMESTAMP NOT NULL,
  trip_kilometer FLOAT NOT NULL,
  trip_second TIMESTAMP NOT NULL,
  trip_latitude FLOAT NOT NULL,
  trip_logitude FLOAT NOT NULL,
  trip_datetimeend TIMESTAMP NOT NULL
);

CREATE TABLE travelDetails
(
  detail_id INT PRIMARY KEY,
  trail_total INT NOT NULL,
  detail_valuestart FLOAT NOT NULL,
  detail_valueend FLOAT NOT NULL,
  detail_valuedinamic FLOAT NOT NULL,
  invitation_code INT,
  vehicle_number VARCHAR2(250) NOT NULL,
  travel_timeend TIMESTAMP NOT NULL,
  payment_number INT NOT NULL,
  bill_number VARCHAR2(250)
);

CREATE TABLE travels
(
  travel_id INT PRIMARY KEY,
  payment_description VARCHAR2(250)NOT NULL,
  travel_number INT NOT NULL,
  travel_date DATE NOT NULL,
  travel_status VARCHAR2(250) NOT NULL,
  travel_origin VARCHAR2(250) NOT NULL,
  travel_destination VARCHAR2(250) NOT NULL,
  travel_timestart TIMESTAMP NOT NULL,
  travel_timeend  TIMESTAMP NOT NULL,
  detail_id INT NOT NULL,
  trip_id INT NOT NULL,
  type_id INT NOT NULL,
  driver_id INT NOT NULL,
  customer_id INT NOT NULL,
  profile_id INT NOT NULL, 
  CONSTRAINT fk_travels_driver FOREIGN KEY(driver_id) REFERENCES drivers(driver_id),
  CONSTRAINT fk_travels_detail FOREIGN KEY(detail_id) REFERENCES travelDetails(detail_id),
  CONSTRAINT fk_travel_trip FOREIGN KEY(trip_id) REFERENCES tripsDetail(trip_id),
  CONSTRAINT fk_travels_type FOREIGN KEY(type_id) REFERENCES serviceTypes(type_id),
  CONSTRAINT fk_travels_customer FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_paymentmethod_profile FOREIGN KEY(profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE travelsShared
(
  shared_id INT PRIMARY KEY,
  shared_value FLOAT NOT NULL,
  shared_custumer INT NOT NULL,
  detail_id  INT NOT NULL,
  CONSTRAINT fk_travel_travelShared FOREIGN KEY(detail_id) REFERENCES travelDetails(detail_id)
);

---------------------------------------------------------------

CREATE SEQUENCE vehicles_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE consignments_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE travels_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE tripDetail_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE drivers_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE city_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE country_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE lenguage_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE PaymentMethod_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE customer_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE profiles_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE billsCompany_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE invitations_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE travelDetail_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE serviceType_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE travelShared_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE SEQUENCE emailAddress_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;












