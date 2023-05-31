SELECT * FROM DEPTS;

--��� ������ ������ �� select������ ��ȸ�� Ȯ���� �� commit�մϴ�
--���� 1.
--DEPTS���̺��� ������ �߰��ϼ���
SELECT * FROM DEPTS;
INSERT INTO DEPTS VALUES(280,'����',NULL, 1800); 
INSERT INTO DEPTS VALUES (290,'ȸ���',NULL, 1800);
INSERT INTO DEPTS VALUES(300, '����', 301,1800);
INSERT INTO DEPTS VALUES(310, '�λ�', 302,1800);
INSERT INTO DEPTS VALUES (320, '����', 303,1700);

COMMIT;
                         
--���� 2.
--DEPTS���̺��� �����͸� �����մϴ�

SELECT * FROM DEPTS;
--1. department_name �� IT Support �� �������� department_name�� IT bank�� ����
UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT bank'
WHERE DEPARTMENT_ID = 210;
COMMIT;
--2. department_id�� 290�� �������� manager_id�� 301�� ����
UPDATE DEPTS
SET MANAGER_ID = 301
WHERE DEPARTMENT_ID = 290;
COMMIT;
--3. department_name�� IT Helpdesk�� �������� �μ����� IT Help�� , �Ŵ������̵� 303����, �������̵�
--1800���� �����ϼ���

UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT Help',
    MANAGER_ID =303,
    LOCATION_ID = 1800
WHERE DEPARTMENT_ID = 230;
COMMIT;
--4. ����, ����, �λ�, ���� �� �Ŵ������̵� 301�� �ѹ��� �����ϼ���.
SELECT * FROM DEPTS;

UPDATE DEPTS 
SET MANAGER_ID = 301
WHERE DEPARTMENT_NAME IN ('����','ȸ���','����','�λ�','����'); 
COMMIT;
 
--���� 3.
--������ ������ �׻� primary key�� �մϴ�, ���⼭ primary key�� department_id��� �����մϴ�.
--1. �μ��� �����θ� ���� �ϼ���
--2. �μ��� NOC�� �����ϼ���

SELECT * FROM DEPTS;
--������ �ҷ��ͼ� Ȯ�� ��, DELETE �����ϴ� ����!
SELECT * FROM DEPTS WHERE DEPARTMENT_NAME = '����';

DELETE DEPTS WHERE DEPARTMENT_ID = 320;
DELETE DEPTS WHERE DEPARTMENT_ID = 220;
COMMIT;

--����4
--1. Depts �纻���̺��� department_id �� 200���� ū �����͸� �����ϼ���.
SELECT * FROM DEPTS;

DELETE DEPTS WHERE DEPARTMENT_ID > 200;
COMMIT;
--2. Depts �纻���̺��� manager_id�� null�� �ƴ� �������� manager_id�� ���� 100���� �����ϼ���.
UPDATE DEPTS
SET MANAGER_ID = 100
WHERE MANAGER_ID IS NOT NULL;
COMMIT;

--4. Departments���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� Depts�� ���Ͽ�
--��ġ�ϴ� ��� Depts�� �μ���, �Ŵ���ID, ����ID�� ������Ʈ �ϰ�
--�������Ե� �����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���.

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

--���� 5
--1. jobs_it �纻 ���̺��� �����ϼ��� (������ min_salary�� 6000���� ū �����͸� �����մϴ�)

SELECT * FROM JOBS;
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY > 6000);

SELECT * FROM JOBS_IT;

--2. jobs_it ���̺� ���� �����͸� �߰��ϼ���
SELECT * FROM JOBS_IT;
INSERT INTO JOBS_IT (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) 
             VALUES ('IT_DEV','����Ƽ������',6000,20000);
INSERT INTO JOBS_IT (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) 
             VALUES ('NET_DEV','��Ʈ��ũ������',5000,20000);
INSERT INTO JOBS_IT (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) 
             VALUES ('SEC_DEV','���Ȱ�����',6000,19000);
             
COMMIT;            

--3. jobs_it�� Ÿ�� ���̺� �Դϴ�
--4. jobs���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� jobs_it�� ���Ͽ�
--min_salary�÷��� 0���� ū ��� ������ �����ʹ� min_salary, max_salary�� ������Ʈ �ϰ� ���� ���Ե�
--�����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���

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
