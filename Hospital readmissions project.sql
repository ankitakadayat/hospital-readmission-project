-- Ankita Kadayat SQl work
-- Hospital Readmission project

-- Create database
create database hospital_project;

-- Use database 
use hospital_project;

-- create table hospital_readmissions
create table hospital_readmissions(
age varchar(20),
time_in_hospital int,
n_lab_procedures int,
n_procedures int,
n_medications int,
n_outpatient int,
n_inpatient int,
n_emergency int,
medical_specialty varchar(100),
diag_1 varchar(100),
diag_2 varchar(100),
diag_3 varchar(100),
glucose_test varchar(100),
A1Ctest varchar(20),
`change` varchar(20),
diabetes_med varchar(20),
readmitted varchar(20)
);


show tables;

-- display all records from hospital_readmissions table
select * from hospital_readmissions;

-- count total number of rows
select count(*) from hospital_readmissions;

-- count missing values in medical_specialty column
SELECT COUNT(*)
FROM hospital_readmissions
WHERE medical_specialty = 'Missing';


-- count total records
SELECT COUNT(*) AS total_rows
FROM hospital_readmissions;


-- count unique records
SELECT COUNT(DISTINCT CONCAT_WS('|',
 age,
 time_in_hospital,
 n_lab_procedures,
 n_procedures,
 n_medications,
 n_outpatient,
 n_inpatient,
 n_emergency,
 medical_specialty,
 diag_1,
 diag_2,
 diag_3,
 glucose_test,
 A1Ctest,
 `change`,
 diabetes_med,
 readmitted
)) AS unique_rows
FROM hospital_readmissions;

-- No duplicate records found.
-- Total rows and unique rows are both 25,000.

-- add readmission flag column
ALTER TABLE hospital_readmissions
ADD COLUMN readmission_flag INT;

-- convert readmitted yes/no into 1/0
-- disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- convert readmitted yes/no into 1/0
UPDATE hospital_readmissions
SET readmission_flag =
CASE
    WHEN readmitted = 'yes' THEN 1
    WHEN readmitted = 'no' THEN 0
END;

-- verify readmission flag values
SELECT readmitted, readmission_flag, COUNT(*) AS total
FROM hospital_readmissions
GROUP BY readmitted, readmission_flag;

-- 11754 patients were readmitted and 13246 were not.

-- calculate overall readmission rate
SELECT
ROUND(
SUM(readmission_flag) * 100.0 / COUNT(*),
2
) AS readmission_rate
FROM hospital_readmissions;


-- count patients in each age group
SELECT
    age,
    COUNT(*) AS total_patients
FROM hospital_readmissions
GROUP BY age
ORDER BY age;

-- calculate readmission rate by age group

SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(readmission_flag) AS readmitted_patients,
    ROUND(
        SUM(readmission_flag) * 100.0 / COUNT(*),
        2
    ) AS readmission_rate
FROM hospital_readmissions
GROUP BY age
ORDER BY readmission_rate DESC;

-- 