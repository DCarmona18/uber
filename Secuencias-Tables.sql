CREATE TABLE Country
(
  country_id INT PRIMARY KEY,
  country_Coin NUMBER NOT NULL,
  country_description VARCHAR2(30)NOT NULL
);

CREATE TABLE City
(
  city_id INT PRIMARY KEY,
  city_description VARCHAR2(250)NOT NULL,
  country_id NOT NULL, 
  base NUMBER NOT NULL, 
  rate_km NUMBER NOT NULL, 
  rate_mn NUMBER NOT NULL, 
  CONSTRAINT fk_city_country FOREIGN KEY(country_id) REFERENCES Country(country_id)
);

CREATE TABLE Language
(
  language_id INT PRIMARY KEY,
  language_description VARCHAR2(250)NOT NULL
);

CREATE TABLE Users
(
  user_id INT PRIMARY KEY,
  user_login VARCHAR2(250) NOT NULL,
  user_password VARCHAR2(250)NOT NULL,
  user_fullname VARCHAR2(250)NOT NULL,
  user_photourl VARCHAR2(500)NOT NULL,
  user_phone VARCHAR2(250) NOT NULL,
  city_id INT NOT NULL, 
  language_id INT NOT NULL, 
  CONSTRAINT fk_profile_city FOREIGN KEY(city_id) REFERENCES City(city_id),
  CONSTRAINT fk_profile_language FOREIGN KEY(language_id) REFERENCES Language(language_id)
);

CREATE TABLE Drivers
(
  driver_id INT PRIMARY KEY,
  user_id INT NOT NULL, 
  CONSTRAINT fk_driver_profile FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

CREATE TABLE Vehicles
(
  vehicle_id INT PRIMARY KEY,
  vehicle_number VARCHAR2(250) NOT NULL,
  vehicle_brand VARCHAR2(250)NOT NULL,
  vehicle_model VARCHAR2(250)NOT NULL,
  vehicle_year DATE NOT NULL
);

CREATE TABLE VehiclesDrivers
(
  vdriver_id INT PRIMARY KEY,
  vehicle_id NOT NULL,
  driver_id NOT NULL,
  CONSTRAINT fk_vdriver_vehicle FOREIGN KEY(vehicle_id) REFERENCES Vehicles(vehicle_id),
  CONSTRAINT fk_vdriver_driver FOREIGN KEY(driver_id) REFERENCES Drivers(driver_id)
);

CREATE TABLE Consignments
(
  consignments_id INT PRIMARY KEY,
  consignments_valuegain FLOAT NOT NULL,
  travel_number INT NOT NULL,
  consignments_percentuber FLOAT NOT NULL,
  consignments_totalvalue FLOAT NOT NULL,
  driver_id INT NOT NULL,
  CONSTRAINT fk_consignments_driver FOREIGN KEY(driver_id) REFERENCES Drivers(driver_id)
);

CREATE TABLE Company
(
  company_id INT PRIMARY KEY,
  company_name VARCHAR2(250) NOT NULL,
  company_nit VARCHAR2(250) NOT NULL
);


CREATE TABLE Customers
(
  customer_id INT PRIMARY KEY,
  reference_code VARCHAR2(250) NOT NULL,
  user_id INT NOT NULL, 
  company_id INT,
  CONSTRAINT fk_customer_profile FOREIGN KEY(user_id) REFERENCES Users(user_id),
  CONSTRAINT fk_customer_company FOREIGN KEY(company_id) REFERENCES Company(company_id)
);

CREATE TABLE Email
(
  email_id INT PRIMARY KEY,
  email_address VARCHAR2(250) NOT NULL,
  email_notification VARCHAR2(250) NOT NULL,
  payment_number VARCHAR2(250) NOT NULL,
  user_id INT NOT NULL, 
  CONSTRAINT fk_Email_profile FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

CREATE TABLE PaymentMethod
(
  payment_id INT PRIMARY KEY,
  payment_detail VARCHAR2(250)NOT NULL,
  payment_type VARCHAR2(250)NOT NULL,
  user_id INT NOT NULL, 
  CONSTRAINT fk_payment_profile FOREIGN KEY(user_id) REFERENCES Users(user_id)
);


CREATE TABLE BillsCompany
(
  bill_id INT PRIMARY KEY,
  bill_number VARCHAR2(250)NOT NULL,
  bill_description VARCHAR2(250)NOT NULL,
  payment_id INT NOT NULL,
  CONSTRAINT fk_BillsCompany_profile FOREIGN KEY(payment_id) REFERENCES PaymentMethod(payment_id)
);

CREATE TABLE ServiceType
(
  type_id INT PRIMARY KEY,
  type_description VARCHAR2(250)NOT NULL
);

CREATE TABLE Invitations
(
  invitation_id INT PRIMARY KEY,
  invitation_code INT NOT NULL,
  invitation_status VARCHAR2(250) NOT NULL,
  customer_id INT NOT NULL, 
  CONSTRAINT fk_invitation_customer FOREIGN KEY(customer_id) REFERENCES Customers(customer_id)
);



CREATE TABLE TripDetail
(
  trip_id INT PRIMARY KEY,
  trip_datetimestart TIMESTAMP NOT NULL,
  trip_second TIMESTAMP NOT NULL,
  trip_latitude FLOAT NOT NULL,
  trip_logitude FLOAT NOT NULL,
  trip_datetimeend TIMESTAMP NOT NULL
);




CREATE TABLE TravelDetail
(
  detail_id INT PRIMARY KEY,
  trail_total INT NOT NULL,
  detail_valuestart FLOAT NOT NULL,
  detail_valueend FLOAT NOT NULL,
  detail_valuedinamic FLOAT NOT NULL,
  invitation_code INT,
  vehicle_number VARCHAR2(250) NOT NULL,
  travel_timeend TIMESTAMP NOT NULL,
  payment_id INT NOT NULL,
  bill_id INT,
  CONSTRAINT fk_TravelDetail_payment FOREIGN KEY(payment_id) REFERENCES PaymentMethod(payment_id)
);

CREATE TABLE Travels
(
  travel_id INT PRIMARY KEY,
  payment_description VARCHAR2(250)NOT NULL,
  travel_number INT NOT NULL,
  travel_date DATE NOT NULL,
  travel_status VARCHAR2(250) NOT NULL,
  travel_origin VARCHAR2(250) NOT NULL,
  travel_destination VARCHAR2(250) NOT NULL,
  travel_totalvalue VARCHAR2(250) NOT NULL,
  travel_timestart TIMESTAMP NOT NULL,
  travel_timeend  TIMESTAMP NOT NULL,
  detail_id INT NOT NULL,
  trip_id INT NOT NULL,
  type_id INT NOT NULL,
  vdriver_id INT NOT NULL,
  city_id INT NOT NULL,
  customer_id INT NOT NULL,
  user_id INT NOT NULL, 
  CONSTRAINT fk_Travels_driver FOREIGN KEY(vdriver_id) REFERENCES VehiclesDrivers(vdriver_id),
  CONSTRAINT fk_Travels_detail FOREIGN KEY(detail_id) REFERENCES TravelDetail(detail_id),
  CONSTRAINT fk_travel_trip FOREIGN KEY(trip_id) REFERENCES TripDetail(trip_id),
  CONSTRAINT fk_travel_city FOREIGN KEY(city_id) REFERENCES City(city_id),
  CONSTRAINT fk_Travels_type FOREIGN KEY(type_id) REFERENCES ServiceType(type_id),
  CONSTRAINT fk_Travels_customer FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),
  CONSTRAINT fk_paymentmethod_profile FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

CREATE TABLE TravelShared
(
  shared_id INT PRIMARY KEY,
  shared_value FLOAT NOT NULL,
  shared_custumer INT NOT NULL,
  detail_id  INT NOT NULL,
  CONSTRAINT fk_travel_travelShared FOREIGN KEY(detail_id) REFERENCES TravelDetail(detail_id)
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

CREATE SEQUENCE language_seq
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

CREATE SEQUENCE users_seq
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












