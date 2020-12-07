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