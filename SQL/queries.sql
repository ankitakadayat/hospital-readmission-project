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





