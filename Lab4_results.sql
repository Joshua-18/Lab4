SQL> @ C:\Users\Joshua\Documents\itse1345\competency_4\Lab4\Lab4\Lab4.sql
SQL> -- Joshua Membreno
SQL> 
SQL> --#1
SQL> CREATE OR REPLACE PROCEDURE CUST_ORDER
  2  (p_lowid    IN purchase_order.cust_id%TYPE,
  3   p_highid   IN purchase_order.cust_id%TYPE)
  4  AS
  5  cursor cur_order IS
  6   SELECT DISTINCT cust_id
  7   FROM purchase_order
  8   ORDER BY cust_id;
  9  
 10   has_order VARCHAR2(1) := 'N';
 11  BEGIN
 12    IF p_lowid >= p_highid THEN
 13      DBMS_OUTPUT.PUT_LINE('FIRST VALUE CANNOT BE LESS THAN THE SECOND.');
 14    ELSE
 15      FOR i IN p_lowid..p_highid LOOP
 16          FOR rec_pur IN cur_order LOOP
 17              IF rec_pur.cust_id = i THEN
 18                DBMS_OUTPUT.PUT_LINE(rec_pur.cust_id||' has a purchase order');
 19                has_order := 'Y';
 20              END IF;
 21          END LOOP;
 22          IF has_order = 'N' THEN
 23              DBMS_OUTPUT.PUT_LINE(i||' does not have a purchase order.');
 24          END IF;
 25          has_order := 'N';
 26      END LOOP;
 27    END IF;  
 28  END CUST_ORDER;
 29  /

Procedure CUST_ORDER compiled

SQL> BEGIN
  2  CUST_ORDER(90001, 90008);
  3  CUST_ORDER(90003, 90007);
  4  CUST_ORDER(90009, 90010);
  5  CUST_ORDER(90005, 90004);
  6  END;
  7  /
90001 has a purchase order
90002 does not have a purchase order.
90003 does not have a purchase order.
90004 has a purchase order
90005 has a purchase order
90006 does not have a purchase order.
90007 has a purchase order
90008 has a purchase order
90003 does not have a purchase order.
90004 has a purchase order
90005 has a purchase order
90006 does not have a purchase order.
90007 has a purchase order
90009 does not have a purchase order.
90010 does not have a purchase order.
FIRST VALUE CANNOT BE LESS THAN THE SECOND.


PL/SQL procedure successfully completed.

SQL> -- problem 4 needs to be done before moving to problems 2 and 3
SQL> --#4
SQL> DROP TABLE Treatment;

Table TREATMENT dropped.

SQL> DROP TABLE Procedure;

Table PROCEDURE dropped.

SQL> DROP TABLE Physician;

Table PHYSICIAN dropped.

SQL> DROP TABLE Patient;

Table PATIENT dropped.

SQL> /
SQL> CREATE TABLE Patient(
  2    Pat_Nbr NUMBER (4) PRIMARY KEY,
  3    Pat_Name VARCHAR2(20),
  4    Pat_Address VARCHAR2(20),
  5    Pat_City VARCHAR2(10),
  6    Pat_State VARCHAR2(2),
  7    Pat_ZIP NUMBER(5),
  8    Pat_Room NUMBER(3),
  9    Pat_Bed NUMBER(1));

Table PATIENT created.

SQL> /
SQL> CREATE TABLE Physician(
  2    Phys_ID NUMBER(3) PRIMARY KEY,
  3    Phys_Name VARCHAR2(20),
  4    Phys_Phone VARCHAR(12),
  5    Phys_Specialty VARCHAR2(20));

Table PHYSICIAN created.

SQL> /  
SQL> CREATE TABLE Procedure(
  2    Pro_Nbr	VARCHAR2(5) PRIMARY KEY,
  3    Pro_Desc VARCHAR2(15),
  4    Pro_Charge NUMBER(5, 2));

Table PROCEDURE created.

SQL> /
SQL> CREATE TABLE Treatment(
  2    Pat_Nbr	NUMBER(4) REFERENCES Patient(Pat_Nbr),
  3    Phys_ID	NUMBER(3) REFERENCES Physician(Phys_ID),
  4    Trt_Procedure VARCHAR2(5) REFERENCES Procedure(Pro_Nbr),
  5    Trt_Date DATE,
  6    PRIMARY KEY(Pat_Nbr, Trt_Date));

Table TREATMENT created.

SQL> /
SQL> insert into Patient
  2    values(1379, 'Cribbs, John', '2110 Main St.', 'Austin', 'TX',
  3           78711, 101, 1);

1 row inserted.

SQL> insert into Patient
  2    values(3249, 'Baker, Mary', '3547 W. 42nd St.', 'Berkeley', 'CA',
  3           94117, 137, 2);

1 row inserted.

SQL> insert into Patient
  2    values(4500, 'Garcia, Juan', '1533 Telegraph', 'Berkeley', 'CA',
  3           94117, 228, 2);

1 row inserted.

SQL> insert into Patient
  2    values(5116, 'Harris, Carol', '4710 Ave. E', 'Austin', 'TX',
  3           78705, 438, 1);

1 row inserted.

SQL> insert into Patient
  2    values(5872, 'Zimmer, Elka', '7988 Cedar', 'Cleveland', 'OH', 
  3           44060, 137, 1);

1 row inserted.

SQL> insert into Patient
  2    values(6213, 'Rose, David', '322 Bridge Ave.', 'Redwood', 'CA',
  3           94065, 100, 1);

1 row inserted.

SQL> insert into Patient
  2    values(7459, 'Smith, Chris', '788 Cummings', 'Cleveland', 'OH',
  3           44066, 438, 3);

1 row inserted.

SQL> insert into Patient
  2    values(8031, 'Fitch, Sylvia', '3380 Fox Ave.', 'Madison', 'WI',
  3           53711, 420, 4);

1 row inserted.

SQL> insert into Patient
  2    values(8659, 'Hernandez, Juan', '8300 Geneva Dr.', 'Austin', 'TX',
  3           78723, 350, 2);

1 row inserted.

SQL> COMMIT;

Commit complete.

SQL> /
SQL> insert into Physician
  2    values(101, 'Wilcox, Chris', '512-329-1848', 'Eyes, Ears, Throat');

1 row inserted.

SQL> insert into Physician
  2    values(102, 'Nusca, Jane', '512-516-3947', 'Cardiovascular');

1 row inserted.

SQL> insert into Physician
  2    values(103,	'Gomez, Juan', '512-382-4987', 'Orthopedics');

1 row inserted.

SQL> insert into Physician
  2    values(104,	'Li, Jan', '512-516-3948', 'Cardiovascular');

1 row inserted.

SQL> insert into Physician
  2    values(105,	'Simmons, Alex', '512-442-5700', 'Hemotology');

1 row inserted.

SQL> COMMIT;

Commit complete.

SQL> /
SQL> insert into Procedure
  2    values('13-08', 'Throat culture', 15.00);

1 row inserted.

SQL> insert into Procedure
  2    values('27-45', 'X-Ray', 62.00);

1 row inserted.

SQL> insert into Procedure
  2    values('52-14', 'Cardiogram', 135.00);

1 row inserted.

SQL> insert into Procedure
  2    values('60-00', 'Blood Analysis', 58.00);

1 row inserted.

SQL> insert into Procedure
  2    values('88-20', 'MRI', 800.00);

1 row inserted.

SQL> COMMIT;

Commit complete.

SQL> /
SQL> insert into Treatment
  2    values(3249, 101, '13-08', '12-FEB-1999');

1 row inserted.

SQL> insert into Treatment
  2    values(1379, 103, '27-45', '25-MAR-1999');

1 row inserted.

SQL> insert into Treatment
  2    values(3249, 103, '88-20', '22-JAN-1999');

1 row inserted.

SQL> insert into Treatment
  2    values(5116, 104, '52-14', '03-APR-1999');

1 row inserted.

SQL> insert into Treatment
  2    values(4500, 101, '13-08', '04-FEB-1999');

1 row inserted.

SQL> insert into Treatment
  2    values(8031, 102, '52-14', '15-MAR-2000');

1 row inserted.

SQL> insert into Treatment
  2    values(5116, 104, '52-14', '05-FEB-2001');

1 row inserted.

SQL> insert into Treatment
  2    values(5872, 105, '60-00', '13-FEB-2000');

1 row inserted.

SQL> insert into Treatment
  2    values(3249, 103, '88-20', '24-JAN-2000');

1 row inserted.

SQL> insert into Treatment
  2    values(8659, 104, '60-00', '08-APR-2001');

1 row inserted.

SQL> COMMIT;

Commit complete.

SQL> /
SQL> SELECT *
  2  FROM Patient;

   PAT_NBR PAT_NAME             PAT_ADDRESS          PAT_CITY   PA    PAT_ZIP   PAT_ROOM    PAT_BED
---------- -------------------- -------------------- ---------- -- ---------- ---------- ----------
      1379 Cribbs, John         2110 Main St.        Austin     TX      78711        101          1
      3249 Baker, Mary          3547 W. 42nd St.     Berkeley   CA      94117        137          2
      4500 Garcia, Juan         1533 Telegraph       Berkeley   CA      94117        228          2
      5116 Harris, Carol        4710 Ave. E          Austin     TX      78705        438          1
      5872 Zimmer, Elka         7988 Cedar           Cleveland  OH      44060        137          1
      6213 Rose, David          322 Bridge Ave.      Redwood    CA      94065        100          1
      7459 Smith, Chris         788 Cummings         Cleveland  OH      44066        438          3
      8031 Fitch, Sylvia        3380 Fox Ave.        Madison    WI      53711        420          4
      8659 Hernandez, Juan      8300 Geneva Dr.      Austin     TX      78723        350          2

9 rows selected. 

SQL> SELECT *
  2  FROM Physician;

   PHYS_ID PHYS_NAME            PHYS_PHONE   PHYS_SPECIALTY      
---------- -------------------- ------------ --------------------
       101 Wilcox, Chris        512-329-1848 Eyes, Ears, Throat  
       102 Nusca, Jane          512-516-3947 Cardiovascular      
       103 Gomez, Juan          512-382-4987 Orthopedics         
       104 Li, Jan              512-516-3948 Cardiovascular      
       105 Simmons, Alex        512-442-5700 Hemotology          

SQL> SELECT *
  2  FROM Procedure;

PRO_N PRO_DESC        PRO_CHARGE
----- --------------- ----------
13-08 Throat culture          15
27-45 X-Ray                   62
52-14 Cardiogram             135
60-00 Blood Analysis          58
88-20 MRI                    800

SQL> SELECT *
  2  FROM Treatment;

   PAT_NBR    PHYS_ID TRT_P TRT_DATE 
---------- ---------- ----- ---------
      3249        101 13-08 12-FEB-99
      1379        103 27-45 25-MAR-99
      3249        103 88-20 22-JAN-99
      5116        104 52-14 03-APR-99
      4500        101 13-08 04-FEB-99
      8031        102 52-14 15-MAR-00
      5116        104 52-14 05-FEB-01
      5872        105 60-00 13-FEB-00
      3249        103 88-20 24-JAN-00
      8659        104 60-00 08-APR-01

10 rows selected. 

SQL> /
SQL> --#2
SQL> -- t_patTrt table
SQL> DROP TABLE t_patTrt;

Table T_PATTRT dropped.

SQL> CREATE TABLE t_patTrt(
  2  patnbr NUMBER(4),
  3  phys_proc VARCHAR2(5),
  4  physid NUMBER(3),
  5  phys_name VARCHAR2(20),
  6  phys_spec VARCHAR2(20));

Table T_PATTRT created.

SQL> /
SQL> -- package specification
SQL> CREATE OR REPLACE PACKAGE Hospital IS
  2    TYPE type_tbl IS record(
  3      rv_pat       Treatment.Pat_Nbr%TYPE,
  4      rv_treat     Treatment.Trt_Procedure%TYPE,
  5      rv_physid    Treatment.Phys_ID%TYPE,
  6      rv_phys_name Physician.Phys_Name%TYPE,
  7      rv_phys_sp   Physician.Phys_Specialty%TYPE);
  8    TYPE type_t_patTrt IS TABLE OF type_tbl
  9      INDEX BY binary_integer;
 10      PROCEDURE BuildPatTbl
 11          (p_rows IN OUT NUMBER);
 12      FUNCTION FindPatient
 13          (f_name IN patient.pat_name%TYPE)
 14       RETURN boolean;
 15      FUNCTION FindPatient
 16          (f_numbr IN patient.pat_nbr%TYPE)
 17       RETURN boolean;
 18      PROCEDURE NewPhys
 19      (p_id     IN physician.Phys_ID%TYPE,
 20       p_name   IN physician.Phys_Name%TYPE,
 21       p_phone  IN physician.Phys_Phone%TYPE,
 22       p_spec   IN physician.Phys_Specialty%TYPE);
 23  END Hospital;
 24  /

Package HOSPITAL compiled

SQL> --package body
SQL> CREATE OR REPLACE PACKAGE BODY Hospital 
  2  IS  
  3  PROCEDURE BuildPatTbl
  4    (p_rows IN OUT NUMBER)
  5   IS  
  6    cursor cur_table IS 
  7      SELECT tr.Pat_Nbr, tr.Trt_Procedure, Phys_ID,
  8                      py.Phys_Name, py.Phys_Specialty
  9       FROM Treatment tr JOIN  Physician py USING (Phys_ID);
 10  
 11   BEGIN
 12    p_rows := 0;
 13    FOR rec_table IN cur_table LOOP
 14     INSERT INTO t_patTrt
 15       values (rec_table.Pat_Nbr, rec_table.Trt_Procedure, rec_table.Phys_ID,
 16               rec_table.Phys_Name, rec_table.Phys_Specialty);
 17     p_rows := p_rows + 1;
 18    END LOOP;
 19  
 20  END BuildPatTbl;
 21  
 22  -- overloaded functions
 23  FUNCTION FindPatient
 24    (f_name IN patient.pat_name%TYPE)
 25    RETURN boolean
 26    IS
 27   pat_found boolean := FALSE;
 28   cursor cur_table IS
 29    SELECT Pat_Name 
 30    FROM patient;
 31  
 32  BEGIN
 33    FOR rec_table IN cur_table LOOP
 34      IF f_name = rec_table.Pat_Name THEN
 35        pat_found := TRUE;
 36      END IF;
 37    END LOOP;
 38    RETURN pat_found;
 39  END FindPatient; 
 40  --OVERLOADED 
 41  FUNCTION FindPatient
 42    (f_numbr in patient.pat_nbr%TYPE)
 43    RETURN boolean
 44    IS
 45   pat_found boolean := FALSE;
 46   cursor cur_table IS
 47    SELECT Pat_Nbr 
 48    FROM patient;
 49  
 50  BEGIN
 51    FOR rec_table IN cur_table LOOP
 52      IF f_numbr = rec_table.Pat_Nbr THEN
 53        pat_found := TRUE;
 54      END IF;
 55    END LOOP;
 56    RETURN pat_found;
 57  END FindPatient;
 58  
 59  PROCEDURE NewPhys
 60      (p_id     IN physician.Phys_ID%TYPE,
 61       p_name   IN physician.Phys_Name%TYPE,
 62       p_phone  IN physician.Phys_Phone%TYPE,
 63       p_spec   IN physician.Phys_Specialty%TYPE)
 64    IS
 65     cursor cur_table IS
 66       SELECT Phys_ID FROM Physician;
 67    e_DupPhysFound EXCEPTION;
 68  
 69  BEGIN
 70      FOR rec_table IN cur_table LOOP
 71     IF p_id = rec_table.phys_id THEN
 72      RAISE e_DupPhysFound;
 73     END IF;
 74    END LOOP;
 75    INSERT INTO Physician
 76      VALUES(p_id, p_name, p_phone, p_spec);
 77  
 78    EXCEPTION
 79     WHEN e_DupPhysFound THEN
 80      dbms_output.put_line('Physician already exists.');
 81  
 82   End NewPhys;
 83  END Hospital;
 84  /

Package Body HOSPITAL compiled

SQL> --#3
SQL> DECLARE
  2   pat_found boolean; 
  3  
  4  BEGIN
  5    -- this section tests the FindPatient function
  6   pat_found := Hospital.FindPatient(1379);
  7   dbms_output.put('Patient id: 1379 was ');
  8   IF pat_found = TRUE THEN
  9     dbms_output.put_line('found!');
 10   ELSE
 11     dbms_output.put_line('not found!');
 12   END IF;
 13  
 14   pat_found := Hospital.FindPatient('Smith, Chris');
 15   dbms_output.put('Patient Name: Smith, Chris was ');
 16   IF pat_found = TRUE THEN
 17     dbms_output.put_line('found!');
 18   ELSE
 19     dbms_output.put_line('not found!');
 20   END IF;
 21  
 22   pat_found := Hospital.FindPatient(0000);
 23   dbms_output.put('Patient id: 0000 was ');
 24   IF pat_found = TRUE THEN
 25     dbms_output.put_line('found!');
 26   ELSE
 27     dbms_output.put_line('not found!');
 28   END IF;
 29  END;
 30  /
Patient id: 1379 was found!
Patient Name: Smith, Chris was found!
Patient id: 0000 was not found!


PL/SQL procedure successfully completed.

SQL> BEGIN
  2      Hospital.NewPhys(106, 'Membreno, Joshua','512-123-4567','the good doctor');
  3      Hospital.NewPhys(102,'Nusca, Jane','512-516-3947','Cardiovascular');
  4  END;
  5  /
Physician already exists.


PL/SQL procedure successfully completed.

SQL> SELECT * 
  2  FROM Physician 
  3  WHERE Phys_ID = 106;

   PHYS_ID PHYS_NAME            PHYS_PHONE   PHYS_SPECIALTY      
---------- -------------------- ------------ --------------------
       106 Membreno, Joshua     512-123-4567 the good doctor     

SQL> /
SQL> SELECT *
  2  FROM t_patTrt;
no rows selected
SQL> /
SQL> DECLARE
  2   rows_processed NUMBER(3);
  3  BEGIN
  4   Hospital.BuildPatTbl(rows_processed);
  5  END;
  6  /

PL/SQL procedure successfully completed.

SQL> SELECT * 
  2  FROM t_patTrt;

    PATNBR PHYS_     PHYSID PHYS_NAME            PHYS_SPEC           
---------- ----- ---------- -------------------- --------------------
      3249 13-08        101 Wilcox, Chris        Eyes, Ears, Throat  
      1379 27-45        103 Gomez, Juan          Orthopedics         
      3249 88-20        103 Gomez, Juan          Orthopedics         
      5116 52-14        104 Li, Jan              Cardiovascular      
      4500 13-08        101 Wilcox, Chris        Eyes, Ears, Throat  
      8031 52-14        102 Nusca, Jane          Cardiovascular      
      5116 52-14        104 Li, Jan              Cardiovascular      
      5872 60-00        105 Simmons, Alex        Hemotology          
      3249 88-20        103 Gomez, Juan          Orthopedics         
      8659 60-00        104 Li, Jan              Cardiovascular      

10 rows selected. 

SQL> /
SQL> --#5
SQL> CREATE OR REPLACE TRIGGER treatment_updt
  2    BEFORE INSERT OR UPDATE OF trt_date
  3    ON Treatment
  4    FOR EACH ROW
  5  
  6  DECLARE
  7  date_ck DATE := add_months(SYSDATE, -3);
  8  
  9  BEGIN
 10      If :new.trt_date > SYSDATE OR
 11         :new.trt_date < date_ck THEN
 12          raise_application_error(-20100, 'Invalid treatment date');
 13      END IF;
 14  END;
 15  /

Trigger TREATMENT_UPDT compiled

SQL> INSERT INTO Treatment
  2          VALUES(4500,102,'13-08','07-DEC-20');

1 row inserted.

SQL> INSERT INTO Treatment
  2          VALUES(4500,103,'13-08','01-JUN-20');

Error starting at line : 349 File @ C:\Users\Joshua\Documents\itse1345\competency_4\Lab4\Lab4\Lab4.sql
In command -
INSERT INTO Treatment
        VALUES(4500,103,'13-08','01-JUN-20')
Error report -
ORA-20100: Invalid treatment date
ORA-06512: at "ITSE1345.TREATMENT_UPDT", line 7
ORA-04088: error during execution of trigger 'ITSE1345.TREATMENT_UPDT'

SQL> SELECT *
  2  FROM Treatment
  3  WHERE pat_nbr = 4500;

   PAT_NBR    PHYS_ID TRT_P TRT_DATE 
---------- ---------- ----- ---------
      4500        101 13-08 04-FEB-99
      4500        102 13-08 07-DEC-20

SQL> /
SQL> spool off
