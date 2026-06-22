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



-- count missing values in all columns
SELECT
  SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
  SUM(CASE WHEN time_in_hospital IS NULL THEN 1 ELSE 0 END) AS time_in_hospital_nulls,
  SUM(CASE WHEN n_lab_procedures IS NULL THEN 1 ELSE 0 END) AS lab_procedures_nulls,
  SUM(CASE WHEN n_procedures IS NULL THEN 1 ELSE 0 END) AS procedures_nulls,
  SUM(CASE WHEN n_medications IS NULL THEN 1 ELSE 0 END) AS medications_nulls,
  SUM(CASE WHEN n_outpatient IS NULL THEN 1 ELSE 0 END) AS outpatient_nulls,
  SUM(CASE WHEN n_inpatient IS NULL THEN 1 ELSE 0 END) AS inpatient_nulls,
  SUM(CASE WHEN n_emergency IS NULL THEN 1 ELSE 0 END) AS emergency_nulls,
  SUM(CASE WHEN medical_specialty IS NULL THEN 1 ELSE 0 END) AS specialty_nulls,
  SUM(CASE WHEN diag_1 IS NULL THEN 1 ELSE 0 END) AS diag1_nulls,
  SUM(CASE WHEN diag_2 IS NULL THEN 1 ELSE 0 END) AS diag2_nulls,
  SUM(CASE WHEN diag_3 IS NULL THEN 1 ELSE 0 END) AS diag3_nulls,
  SUM(CASE WHEN glucose_test IS NULL THEN 1 ELSE 0 END) AS glucose_nulls,
  SUM(CASE WHEN A1Ctest IS NULL THEN 1 ELSE 0 END) AS a1c_nulls,
  SUM(CASE WHEN `change` IS NULL THEN 1 ELSE 0 END) AS change_nulls,
  SUM(CASE WHEN diabetes_med IS NULL THEN 1 ELSE 0 END) AS diabetes_med_nulls,
  SUM(CASE WHEN readmitted IS NULL THEN 1 ELSE 0 END) AS readmitted_nulls
FROM hospital_readmissions;


-- checking missing values in medical specialty
select medical_specialty, count(*) as missing_count
from hospital_readmissions
where medical_specialty='missing'
group by medical_specialty;

-- missing values in medical specialty is 12382

-- No duplicate records found.


alter table hospital_readmissions
add column readmission_flag int;

alter table hospital_readmissions
drop column readmission_flag;

-- CASE STATEMENT for counting readmitted patients
SELECT
  SUM(CASE WHEN readmitted='yes' THEN 1 ELSE 0 END) AS readmitted_count
  from hospital_readmissions;
  
-- calculate readmission rate
select
round(
sum(case when readmitted='yes' then 1 else 0 end)*100/count(*),2) as readmission_rate
from hospital_readmissions;
  
-- verify readmission values
select readmitted, count(*) as total
from hospital_readmissions 
group by readmitted;


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
    
    
select age_group, count(*) as total_patients
from hospital_readmissions
group by age_group;

-- readmission count based on age group
select readmitted, age_group, count(*) as total
from hospital_readmissions
group by readmitted, age_group;


-- readmission rate by age group

select age_group, count(*) as total,
sum(case when readmitted='yes' then 1 else 0 end) as readmitted_count,
round(sum(case when readmitted='yes' then 1 else 0 end) * 100/count(*),2)
as readmission_rate
from hospital_readmissions
group by age_group;

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
 
 -- risk category vs readmission rate
select risk_category, count(*) as total_patients,
sum(case when readmitted='yes' then 1 else 0 end) as readmitted_count,
round(sum(case when readmitted='yes' then 1 else 0 end)* 100/count(*),2)
as readmisson_rate
from hospital_readmissions
group by risk_category;




-- group by analysis

show columns from hospital_readmissions;

-- gorup by age group analysis
select age_group, count(*) as total_patients
from hospital_readmissions
group by age_group;

-- readmitted analysis
select readmitted, count(*) as total_patients
from hospital_readmissions
group by readmitted; 

-- medical specialty analysis
select medical_specialty, count(*) as total_patients
from hospital_readmissions
group by medical_specialty;

-- risk category analysis
select risk_category, count(*) as total_patients
from hospital_readmissions
group by risk_category;

  

-- using CTE for risk_summary

with risk_summary as
(
select risk_category, count(*) as total_patients
from hospital_readmissions
group by risk_category
)
select * 
from risk_summary;
 
 -- uing cte for age_summary
 with age_summary as 
 (
 select age, age_group, count(*) as total_patients
 from hospital_readmissions
 group by age, age_group
 )
 select * from age_summary
 order by age;
 
 -- using CTE for medical_specialty
 with specialty_summary as
 (
   select medical_specialty, count(*) as total_patients
   from hospital_readmissions
    group by medical_specialty
 )
 select * from specialty_summary
 order by total_patients desc;
 
 
-- using cte for readmitted
with readmitted_summary as
(
select readmitted, count(*) as total_patients
from hospital_readmissions
group by readmitted
)
select * from readmitted_summary
order by total_patients;
    
    