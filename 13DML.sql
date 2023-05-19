--INSERT, UPDATE, DELETE 문을 작성하면 COMMIT명령으로 실제 반영을 처리하는 작업이 필요합니다.
--INSERT

--테이블 구조 확인
DESC DEPARTMENTS;

--행 삽입
INSERT INTO DEPARTMENTS VALUES(300, 'DEV', NULL, 1700);
INSERT INTO DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME) VALUES(310,'SYSTEM');

--원 상태로 되돌리기
SELECT * FROM DEPARTMENTS;
ROLLBACK;

--사본테이블(테이블 구조만 복사)
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2);

SELECT * FROM EMPS;
--서브쿼리절 인서트
INSERT INTO EMPS (SELECT * FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');--전체 컬럼을 맞춤
INSERT INTO EMPS (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES ( 200 , 
       (SELECT LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = 200),
       (SELECT EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = 200 ), 
        SYSDATE,
        'TEST'
        ); 

---------------------------------------------------------------
--UPDATE문장
SELECT  * FROM EMPS;
--EX1
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 103;
UPDATE EMPS
SET HIRE_DATE = SYSDATE, 
    LAST_NAME = 'HONG',
    SALARY = SALARY + 1000
WHERE EMPLOYEE_ID = 103;
--EX2
UPDATE EMPS
SET COMMISSION_PCT = 0.1
WHERE JOB_ID IN ('IT_PROG', 'SA_MAN');
--EX3 : ID- 200의 급여를 103번과 동일하게 변경 (서브쿼리)
UPDATE EMPS
SET SALARY = (SELECT SALARY FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID = 200;

UPDATE EMPS
SET COMMISSION_PCT = (SELECT COMMISSION_PCT * 5 FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID = 200;

SELECT * FROM EMPS;
--EX4 : 3개의 컬럼을 한번에 변경
UPDATE EMPS
SET (JOB_ID, SALARY, COMMISSION_PCT) = (SELECT JOB_ID, SALARY, COMMISSION_PCT FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID = 200;
--저장
COMMIT;
----------------------------------------------------------------

--DELETE 구문 : 키를 이용하여 지우는 것이 안전하다
CREATE TABLE DEPTS AS ( SELECT * FROM DEPARTMENTS WHERE 1 = 1 ); --테이블 복사 + 데이터 복사

SELECT * FROM DEPTS;
SELECT * FROM EMPS;
--EX1 삭제할때는 1)번 처럼 꼭 PK를 이용합니다.
DELETE FROM EMPS WHERE EMPLOYEE_ID = 200;
DELETE FROM EMPS WHERE SALARY >= 4000; --위험
ROLLBACK;
--EX2
DELETE FROM EMPS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'IT');--위험
ROLLBACK;
--
SELECT * FROM DEPARTMENTS;

DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 60;

--MERGER문
--두 테이블을 비교해서 데이터가 있으면 UPDATE, 없다면 INSERT (일치하면 DELETE도 가능)
SELECT * FROM EMPS;
SELECT * FROM EMPLOYEES;
MERGE INTO EMPS E1
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('IT_PROG', 'SA_MAN')) E2
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID)
WHEN MATCHED THEN
     UPDATE SET E1.HIRE_DATE = E2.HIRE_DATE,
                E1.SALARY = E2.SALARY,
                E1.COMMISSION_PCT = E2.COMMISSION_PCT
WHEN NOT MATCHED THEN
--순서와 갯수도 일치해야한다!
     INSERT VALUES (E2.EMPLOYEE_ID,
                    E2.FIRST_NAME,
                    E2.LAST_NAME,
                    E2.EMAIL,
                    E2.PHONE_NUMBER,
                    E2.HIRE_DATE,
                    E2.JOB_ID,
                    E2.SALARY,
                    E2.COMMISSION_PCT,
                    E2.MANAGER_ID,
                    E2.DEPARTMENT_ID);

--MERGE2
SELECT * FROM EMPS;

MERGE INTO EMPS E
USING DUAL
ON(E.EMPLOYEE_ID = 103)
WHEN MATCHED THEN
    UPDATE SET LAST_NAME = 'DEMO'

WHEN NOT MATCHED THEN
    INSERT(EMPLOYEE_ID,
           LAST_NAME,
           EMAIL,
           HIRE_DATE,
           JOB_ID) VALUES(1000, 'DEMO', 'DEMO', SYSDATE, 'DEMO');
    
SELECT * FROM EMPS;

DELETE FROM EMPS WHERE EMPLOYEE_ID = 103;

------------------------------------------------------------------------

