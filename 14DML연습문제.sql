SELECT * FROM DEPTS;

--모든 문제는 변경한 후 select문으로 조회로 확인한 후 commit합니다
--문제 1.
--DEPTS테이블의 다음을 추가하세요
SELECT * FROM DEPTS;
INSERT INTO DEPTS VALUES(280,'개발',NULL, 1800); 
INSERT INTO DEPTS VALUES (290,'회계부',NULL, 1800);
INSERT INTO DEPTS VALUES(300, '재정', 301,1800);
INSERT INTO DEPTS VALUES(310, '인사', 302,1800);
INSERT INTO DEPTS VALUES (320, '영업', 303,1700);

COMMIT;
                         
--문제 2.
--DEPTS테이블의 데이터를 수정합니다

SELECT * FROM DEPTS;
--1. department_name 이 IT Support 인 데이터의 department_name을 IT bank로 변경
UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT bank'
WHERE DEPARTMENT_ID = 210;
COMMIT;
--2. department_id가 290인 데이터의 manager_id를 301로 변경
UPDATE DEPTS
SET MANAGER_ID = 301
WHERE DEPARTMENT_ID = 290;
COMMIT;
--3. department_name이 IT Helpdesk인 데이터의 부서명을 IT Help로 , 매니저아이디를 303으로, 지역아이디를
--1800으로 변경하세요

UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT Help',
    MANAGER_ID =303,
    LOCATION_ID = 1800
WHERE DEPARTMENT_ID = 230;
COMMIT;
--4. 개발, 재정, 인사, 영업 의 매니저아이디를 301로 한번에 변경하세요.
SELECT * FROM DEPTS;

UPDATE DEPTS 
SET MANAGER_ID = 301
WHERE DEPARTMENT_NAME IN ('개발','회계부','재정','인사','영업'); 
COMMIT;
 
--문제 3.
--삭제의 조건은 항상 primary key로 합니다, 여기서 primary key는 department_id라고 가정합니다.
--1. 부서명 영업부를 삭제 하세요
--2. 부서명 NOC를 삭제하세요

SELECT * FROM DEPTS;
--데이터 불러와서 확인 후, DELETE 진행하는 습관!
SELECT * FROM DEPTS WHERE DEPARTMENT_NAME = '영업';

DELETE DEPTS WHERE DEPARTMENT_ID = 320;
DELETE DEPTS WHERE DEPARTMENT_ID = 220;
COMMIT;

--문제4
--1. Depts 사본테이블에서 department_id 가 200보다 큰 데이터를 삭제하세요.
SELECT * FROM DEPTS;

DELETE DEPTS WHERE DEPARTMENT_ID > 200;
COMMIT;
--2. Depts 사본테이블의 manager_id가 null이 아닌 데이터의 manager_id를 전부 100으로 변경하세요.
UPDATE DEPTS
SET MANAGER_ID = 100
WHERE MANAGER_ID IS NOT NULL;
COMMIT;

--4. Departments테이블은 매번 수정이 일어나는 테이블이라고 가정하고 Depts와 비교하여
--일치하는 경우 Depts의 부서명, 매니저ID, 지역ID를 업데이트 하고
--새로유입된 데이터는 그대로 추가해주는 merge문을 작성하세요.

SELECT * FROM DEPTS;
SELECT * FROM DEPARTMENTS;

MERGE INTO DEPTS D1
USING (SELECT * FROM DEPARTMENTS) D
ON (D.DEPARTMENT_ID = D1.DEPARTMENT_ID)   
WHEN MATCHED THEN
UPDATE
SET D1.DEPARTMENT_NAME = D.DEPARTMENT_NAME, 
    D1.MANAGER_ID = D.MANAGER_ID,
    D1.LOCATION_ID = D.LOCATION_ID
WHEN NOT MATCHED THEN
INSERT VALUES (D.DEPARTMENT_ID,
               D.DEPARTMENT_NAME,
                D.MANAGER_ID,
                D.LOCATION_ID);
SELECT * FROM DEPARTMENTS;
COMMIT;

--문제 5
--1. jobs_it 사본 테이블을 생성하세요 (조건은 min_salary가 6000보다 큰 데이터만 복사합니다)

SELECT * FROM JOBS;
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY > 6000);

SELECT * FROM JOBS_IT;

--2. jobs_it 테이블에 다음 데이터를 추가하세요
SELECT * FROM JOBS_IT;
INSERT INTO JOBS_IT (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) 
             VALUES ('IT_DEV','아이티개발팀',6000,20000);
INSERT INTO JOBS_IT (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) 
             VALUES ('NET_DEV','네트워크개발팀',5000,20000);
INSERT INTO JOBS_IT (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) 
             VALUES ('SEC_DEV','보안개발팀',6000,19000);
             
COMMIT;            

--3. jobs_it은 타겟 테이블 입니다
--4. jobs테이블은 매번 수정이 일어나는 테이블이라고 가정하고 jobs_it과 비교하여
--min_salary컬럼이 0보다 큰 경우 기존의 데이터는 min_salary, max_salary를 업데이트 하고 새로 유입된
--데이터는 그대로 추가해주는 merge문을 작성하세요

SELECT * FROM JOBS;

MERGE INTO JOBS_IT J 
USING (SELECT * FROM JOBS WHERE MIN_SALARY > 0) J1
ON (J.JOB_ID = J1.JOB_ID)
WHEN MATCHED THEN
UPDATE SET J.MIN_SALARY = J1.MIN_SALARY,
           J.MAX_SALARY = J1.MAX_SALARY
WHEN NOT MATCHED THEN
INSERT VALUES (J1.JOB_ID,
               J1.JOB_TITLE,
               J1.MIN_SALARY,
               J1.MAX_SALARY);
COMMIT;

SELECT * FROM JOBS_IT;
