--����ȯ �Լ�
--�ڵ� ����ȯ
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = '30'; --�ڵ� ����ȯ
SELECT SYSDATE -5, SYSDATE - '5' FROM EMPLOYEES; --�ڵ� ����ȯ

--��������ȯ
--TO_CHAR(��¥,��¥����)
SELECT SYSDATE FROM DUAL; --��¥��
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --���������� ��ȯ
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD HH24/MI/SS') FROM DUAL; --���������� ��ȯ
SELECT TO_CHAR(SYSDATE, 'YYYY"��"MM"��"DD"��"')FROM DUAL;
SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')FROM EMPLOYEES;

--to_char(����, ��������)
SELECT TO_CHAR(200000, '$999,999,999') FROM DUAL;
SELECT TO_CHAR(200000.1234, '999999.99') FROM DUAL;--�Ҽ��� �ڸ�ǥ��
SELECT TO_CHAR(SALARY * 1300, 'L999,999,999') FROM EMPLOYEES;
SELECT FIRST_NAME, TO_CHAR( SALARY * 1300,'L999,999,999') FROM EMPLOYEES;--����ȭ��
SELECT FIRST_NAME, TO_CHAR( SALARY * 1300,'L0999,999,999') FROM EMPLOYEES;--�ڸ����� 0���� ä��

--TO_NUMBER(����, ��������)
SELECT '3.14' + 2000 FROM DUAL; --�ڵ� ����ȯ
SELECT TO_NUMBER('3.14') + 2000 FROM DUAL; -- ����� ����ȯ(��������ȯ)
SELECT TO_NUMBER('$3,300', '$999,999') + 2000 FROM DUAL;

--TO_DATE(����, ��¥����)
SELECT '2023-05-16' - SYSDATE  FROM DUAL; --ERROR
SELECT SYSDATE - TO_DATE('2023-05-16', 'YYYY-MM-DD') FROM DUAL;
SELECT SYSDATE - TO_DATE('2023/05/16 11:31:23', 'YYYY/MM/DD HH:MI:SS') FROM DUAL;

--�Ʒ� ���� YYYY�� MM�� DD�� ���·� ����غ��ÿ�
SELECT '20050105' FROM DUAL;
SELECT TO_CHAR(TO_DATE('20050105', 'YYYYMMDD'), 'YYYY"��" MM"��" DD"��"')FROM DUAL;

--�Ʒ� ���� ���� ��¥�� �ϼ� ���̸� ���ϼ���
SELECT '2005��01��05��' FROM DUAL;
SELECT SYSDATE - TO_DATE('2005��01��05��', 'YYYY"��"MM"��"DD"��"') FROM DUAL;
-------------------------------------------------------------------------------

--NULL���� ���� ��ȯ
--NVL(�÷�, NULL�� ��� ó��)
SELECT NVL(NULL,0) FROM DUAL;
SELECT FIRST_NAME, NVL(COMMISSION_PCT,0) FROM EMPLOYEES;

--NVL(�÷�, NULL�� �ƴ� ��� ó��, NULL�� ��� ó��)
SELECT NVL2(NULL, '���� �ƴմϴ�', '���Դϴ�') FROM DUAL;
SELECT FIRST_NAME,
       SALARY,
       COMMISSION_PCT,
       NVL2(COMMISSION_PCT, (SALARY * COMMISSION_PCT), SALARY) AS �޿� 
       FROM EMPLOYEES; --�� ���� ���ΰ�
       
--DECODE() -ELSE IF���� ��ü�ϴ� �Լ�
SELECT DECODE('D', 'A', 'A�Դϴ�',
                   'B', 'B�Դϴ�',
                   'C', 'C�Դϴ�', 
                   'ABC�� �ƴմϴ�')FROM DUAL;

SELECT JOB_ID, 
       DECODE(JOB_ID, 'IT_PROG', SALARY * 0.3,
                      'FI_MGR', SALARY * 0.2,
                      SALARY) FROM EMPLOYEES;
--CASE WHEN THEN ELSE
--1st �����
SELECT JOB_ID,
       CASE JOB_ID WHEN 'IT_PROG' THEN SALARY * 0.3
                   WHEN 'FI_MGR' THEN SALARY * 0.2
                   ELSE SALARY
       END
       
FROM EMPLOYEES;
--2nd ����� (��Һ� OR �ٸ� �÷��� �� ����)
SELECT JOB_ID,
        CASE WHEN JOB_ID = 'IT_PROG' THEN SALARY * 0.3
             WHEN JOB_ID = 'FI_MGR' THEN SALARY * 0.2
             ELSE SALARY
        END
FROM EMPLOYEES;

--COALEACE(A,B)-NVL�̶� ���� (NULL�� ��쿡 0���� ġȯ)
SELECT COALESCE( COMMISSION_PCT, 0 ) FROM EMPLOYEES;

-----------------------------------------------------------
--��������
--���� 1.
--�������ڸ� �������� EMPLOYEE���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 10�� �̻���
--����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��� ������. 
--���� 1) �ټӳ���� ���� ��� ������� ����� �������� �մϴ�
SELECT EMPLOYEE_ID AS �����ȣ, 
       FIRST_NAME ||' ' || LAST_NAME AS ����� ,
       HIRE_DATE AS �Ի�����,
       TRUNC((SYSDATE - HIRE_DATE)/365) AS �ټӳ�� 
       FROM EMPLOYEES WHERE TRUNC((SYSDATE - HIRE_DATE)/365)>= 10 
       ORDER BY �ټӳ�� DESC;                                    

--���� 2.
--EMPLOYEE ���̺��� manager_id�÷��� Ȯ���Ͽ� first_name, manager_id, ������ ����մϴ�.
--100�̶�� �������, 
--120�̶�� �����ӡ�
--121�̶�� ���븮��
--122��� �����塯
--�������� ���ӿ��� ���� ����մϴ�.
--���� 1) manager_id�� 50�� ������� ������θ� ��ȸ�մϴ�
SELECT * FROM EMPLOYEES;
SELECT FIRST_NAME, MANAGER_ID,
       CASE WHEN MANAGER_ID = '100' THEN '���'  
            WHEN MANAGER_ID = '120' THEN '����' 
            WHEN MANAGER_ID = '121' THEN '�븮' 
            WHEN MANAGER_ID = '122' THEN '����' 
            ELSE '�ӿ�' 
        END AS ����
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 50;

SELECT FIRST_NAME,
       MANAGER_ID,
       DECODE(MANAGER_ID, 100, '���',
                          120, '����',
                          121, '�븮',
                          122, '����',
                          '�ӿ�') AS ����
       FROM EMPLOYEES
       WHERE DEPARTMENT_ID = 50;
       


