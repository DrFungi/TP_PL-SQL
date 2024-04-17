rem Laboratory database
rem MODIFIED
rem  
rem CONGDON       Invoked in RDBMS at build time. 2024-04-16
rem OATES:        Created: 2024-04-16

DROP USER labo CASCADE;

CREATE USER labo IDENTIFIED BY "D45epeUcfhr3_";

GRANT CREATE MATERIALIZED VIEW,
      CREATE PROCEDURE,
      CREATE SEQUENCE,
      CREATE SESSION,
      CREATE SYNONYM,
      CREATE TABLE,
      CREATE TRIGGER,
      CREATE TYPE,
      CREATE VIEW
  TO labo;

ALTER SESSION SET CURRENT_SCHEMA=labo;
ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

--CONNECT labo/"D45epeUcfhr3_";

SET TERMOUT OFF
SET ECHO OFF

DROP TABLE Requestor CASCADE CONSTRAINTS;
DROP TABLE Technicien CASCADE CONSTRAINTS;
DROP TABLE SampleType CASCADE CONSTRAINTS;
DROP TABLE Origin CASCADE CONSTRAINTS;
DROP TABLE Application CASCADE CONSTRAINTS;
DROP TABLE BusinessUnit CASCADE CONSTRAINTS;
DROP TABLE Test CASCADE CONSTRAINTS;
DROP TABLE Unit CASCADE CONSTRAINTS;
DROP TABLE Result CASCADE CONSTRAINTS;
DROP TABLE YeastStrain CASCADE CONSTRAINTS;
DROP TABLE Sample CASCADE CONSTRAINTS;

PROMPT Please wait while tables are created....


CREATE TABLE Requestor (
  Requestor_ID   number(10) GENERATED ALWAYS AS IDENTITY, 
  requestor_name varchar2(50) NOT NULL, 
  PRIMARY KEY (Requestor_ID));

CREATE TABLE Technician (
  Technician_ID number(10) GENERATED ALWAYS AS IDENTITY,
  Technician_name varchar2(50) NOT NULL,
  PRIMARY KEY (Technician_ID));

CREATE TABLE SampleType (
  type_ID   number(10) GENERATED ALWAYS AS IDENTITY, 
  type_name varchar2(50) NOT NULL UNIQUE, 
  PRIMARY KEY (type_ID));

CREATE TABLE Origin (
  origin_ID   number(10) GENERATED ALWAYS AS IDENTITY, 
  origin_name number(10) NOT NULL, 
  PRIMARY KEY (origin_ID));

CREATE TABLE Application (
  App_id   number(10) GENERATED ALWAYS AS IDENTITY, 
  App_Name varchar2(50) NOT NULL UNIQUE, 
  PRIMARY KEY (App_id));

CREATE TABLE BusinessUnit (
  BusinessUnit_ID   number(10) GENERATED ALWAYS AS IDENTITY, 
  BusinessUnit_Name varchar2(50) NOT NULL UNIQUE, 
  PRIMARY KEY (BusinessUnit_ID));

CREATE TABLE Unit (
  unit_id   number(3) GENERATED ALWAYS AS IDENTITY, 
  Unit_name varchar2(50) NOT NULL UNIQUE, 
  PRIMARY KEY (unit_id));
  
CREATE TABLE YeastStrain (
  Strain_ID    number(10) GENERATED ALWAYS AS IDENTITY, 
  Strain_name varchar2(50), 
  PRIMARY KEY (Strain_ID));
  
CREATE TABLE Test (
  test_id   number(3) GENERATED ALWAYS AS IDENTITY, 
  test_name varchar2(40) NOT NULL UNIQUE, 
  unit_id   number(3) NOT NULL, 
  PRIMARY KEY (test_id),
  CONSTRAINT ck_Test CHECK (test_name IN ('dry weight', 'protein', 'phosphate', 'viability', 'wild yeast', 'bacteria')),
  CONSTRAINT Test_Unit_FK FOREIGN KEY (unit_id) REFERENCES Unit (unit_id));

CREATE TABLE Sample (
  Sample_ID       number(10) NOT NULL, 
  Requestor_ID    number(10) NOT NULL, 
  Technician_ID   number(10) NOT NULL,
  type_ID         number(10) NOT NULL, 
  Strain_ID       number(10) NOT NULL, 
  test_id         number(10) NOT NULL, 
  App_id          number(10) NOT NULL, 
  BusinessUnit_id number(10) NOT NULL, 
  origin_id       number(10) NOT NULL, 
  Product_details varchar2(255), 
  ReceivedOn      date NOT NULL, 
  ExpectedOn      date, 
  ApprovedOn      date NOT NULL, 
  PRIMARY KEY (Sample_ID),
  CONSTRAINT Sample_Requestor_FK FOREIGN KEY (Requestor_ID) REFERENCES Requestor (Requestor_ID),
  CONSTRAINT Sample_Technician_FK FOREIGN KEY (Technician_ID) REFERENCES Technician (Technician_ID),
  CONSTRAINT Sample_SampleType_FK FOREIGN KEY (type_ID) REFERENCES SampleType (type_ID),
  CONSTRAINT Sample_YeastStrain_FK FOREIGN KEY (Strain_ID) REFERENCES YeastStrain (Strain_ID),
  CONSTRAINT Sample_Application_FK FOREIGN KEY (App_id) REFERENCES Application (App_id),
  CONSTRAINT Sample_Origin_FK FOREIGN KEY (origin_id) REFERENCES Origin (origin_ID),
  CONSTRAINT Sample_BusinessUnit_FK FOREIGN KEY (BusinessUnit_id) REFERENCES BusinessUnit (BusinessUnit_ID));

CREATE TABLE Result (
  Result_ID    number(10) GENERATED ALWAYS AS IDENTITY, 
  Sample_id    number(10) NOT NULL, 
  test_id      number(3) NOT NULL, 
  Expected_Min number(19, 2), 
  Expected_max number(19, 2), 
  Value        number(19, 2), 
  PRIMARY KEY (Result_ID),
  CONSTRAINT Result_Sample_FK FOREIGN KEY (Sample_id) REFERENCES Sample (Sample_ID),
  CONSTRAINT Result_Test_FK FOREIGN KEY (test_id) REFERENCES Test (test_id));

--ALTER TABLE Sample ADD CONSTRAINT Sample_Requestor_FK FOREIGN KEY (Requestor_ID) REFERENCES Requestor (Requestor_ID);
--ALTER TABLE Sample ADD CONSTRAINT Sample_Technician_FK FOREIGN KEY (Technician_ID) REFERENCES Technician (Technicien_ID);
--ALTER TABLE Sample ADD CONSTRAINT Sample_SampleType_FK FOREIGN KEY (type_ID) REFERENCES SampleType (type_ID);
--ALTER TABLE Sample ADD CONSTRAINT Sample_YeastStrain_FK FOREIGN KEY (Stain_ID) REFERENCES YeastStrain (Stain_ID);
--ALTER TABLE Test ADD CONSTRAINT Test_Unit_FK FOREIGN KEY (unit_id) REFERENCES Unit (unit_id);
--ALTER TABLE Sample ADD CONSTRAINT Sample_Application_FK FOREIGN KEY (App_id) REFERENCES Application (App_id);
--ALTER TABLE Result ADD CONSTRAINT Result_Sample_FK FOREIGN KEY (Sample_id) REFERENCES Sample (Sample_ID);
--ALTER TABLE Result ADD CONSTRAINT Result_Test_FK FOREIGN KEY (test_id) REFERENCES Test (test_id);
--ALTER TABLE Sample ADD CONSTRAINT Sample_Origin_FK FOREIGN KEY (origin_id) REFERENCES Origin (origin_ID);
--ALTER TABLE Sample ADD CONSTRAINT Sample_BusinessUnit_FK FOREIGN KEY (BusinessUnit_id) REFERENCES BusinessUnit (BusinessUnit_ID);



CREATE SEQUENCE seq_Sample NOCACHE;

SET TERMOUT ON
SET ECHO ON
