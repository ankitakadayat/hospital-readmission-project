create database hospital_project;
show tables;

select * from hospital_readmissions;

select count(*) from hospital_readmissions;

SELECT COUNT(*)
FROM hospital_readmissions
WHERE medical_specialty = 'Missing';

