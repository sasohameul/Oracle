--���� 1.
---EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
---EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ�
--���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� Ȯ��)

SELECT* FROM EMPLOYEES;
SELECT* FROM DEPARTMENTS;

SELECT *
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;  --106��

SELECT *
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; --107��

SELECT*
FROM EMPLOYEES E
RIGHT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; --122��

--���� 2.
---EMPLOYEES, DEPARTMENTS ���̺��� INNER JOIN�ϼ���
--����)employee_id�� 200�� ����� �̸�, department_id�� ����ϼ���
--����)�̸� �÷��� first_name�� last_name�� ���ļ� ����մϴ�
SELECT EMPLOYEE_ID,
       CONCAT(E.FIRST_NAME, E.LAST_NAME) AS NAME,
       E.DEPARTMENT_ID 
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EMPLOYEE_ID = 200;

--���� 3.
---EMPLOYEES, JOBS���̺��� INNER JOIN�ϼ���
--����) ��� ����� �̸��� �������̵�, ���� Ÿ��Ʋ�� ����ϰ�, �̸� �������� �������� ����
--HINT) � �÷����� ���� ����� �ִ��� Ȯ��
SELECT* FROM EMPLOYEES;
SELECT* FROM JOBS;

SELECT E.FIRST_NAME,
       JOB_ID,
       J.JOB_TITLE
FROM EMPLOYEES E
INNER JOIN JOBS J
USING (JOB_ID)
ORDER BY FIRST_NAME ASC;

--���� 4.
----JOBS���̺�� JOB_HISTORY���̺��� LEFT_OUTER JOIN �ϼ���.
SELECT* FROM JOB_HISTORY;
SELECT* FROM JOBS;

SELECT * FROM JOBS J
LEFT JOIN JOB_HISTORY JH
ON J.JOB_ID = JH.JOB_ID;

--���� 5.
----Steven King�� �μ����� ����ϼ���.
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT E.FIRST_NAME || ' '|| E.LAST_NAME AS NAME,
       D.DEPARTMENT_ID ,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.FIRST_NAME || ' '|| E.LAST_NAME = 'Steven King';


--���� 6.
----EMPLOYEES ���̺�� DEPARTMENTS ���̺��� Cartesian Product(Cross join)ó���ϼ���
SELECT *
FROM EMPLOYEES
CROSS JOIN DEPARTMENTS;


--���� 7.
----EMPLOYEES ���̺�� DEPARTMENTS ���̺��� �μ���ȣ�� �����ϰ� 
----SA_MAN ������� �����ȣ, �̸�, �޿�, �μ���, �ٹ����� ����ϼ���. (Alias�� ���)
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT E.EMPLOYEE_ID AS �����ȣ,
       E.FIRST_NAME|| ' ' || LAST_NAME AS �̸�,
       E.SALARY AS �޿�,
       D.DEPARTMENT_NAME AS �μ���,
       L.STREET_ADDRESS AS �ٹ���
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D 
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
WHERE JOB_ID = 'SA_MAN';

--���� 8.
---- employees, jobs ���̺��� ���� �����ϰ� job_title�� 'Stock Manager', 'Stock Clerk'�� ���� ������
--����ϼ���.
SELECT * FROM JOBS;
SELECT * 
FROM EMPLOYEES E
LEFT JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
WHERE JOB_TITLE IN ( 'Stock Manager','Stock Clerk' );

--���� 9.
---- departments ���̺��� ������ ���� �μ��� ã�� ����ϼ���. LEFT OUTER JOIN ���
SELECT* FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT OUTER JOIN EMPLOYEES E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE D.MANAGER_ID IS NULL;

--���� 10. 
---join�� �̿��ؼ� ����� �̸��� �� ����� �Ŵ��� �̸��� ����ϼ���
--��Ʈ) EMPLOYEES ���̺�� EMPLOYEES ���̺��� �����ϼ���.
SELECT * FROM EMPLOYEES;

SELECT E.EMPLOYEE_ID,
       E.FIRST_NAME || ' ' ||E.LAST_NAME AS ����̸�,
       F.FIRST_NAME || ' ' ||F.LAST_NAME AS �Ŵ����̸�     
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES F
ON E.MANAGER_ID = F.EMPLOYEE_ID;
     
--���� 11. 
----EMPLOYEES ���̺��� left join�Ͽ� ������(�Ŵ���)��, �Ŵ����� �̸�, �Ŵ����� �޿� ���� ����ϼ���
----�Ŵ��� ���̵� ���� ����� �����ϰ� �޿��� �������� ����ϼ���

SELECT* FROM EMPLOYEES;

SELECT E.JOB_ID,
       E.FIRST_NAME || ' ' ||E.LAST_NAME AS �Ŵ����̸�,
       F.SALARY AS �Ŵ����޿�
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES F
ON E.JOB_ID = F.JOB_ID
WHERE E.JOB_ID LIKE '___MAN%' AND E.MANAGER_ID IS NOT NULL
ORDER BY E.SALARY DESC;

--�����Դ�
SELECT E1.FIRST_NAME AS �����,
       E1.SALARY AS ����޿�,
       E2.EMPLOYEE_ID AS �Ŵ������̵�,
       E2.SALARY AS �Ŵ����޿�
FROM EMPLOYEES E1 LEFT JOIN EMPLOYEES E2 ON E1.MANAGER_ID = E2.EMPLOYEE_ID
WHERE E.MANAGER_ID IS NOT NULL
ORDER BY E1.SALARY DESC;

       