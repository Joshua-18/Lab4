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
-- problem 4 needs to be done before moving to problems 2 and 3
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
COMMIT;
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
COMMIT;
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
COMMIT;
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
COMMIT;
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
--#2
-- t_patTrt table
DROP TABLE t_patTrt;
CREATE TABLE t_patTrt(
patnbr NUMBER(4),
phys_proc VARCHAR2(5),
physid NUMBER(3),
phys_name VARCHAR2(20),
phys_spec VARCHAR2(20));
/
-- package specification
CREATE OR REPLACE PACKAGE Hospital IS
  TYPE type_tbl IS record(
    rv_pat       Treatment.Pat_Nbr%TYPE,
    rv_treat     Treatment.Trt_Procedure%TYPE,
    rv_physid    Treatment.Phys_ID%TYPE,
    rv_phys_name Physician.Phys_Name%TYPE,
    rv_phys_sp   Physician.Phys_Specialty%TYPE);
  TYPE type_t_patTrt IS TABLE OF type_tbl
    INDEX BY binary_integer;
    PROCEDURE BuildPatTbl
        (p_rows IN OUT NUMBER);
    FUNCTION FindPatient
        (f_name IN patient.pat_name%TYPE)
     RETURN boolean;
    FUNCTION FindPatient
        (f_numbr IN patient.pat_nbr%TYPE)
     RETURN boolean;
    PROCEDURE NewPhys
    (p_id     IN physician.Phys_ID%TYPE,
     p_name   IN physician.Phys_Name%TYPE,
     p_phone  IN physician.Phys_Phone%TYPE,
     p_spec   IN physician.Phys_Specialty%TYPE);
END Hospital;
/
--package body
CREATE OR REPLACE PACKAGE BODY Hospital 
IS  
PROCEDURE BuildPatTbl
  (p_rows IN OUT NUMBER)
 IS  
  cursor cur_table IS 
    SELECT tr.Pat_Nbr, tr.Trt_Procedure, Phys_ID,
                    py.Phys_Name, py.Phys_Specialty
     FROM Treatment tr JOIN  Physician py USING (Phys_ID);
  
 BEGIN
  p_rows := 0;
  FOR rec_table IN cur_table LOOP
   INSERT INTO t_patTrt
     values (rec_table.Pat_Nbr, rec_table.Trt_Procedure, rec_table.Phys_ID,
             rec_table.Phys_Name, rec_table.Phys_Specialty);
   p_rows := p_rows + 1;
  END LOOP;
  
END BuildPatTbl;

-- overloaded functions
FUNCTION FindPatient
  (f_name IN patient.pat_name%TYPE)
  RETURN boolean
  IS
 pat_found boolean := FALSE;
 cursor cur_table IS
  SELECT Pat_Name 
  FROM patient;
  
BEGIN
  FOR rec_table IN cur_table LOOP
    IF f_name = rec_table.Pat_Name THEN
      pat_found := TRUE;
    END IF;
  END LOOP;
  RETURN pat_found;
END FindPatient; 
--OVERLOADED 
FUNCTION FindPatient
  (f_numbr in patient.pat_nbr%TYPE)
  RETURN boolean
  IS
 pat_found boolean := FALSE;
 cursor cur_table IS
  SELECT Pat_Nbr 
  FROM patient;
  
BEGIN
  FOR rec_table IN cur_table LOOP
    IF f_numbr = rec_table.Pat_Nbr THEN
      pat_found := TRUE;
    END IF;
  END LOOP;
  RETURN pat_found;
END FindPatient;

PROCEDURE NewPhys
    (p_id     IN physician.Phys_ID%TYPE,
     p_name   IN physician.Phys_Name%TYPE,
     p_phone  IN physician.Phys_Phone%TYPE,
     p_spec   IN physician.Phys_Specialty%TYPE)
  IS
   cursor cur_table IS
     SELECT Phys_ID FROM Physician;
  e_DupPhysFound EXCEPTION;
    
BEGIN
    FOR rec_table IN cur_table LOOP
   IF p_id = rec_table.phys_id THEN
    RAISE e_DupPhysFound;
   END IF;
  END LOOP;
  INSERT INTO Physician
    VALUES(p_id, p_name, p_phone, p_spec);

  EXCEPTION
   WHEN e_DupPhysFound THEN
    dbms_output.put_line('Physician already exists.');

 End NewPhys;
END Hospital;
/
--#3
DECLARE
 pat_found boolean; 
 
BEGIN

 pat_found := Hospital.FindPatient(1379);
 dbms_output.put('Patient id: 1379 was ');
 IF pat_found = TRUE THEN
   dbms_output.put_line('found!');
 ELSE
   dbms_output.put_line('not found!');
 END IF;
 
 pat_found := Hospital.FindPatient('Smith, Chris');
 dbms_output.put('Patient Name: Smith, Chris was ');
 IF pat_found = TRUE THEN
   dbms_output.put_line('found!');
 ELSE
   dbms_output.put_line('not found!');
 END IF;
 
 pat_found := Hospital.FindPatient(0000);
 dbms_output.put('Patient id: 0000 was ');
 IF pat_found = TRUE THEN
   dbms_output.put_line('found!');
 ELSE
   dbms_output.put_line('not found!');
 END IF;
END;
/
BEGIN
    Hospital.NewPhys(106, 'Membreno, Joshua','512-123-4567','the good doctor');
    Hospital.NewPhys(102,'Nusca, Jane','512-516-3947','Cardiovascular');
END;
/
SELECT * 
FROM Physician 
WHERE Phys_ID = 106;
/
DECLARE
 rows_processed NUMBER(3);
BEGIN
 Hospital.BuildPatTbl(rows_processed);
END;
/
SELECT * 
FROM t_patTrt;
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
--#6
DROP TABLE Trt_Stats;
CREATE TABLE Trt_Stats(
Trt_Procedure VARCHAR2(5), 
Trt_INS_Count NUMBER(3),
Trt_DEL_Count NUMBER(3),
Trt_UPD_Count NUMBER(3));
DESCRIBE Trt_Stats
/
CREATE OR REPLACE TRIGGER trig_Stats
	BEFORE INSERT OR UPDATE OR DELETE ON Treatment
	FOR EACH ROW
BEGIN
IF INSERTING THEN
	UPDATE trt_Stats
	SET Trt_INS_Count = Trt_INS_Count + 1
	WHERE :OLD.Trt_Procedure = :NEW.Trt_Procedure;
        IF SQL%NOTFOUND THEN
		INSERT INTO trt_Stats (Trt_Procedure, Trt_INS_Count)
		VALUES (:NEW.Trt_Procedure, 1);
	END IF;
END IF;
  IF UPDATING THEN
	UPDATE trt_Stats
	SET Trt_UPD_Count = Trt_UPD_Count + 1
	WHERE :OLD.Trt_Procedure = :NEW.Trt_Procedure;
        IF SQL%NOTFOUND THEN
		INSERT INTO trt_Stats (Trt_Procedure, Trt_UPD_Count)
		VALUES (:NEW.Trt_Procedure, 1);	
	END IF;
  END IF;
IF DELETING THEN
	UPDATE trt_Stats
	SET Trt_DEL_Count = Trt_DEL_Count + 1
	WHERE Trt_Procedure = :OLD.Trt_Procedure;
        IF SQL%NOTFOUND THEN
	  INSERT INTO trt_Stats (Trt_Procedure, Trt_DEL_Count)
	  VALUES (:OLD.Trt_Procedure, 1);
	END IF;
  END IF;
END trig_Stats;
/
INSERT INTO Treatment
        VALUES(1379,104,'60-00','17-NOV-20');
INSERT INTO Treatment
        VALUES(1379,101,'27-45','12-SEP-20');
INSERT INTO Treatment
        VALUES(1379,103,'13-08','06-NOV-20');

DELETE FROM Treatment WHERE pat_nbr = 1379 
    AND phys_id = 104 AND trt_procedure = '60-00' AND trt_date = '17-NOV-20';
DELETE FROM Treatment WHERE pat_nbr = 5872 
    AND phys_id = 105 AND trt_procedure = '60-00' ;
DELETE FROM treatment WHERE pat_nbr = 5116 and 
        phys_id = '104' and trt_procedure = '52-14';

UPDATE Treatment
SET trt_procedure = '52-14'
WHERE pat_nbr = 1379 AND phys_id = '101' AND trt_procedure = '27-45';
DELETE FROM Treatment WHERE pat_nbr = 1379 
    AND phys_id = 101 AND trt_procedure = '52-14' ;
COMMIT;
/
SELECT *
FROM Trt_Stats;
/