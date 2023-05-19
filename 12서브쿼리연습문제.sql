--���� 1.
---EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� ( AVG(�÷�) ���)
---EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
---EMPLOYEES ���̺��� job_id�� IT_PFOG�� ������� ��ձ޿����� ���� ������� �����͸� ����ϼ���

SELECT *
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);

SELECT COUNT(*)
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES);

SELECT *
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'); 

--���� 2.
---DEPARTMENTS���̺��� manager_id�� 100�� ����� department_id��
--EMPLOYEES���̺��� department_id�� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.

SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS 
                        WHERE MANAGER_ID = 100);

--���� 3.
---EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���
---EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.

SELECT * FROM EMPLOYEES;

SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID > (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME IN ('Pat')); 

SELECT *      
FROM EMPLOYEES 
WHERE MANAGER_ID IN (SELECT MANAGER_ID 
                     FROM EMPLOYEES  
                     WHERE FIRST_NAME = 'James');
      
--���� 4.
---EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���

SELECT *
FROM ( SELECT ROWNUM AS RN,
              E.* 
              FROM (SELECT * 
                    FROM EMPLOYEES 
                    ORDER BY FIRST_NAME DESC )E)
WHERE RN BETWEEN 41 AND 50;

--���� 5.
---EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ, 
--�Ի����� ����ϼ���.

SELECT * FROM EMPLOYEES;

SELECT *
FROM (SELECT A.*,
             ROWNUM AS RN
       FROM (SELECT EMPLOYEE_ID,
                    FIRST_NAME,
                    HIRE_DATE,
                    PHONE_NUMBER
                FROM EMPLOYEES 
                ORDER BY HIRE_DATE) A
       )
WHERE RN BETWEEN 31 AND 40;
       
--���� 6.
--employees���̺� departments���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����

SELECT* FROM EMPLOYEES;
SELECT* FROM DEPARTMENTS;

SELECT E.EMPLOYEE_ID AS �������̵�, 
       E.FIRST_NAME || ' ' || E.LAST_NAME AS �̸�,
       D.DEPARTMENT_ID AS �μ����̵�, 
       D.DEPARTMENT_NAME AS �μ���
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY EMPLOYEE_ID;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���

SELECT E.EMPLOYEE_ID AS �������̵�, 
       E.FIRST_NAME || ' ' ||E.LAST_NAME AS ������,
       DEPARTMENT_ID AS �μ����̵�,
      (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) AS �μ���
FROM EMPLOYEES E 
ORDER BY EMPLOYEE_ID;

--���� 8.
--departments���̺� locations���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����

SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME,
       D.MANAGER_ID,
       L.LOCATION_ID,
       L.STREET_ADDRESS,
       L.POSTAL_CODE,
       L.CITY
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY DEPARTMENT_ID;

--���� 9.
--���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���

SELECT DEPARTMENT_ID,
       DEPARTMENT_NAME, 
       MANAGER_ID,
       LOCATION_ID,
      (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID)AS ����ID,
      (SELECT POSTAL_CODE FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS �����ȣ,
      (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS ����
FROM DEPARTMENTS D
ORDER BY DEPARTMENT_ID;

--���� 10.
--locations���̺� countries ���̺��� left �����ϼ���
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����

SELECT * FROM COUNTRIES;
SELECT * FROM LOCATIONS;

SELECT L.LOCATION_ID, L.STREET_ADDRESS, L.CITY,
       C.COUNTRY_ID, C.COUNTRY_NAME
FROM LOCATIONS L
LEFT JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
ORDER BY COUNTRY_NAME;

--���� 11.
--���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
--���ΰ� ��������

SELECT L.LOCATION_ID, L.STREET_ADDRESS, L.CITY,
     (SELECT COUNTRY_ID FROM COUNTRIES C WHERE L.COUNTRY_ID = C.COUNTRY_ID)AS ����ID,
     (SELECT COUNTRY_NAME FROM COUNTRIES C WHERE L.COUNTRY_ID = C.COUNTRY_ID) AS ���ø�
FROM LOCATIONS L
ORDER BY COUNTRY_NAME;

--���� 12. 
--employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 1-10��° �����͸� ����մϴ�
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, �μ����̵�, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.
SELECT * FROM EMPLOYEES;

SELECT *
FROM (SELECT ROWNUM RN,
       A.*
FROM( SELECT E.EMPLOYEE_ID,
             E.FIRST_NAME,
             E.PHONE_NUMBER,
             E.HIRE_DATE,
             E.DEPARTMENT_ID,
             D.DEPARTMENT_NAME        
        FROM EMPLOYEES E
        LEFT JOIN DEPARTMENTS D 
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
        ORDER BY HIRE_DATE ) A
         )
WHERE RN >=1 AND RN <= 10;

--���� 13. 
----EMPLOYEES �� DEPARTMENTS ���̺��� 
---JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID, DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���
--��Ʈ:���̺�� A LEFT JOIN ���̺�� B ON~~

--���� ��
SELECT E.LAST_NAME,
       E.JOB_ID,
       D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME
FROM (SELECT *
      FROM EMPLOYEES
      WHERE JOB_ID = 'SA_MAN') E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- ���� ��
SELECT E.LAST_NAME,
       E.JOB_ID,
       D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
WHERE JOB_ID = 'SA_MAN';

--���� 14
----DEPARTMENT���̺��� �� �μ��� ID, NAME, MANAGER_ID�� �μ��� ���� �ο����� ����ϼ���.
----�ο��� ���� �������� �����ϼ���.
----����� ���� �μ��� ������� ���� �ʽ��ϴ�

SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;

--���� ��(LEFT �� �ƴ� INNER JOIN���� NULL�� �ڵ����� ��� �ȵǵ��� ��)
SELECT D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME,
       D.MANAGER_ID,
       TOTAL
FROM DEPARTMENTS D
JOIN (SELECT DEPARTMENT_ID,
            COUNT(*) AS TOTAL 
      FROM EMPLOYEES 
      GROUP BY DEPARTMENT_ID) E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
ORDER BY TOTAL DESC;

--���� ��
SELECT D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME,
       D.MANAGER_ID,
       TOTAL
FROM DEPARTMENTS D
LEFT JOIN (SELECT DEPARTMENT_ID,
                  COUNT(*) AS TOTAL 
            FROM EMPLOYEES 
            GROUP BY DEPARTMENT_ID) E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE MANAGER_ID IS NOT NULL
ORDER BY TOTAL DESC;

--���� 15
----�μ��� ���� ���� ���ο�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���
----�μ��� ����� ������ 0���� ����ϼ���

SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;
SELECT * FROM EMPLOYEES;

--���� ��
SELECT D.*,
       NVL(E.SALARY,0) AS SALARY,
       L.STREET_ADDRESS,
       L.POSTAL_CODE
FROM DEPARTMENTS D
LEFT JOIN ( SELECT DEPARTMENT_ID,
                   TRUNC(AVG(SALARY)) AS SALARY
             FROM EMPLOYEES
             GROUP BY DEPARTMENT_ID ) E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
LEFT JOIN LOCATIONS L 
ON D.LOCATION_ID = L.LOCATION_ID;             

-- ���� ��    --> JOIN���� �������� �־����...!! ���� FROM���� �־ ������ �ι� �ȵƴ��ǰ�����
SELECT D.*,
       A.*,       
       L.POSTAL_CODE,
       L.STREET_ADDRESS,
       NVL(A.�μ�����տ���,0)
FROM (SELECT DEPARTMENT_ID, 
            TRUNC(AVG(SALARY))AS �μ�����տ���                  
      FROM EMPLOYEES 
      GROUP BY DEPARTMENT_ID) A
LEFT JOIN DEPARTMENTS D 
ON A.DEPARTMENT_ID = D.DEPARTMENT_ID  
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID;
 
-- �õ��Ϸ��ߴ���..(���� ������ ���̺��� �׷�ȭ�ϰ�;��µ�.. �ȵ�) 
SELECT B.*       
FROM (SELECT A.*,            
            L.STREET_ADDRESS,
            L.POSTAL_CODE
        FROM (SELECT D.*,
                    E.SALARY
                FROM DEPARTMENTS D
                LEFT JOIN EMPLOYEES E 
                ON D.DEPARTMENT_ID = E.DEPARTMENT_ID) A                
LEFT JOIN LOCATIONS L ON A.LOCATION_ID = L.LOCATION_ID) B;

--���� 16
---���� 15����� ���� DEPARTMENT_ID�������� �������� �����ؼ� ROWNUM�� �ٿ� 1-10������ ������
--����ϼ���

SELECT *
FROM (SELECT ROWNUM RN,
       X.*
FROM (SELECT D.*,
       NVL(E.SALARY,0) AS SALARY,
       L.STREET_ADDRESS,
       L.POSTAL_CODE
        FROM DEPARTMENTS D
LEFT JOIN ( SELECT DEPARTMENT_ID,
                   TRUNC(AVG(SALARY)) AS SALARY
             FROM EMPLOYEES
             GROUP BY DEPARTMENT_ID ) E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
LEFT JOIN LOCATIONS L 
ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY D.DEPARTMENT_ID DESC) X
      )
WHERE RN > 0 AND RN <= 10;


