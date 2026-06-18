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


SHOW VARIABLES LIKE "secure_file_priv";

-- load csv data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hospital_readmissions.csv' 
INTO TABLE hospital_readmissions 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
 
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


-- show duplicate rows across all columns
select 
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
 readmitted,
 count(*) as total_copies 
FROM hospital_readmissions
group by  
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
 having count(*)>1;
 



-- No duplicate records found.
-- Total rows and unique rows are both 25,000.

-- add readmission flag column

alter table hospital_readmissions
add column readmission_flag int;

-- CASE STATEMENT to convert yes/no to 1/0
set sql_safe_updates=0;
update hospital_readmissions
set readmission_flag=
case 
	when readmitted='yes' then 1
    when readmitted='no' then 0
end;

-- verify readmission flag values
select readmitted, readmission_flag, count(*) as total
from hospital_readmissions 
group by readmitted, readmission_flag;


-- see all age ranges in the dataset 
select age, count(*) as total_patients
from hospital_readmissions
group by age
order by age;

-- add age_group column
alter table hospital_readmissions
add column afe_group varchar(20);

alter table hospital_readmissions
rename column afe_group to age_group;

-- update age_group values
set sql_safe_updates=0;


update hospital_readmissions
set age_group=
case
    when age in('[40-50)', '[50-60)') then 'adult'
    when age in('[60-70)', '[70-80)') then 'senior'
    when age in('[80-90)', '[90-100)') then 'elderly'
end;    
    
    
select age, age_group, count(*) as total_patients
from hospital_readmissions
group by age, age_group
order by age;


-- adding column risk_category
alter table hospital_readmissions
add column risk_category varchar(20);

-- update Risk_categroy values
set sql_safe_updates=0;

-- using case statement
update hospital_readmissions
set risk_category=
case
    when n_inpatient=0 then 'low risk'
    when n_inpatient=1 then 'medium risk'
    else 'high risk'
end;
 
 -- showing patients by risk category
select  risk_category, count(*) as total_patients
from hospital_readmissions
group by risk_category;




-- group by analysis

show columns from hospital_readmissions;

-- gorup by age analysis
select age, count(*) as total_patients
from hospital_readmissions
group by age
order by age;

-- readmitted analysis
select readmitted, count(*) as total_patients
from hospital_readmissions
group by readmitted; 

-- medical specialty analysis
select medical_specialty, count(*) as total_patients
from hospital_readmissions
group by medical_specialty;


