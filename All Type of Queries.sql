SELECT * FROM SCHOOL;
SELECT * FROM SUBJECTS;
SELECT * FROM STAFF;
SELECT * FROM STAFF_SALARY;
SELECT * FROM CLASSES;
SELECT * FROM STUDENTS;
SELECT * FROM PARENTS;
SELECT * FROM STUDENT_CLASSES;
SELECT * FROM STUDENT_PARENT;
SELECT * FROM ADDRESS;

-- Basic queries
SELECT * FROM STUDENTS;   
SELECT ID, FIRST_NAME FROM STUDENTS;

-- Comparison Operators
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME = 'Mathematics'; 
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME <> 'Mathematics'; 
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME != 'Mathematics'; 
SELECT * FROM STAFF_SALARY WHERE SALARY > 10000; 
SELECT * FROM STAFF_SALARY WHERE SALARY < 10000; 
SELECT * FROM STAFF_SALARY WHERE SALARY < 10000 ORDER BY SALARY; 
SELECT * FROM STAFF_SALARY WHERE SALARY < 10000 ORDER BY SALARY DESC; 
SELECT * FROM STAFF_SALARY WHERE SALARY >= 10000; 
SELECT * FROM STAFF_SALARY WHERE SALARY <= 10000;

-- Logical Operators
SELECT * FROM STAFF_SALARY WHERE SALARY BETWEEN 5000 AND 10000;
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME IN ('Mathematics', 'Science', 'Arts');
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME NOT IN ('Mathematics', 'Science', 'Arts'); 
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME LIKE 'Computer%'; 
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME NOT LIKE 'Computer%'; 
SELECT * FROM STAFF WHERE AGE > 50 AND GENDER = 'F'; 
SELECT * FROM STAFF WHERE FIRST_NAME LIKE 'A%' AND LAST_NAME LIKE 'S%'; 
SELECT * FROM STAFF WHERE FIRST_NAME LIKE 'A%' OR LAST_NAME LIKE 'S%'; 
SELECT * FROM STAFF WHERE (FIRST_NAME LIKE 'A%' OR LAST_NAME LIKE 'S%') AND AGE > 50;

-- Arithmetic Operators
SELECT (5+2) AS ADDITION;   
SELECT (5-2) AS SUBTRACT;  
SELECT (5*2) AS MULTIPLY;
SELECT (5/2) AS DIVIDE;  
SELECT (5%2) AS MODULUS;

SELECT STAFF_TYPE FROM STAFF ; 
SELECT DISTINCT STAFF_TYPE FROM STAFF ; 

-- CASE statement:  (IF 1 then print True ; IF 0 then print FALSE ; ELSE print -1)
SELECT STAFF_ID, SALARY
, CASE WHEN SALARY >= 10000 THEN 'High Salary'
       WHEN SALARY BETWEEN 5000 AND 10000 THEN 'Average Salary'
       WHEN SALARY < 5000 THEN 'Too Low'
  END AS RANGE
FROM STAFF_SALARY
ORDER BY 2 DESC;


SELECT * FROM STUDENTS WHERE DOB = '2014';
SELECT * FROM STUDENTS WHERE DOB = '2014-1-13';

-- JOINS (Two ways to write SQL queries):
-- #1. Using JOIN keyword between tables in FROM clause.
SELECT  T1.COLUMN1 AS C1, T1.COLUMN2 C2, T2.COLUMN3 AS C3   
  FROM  TABLE1    T1
  JOIN  TABLE2 AS T2 ON T1.C1 = T2.C1 AND T1.C2 = T2.C2;    

-- #2. Using comma "," between tables in FROM clause.
SELECT  T1.COLUMN1 AS C1, T1.COLUMN2 AS C2, T2.COLUMN3 C3
  FROM  TABLE1 AS T1, TABLE2 AS T2
 WHERE  T1.C1 = T2.C1
   AND  T1.C2 = T2.C2;

-- Fetch all the class name where Music is thought as a subject.
SELECT CLASS_NAME,SUBJECT_NAME
FROM SUBJECTS SUB
JOIN CLASSES CLS ON SUB.SUBJECT_ID = CLS.SUBJECT_ID
WHERE SUBJECT_NAME = 'Music';

-- Fetch the full name of all staff who teach Mathematics.
SELECT DISTINCT STF.FIRST_NAME + ' ' + STF.LAST_NAME AS FULL_NAME -- , CLS.CLASS_NAME
FROM SUBJECTS SUB
JOIN CLASSES CLS ON CLS.SUBJECT_ID = SUB.SUBJECT_ID
JOIN STAFF STF ON CLS.TEACHER_ID = STF.STAFF_ID
WHERE SUB.SUBJECT_NAME = 'Mathematics';


-- Fetch all staff who teach grade 8, 9, 10 and also fetch all the non-teaching staff
-- UNION can be used to merge two differnt queries. UNION returns always unique records so any duplicate data while merging these queries will be eliminated.
-- UNION ALL displays all records including the duplicate records.
-- When using both UNION, UNION ALL operators, rememeber that noo of columns and their data type must match among the different queries.
SELECT STF.STAFF_TYPE
,    (STF.FIRST_NAME+' '+STF.LAST_NAME) AS FULL_NAME
,    STF.AGE
,    (CASE WHEN STF.GENDER = 'M' THEN 'Male'
           WHEN STF.GENDER = 'F' THEN 'Female'
      END) AS GENDER
,    STF.JOIN_DATE
FROM STAFF STF
JOIN CLASSES CLS ON STF.STAFF_ID = CLS.TEACHER_ID
WHERE STF.STAFF_TYPE = 'Teaching'
AND   CLS.CLASS_NAME IN ('Grade 8', 'Grade 9', 'Grade 10')
UNION ALL
SELECT STAFF_TYPE
,    (FIRST_NAME+' '+LAST_NAME) AS FULL_NAME, AGE
,    (CASE WHEN GENDER = 'M' THEN 'Male'
           WHEN GENDER = 'F' THEN 'Female'
      END) AS GENDER
,    JOIN_DATE
FROM STAFF
WHERE STAFF_TYPE = 'Non-Teaching';

-- Count no of students in each class
SELECT SC.CLASS_ID, COUNT(1) AS "no_of_students"
FROM STUDENT_CLASSES SC
GROUP BY SC.CLASS_ID
ORDER BY SC.CLASS_ID;

-- Return only the records where there are more than 100 students in each class
SELECT SC.CLASS_ID, COUNT(1) AS "no_of_students"
FROM STUDENT_CLASSES SC
GROUP BY SC.CLASS_ID
HAVING COUNT(1) > 100
ORDER BY SC.CLASS_ID;

-- Parents with more than 1 kid in school.
SELECT PARENT_ID, COUNT(1) AS "no_of_kids"
FROM STUDENT_PARENT SP
GROUP BY PARENT_ID
HAVING COUNT(1) > 1;


--SUBQUERY: Query written inside a query is called subquery.
-- Fetch the details of parents having more than 1 kids going to this school. Also display student details.
SELECT P.FIRST_NAME,' ',P.LAST_NAME 
,    S.FIRST_NAME,' ',S.LAST_NAME 
,    S.AGE 
,    S.GENDER 
,    ADR.STREET,' ',ADR.CITY,' ',ADR.STATE,' ',ADR.COUNTRY 
FROM PARENTS P
JOIN STUDENT_PARENT SP ON P.ID = SP.PARENT_ID
JOIN STUDENTS S ON S.ID = SP.STUDENT_ID
JOIN ADDRESS ADR ON P.ADDRESS_ID = ADR.ADDRESS_ID
WHERE P.ID IN (SELECT PARENT_ID
               FROM STUDENT_PARENT SP
               GROUP BY PARENT_ID
               HAVING COUNT(1) = 1)
ORDER BY 1;


-- Staff details whos salary is less than 5000
SELECT STAFF_TYPE, FIRST_NAME, LAST_NAME
FROM  STAFF
WHERE STAFF_ID IN (SELECT STAFF_ID
                     FROM STAFF_SALARY
                    WHERE SALARY < 5000);


--Aggregate Functions (AVG, MIN, MAX, SUM, COUNT): Aggregate functions are used to perform calculations on a set of values.
-- AVG: Calculates the average of the given values.
SELECT AVG(SS.SALARY)++NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
WHERE STF.STAFF_TYPE = 'Teaching';

SELECT STF.STAFF_TYPE, AVG(SS.SALARY)++NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;


-- SUM: Calculates the total sum of all values in the given column.
SELECT STF.STAFF_TYPE, SUM(SS.SALARY)++NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;

-- MIN: Returns the record with minimun value in the given column.
SELECT STF.STAFF_TYPE, MIN(SS.SALARY)++NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;

-- MAX: Returns the record with maximum value in the given column.
SELECT STF.STAFF_TYPE, MAX(SS.SALARY)++NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;

/*
SQL Joins: There are several types of JOIN but we look at the most commonly used:
1) Inner Join
    - Inner joins fetches records when there are matching values in both tables.
2) Outer Join
    - Left Outer Join
        - Left join fetches all records from left table and the matching records from right table.
        - The count of the query will be the count of the Left table.
        - Columns which are fetched from right table and do not have a match will be passed as NULL.
    - Right Outer Join
        - Right join fetches all records from right table and the matching records from left table.
        - The count of the query will be the count of the right table.
        - Columns which are fetched from left table and do not have a match will be passed as NULL.
    - Full Outer Join
        - Full join always return the matching and non-matching records from both left and right table.
*/

-- Inner Join: 21 records returned  Inner join always fetches only the matching records present in both right and left table.
-- Inner Join can be represented as eithe "JOIN" or as "INNER JOIN". Both are correct and mean the same.
SELECT COUNT(1)
FROM STAFF STF
JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME++' '++STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 2;


-- 23 records  23 records present in left table.
-- All records from LEFT table with be fetched irrespective of whether there is matching record in the RIGHT table.
SELECT COUNT(1)
FROM STAFF STF
LEFT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME++' '++STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
LEFT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 2;


-- 24 records  24 records in right table.
-- All records from RIGHT table with be fetched irrespective of whether there is matching record in the LEFT table.
SELECT COUNT(1)
FROM STAFF STF
RIGHT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME' 'STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
RIGHT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;


-- 26 records  all records from both tables. 21 matching records + 2 records from left + 3 from right table.
-- All records from both LEFT and RIGHT table with be fetched irrespective of whether there is matching record in both these tables.
SELECT COUNT(1)
FROM STAFF STF
FULL OUTER JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME++' '++STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
FULL OUTER JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1,2;
