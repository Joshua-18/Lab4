-- Joshua Membreno

--#1
CREATE OR REPLACE PROCEDURE CUST_ORDER
(p_lowid    IN purchase_order.cust_id%TYPE,
 p_highid   IN purchase_order.cust_id%TYPE)
AS
cursor cur_order IS
 SELECT DISTINCT cust_id
 FROM purchase_order
 ORDER BY cust_id;
 
 has_order VARCHAR2(1) := 'N';
BEGIN
  IF p_lowid >= p_highid THEN
    DBMS_OUTPUT.PUT_LINE('FIRST VALUE CANNOT BE LESS THAN THE SECOND.');
  ELSE
    FOR i IN p_lowid..p_highid LOOP
        FOR rec_pur IN cur_order LOOP
            IF rec_pur.cust_id = i THEN
              DBMS_OUTPUT.PUT_LINE(rec_pur.cust_id||' has a purchase order');
              has_order := 'Y';
            END IF;
        END LOOP;
        IF has_order = 'N' THEN
            DBMS_OUTPUT.PUT_LINE(i||' does not have a purchase order.');
        END IF;
        has_order := 'N';
    END LOOP;
  END IF;  
END CUST_ORDER;
/
BEGIN
CUST_ORDER(90001, 90008);
CUST_ORDER(90003, 90007);
CUST_ORDER(90009, 90010);
CUST_ORDER(90005, 90004);
END;
/
--#2 do second bullet
--CREATE TABLE t_patTrt(
--t_patient   NUMBER(4),
--t_treatment VARCHAR2(5),
--t_phys_id   NUMBER(3),
--t_phys_name VARCHAR2(20),
--t_phys_spec VARCHAR2(20));
--/

--#4

DROP TABLE Treatment;
DROP TABLE Procedure;
DROP TABLE Physician;
DROP TABLE Patient;
/
CREATE TABLE Patient(
  Pat_Nbr NUMBER (4) PRIMARY KEY,
  Pat_Name VARCHAR2(20),
  Pat_Address VARCHAR2(20),
  Pat_City VARCHAR2(10),
  Pat_State VARCHAR2(2),
  Pat_ZIP NUMBER(5),
  Pat_Room NUMBER(3),
  Pat_Bed NUMBER(1)); 
/
CREATE TABLE Physician(
  Phys_ID NUMBER(3) PRIMARY KEY,
  Phys_Name VARCHAR2(20),
  Phys_Phone VARCHAR(12),
  Phys_Specialty VARCHAR2(20));
/  
CREATE TABLE Procedure(
  Pro_Nbr	VARCHAR2(5) PRIMARY KEY,
  Pro_Desc VARCHAR2(15),
  Pro_Charge NUMBER(5, 2));
/
CREATE TABLE Treatment(
  Pat_Nbr	NUMBER(4) REFERENCES Patient(Pat_Nbr),
  Phys_ID	NUMBER(3) REFERENCES Physician(Phys_ID),
  Trt_Procedure VARCHAR2(5) REFERENCES Procedure(Pro_Nbr),
  Trt_Date DATE,
  PRIMARY KEY(Pat_Nbr, Trt_Date));
/
insert into Patient
  values(1379, 'Cribbs, John', '2110 Main St.', 'Austin', 'TX',
         78711, 101, 1);
insert into Patient
  values(3249, 'Baker, Mary', '3547 W. 42nd St.', 'Berkeley', 'CA',
         94117, 137, 2);
insert into Patient
  values(4500, 'Garcia, Juan', '1533 Telegraph', 'Berkeley', 'CA',
         94117, 228, 2);
insert into Patient
  values(5116, 'Harris, Carol', '4710 Ave. E', 'Austin', 'TX',
         78705, 438, 1);
insert into Patient
  values(5872, 'Zimmer, Elka', '7988 Cedar', 'Cleveland', 'OH', 
         44060, 137, 1);
insert into Patient
  values(6213, 'Rose, David', '322 Bridge Ave.', 'Redwood', 'CA',
         94065, 100, 1);
insert into Patient
  values(7459, 'Smith, Chris', '788 Cummings', 'Cleveland', 'OH',
         44066, 438, 3);
insert into Patient
  values(8031, 'Fitch, Sylvia', '3380 Fox Ave.', 'Madison', 'WI',
         53711, 420, 4);
insert into Patient
  values(8659, 'Hernandez, Juan', '8300 Geneva Dr.', 'Austin', 'TX',
         78723, 350, 2);	
/
insert into Physician
  values(101, 'Wilcox, Chris', '512-329-1848', 'Eyes, Ears, Throat');
insert into Physician
  values(102, 'Nusca, Jane', '512-516-3947', 'Cardiovascular');
insert into Physician
  values(103,	'Gomez, Juan', '512-382-4987', 'Orthopedics');
insert into Physician
  values(104,	'Li, Jan', '512-516-3948', 'Cardiovascular');
insert into Physician
  values(105,	'Simmons, Alex', '512-442-5700', 'Hemotology');
/
insert into Procedure
  values('13-08', 'Throat culture', 15.00);
insert into Procedure
  values('27-45', 'X-Ray', 62.00);
insert into Procedure
  values('52-14', 'Cardiogram', 135.00);
insert into Procedure
  values('60-00', 'Blood Analysis', 58.00);
insert into Procedure
  values('88-20', 'MRI', 800.00);
/
insert into Treatment
  values(3249, 101, '13-08', '12-FEB-1999');
insert into Treatment
  values(1379, 103, '27-45', '25-MAR-1999');
insert into Treatment
  values(3249, 103, '88-20', '22-JAN-1999');
insert into Treatment
  values(5116, 104, '52-14', '03-APR-1999');
insert into Treatment
  values(4500, 101, '13-08', '04-FEB-1999');
insert into Treatment
  values(8031, 102, '52-14', '15-MAR-2000');
insert into Treatment
  values(5116, 104, '52-14', '05-FEB-2001');
insert into Treatment
  values(5872, 105, '60-00', '13-FEB-2000');
insert into Treatment
  values(3249, 103, '88-20', '24-JAN-2000');
insert into Treatment
  values(8659, 104, '60-00', '08-APR-2001');
/
SELECT *
FROM Patient;
SELECT *
FROM Physician;
SELECT *
FROM Procedure;
SELECT *
FROM Treatment;
/
--#5
CREATE OR REPLACE TRIGGER treatment_updt
  BEFORE INSERT OR UPDATE OF trt_date
  ON Treatment
  FOR EACH ROW

DECLARE
date_ck DATE := add_months(SYSDATE, -3);

BEGIN
    If :new.trt_date > SYSDATE OR
       :new.trt_date < date_ck THEN
        raise_application_error(-20100, 'Invalid treatment date');
    END IF;
END;
/
INSERT INTO Treatment
        VALUES(4500,102,'13-08','07-DEC-20');
INSERT INTO Treatment
        VALUES(4500,103,'13-08','01-JUN-20');
SELECT *
FROM Treatment
WHERE pat_nbr = 4500;
/