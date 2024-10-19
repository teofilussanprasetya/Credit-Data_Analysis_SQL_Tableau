CREATE DATABASE customer_bank_data;

USE customer_bank_data;

CREATE TABLE application_record (
    ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CODE_GENDER VARCHAR(5) NOT NULL,
    FLAG_OWN_CAR VARCHAR(5) NOT NULL,
    FLAG_OWN_REALTY VARCHAR(5) NOT NULL,
    CNT_CHILDREN INT NOT NULL,
    AMT_INCOME_TOTAL DECIMAL(15,2) NOT NULL,
    NAME_INCOME_TYPE VARCHAR(255) NOT NULL,
    NAME_EDUCATION_TYPE VARCHAR(255) NOT NULL,
    NAME_FAMILY_STATUS VARCHAR(255) NOT NULL,
    NAME_HOUSING_TYPE VARCHAR(255) NOT NULL,
    DAYS_BIRTH INT NOT NULL,
    DAYS_EMPLOYED INT NOT NULL,
    FLAG_MOBIL INT NOT NULL,
    FLAG_WORK_PHONE INT NOT NULL,
    FLAG_PHONE INT NOT NULL,
    FLAG_EMAIL INT NOT NULL,
    OCCUPATION_TYPE VARCHAR(255) NOT NULL,
    CNT_FAM_MEMBERS INT NOT NULL
);

CREATE TABLE credit_record (
    credit_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID INT NOT NULL,
    MONTHS_BALANCE INT NOT NULL,
    STATUS VARCHAR(5) NOT NULL,
    FOREIGN KEY (ID) REFERENCES application_record(ID)
);

SHOW TABLES;

DESCRIBE application_record;
DESCRIBE credit_record;

-- SQL Project - Data Cleaning for Bank Application and Credit Records

-- Create staging tables to work with raw data
CREATE TABLE customer_bank_data.staging_application_record AS
SELECT * FROM customer_bank_data.application_record;

CREATE TABLE customer_bank_data.staging_credit_record AS
SELECT * FROM customer_bank_data.credit_record;

-- Check for duplicates and remove them from application records

-- Check duplicates in staging_application_record based on all columns
SELECT COUNT(*), ID, CODE_GENDER, FLAG_OWN_CAR, FLAG_OWN_REALTY, CNT_CHILDREN, AMT_INCOME_TOTAL, NAME_INCOME_TYPE, NAME_EDUCATION_TYPE, NAME_FAMILY_STATUS, NAME_HOUSING_TYPE, DAYS_BIRTH, DAYS_EMPLOYED, FLAG_MOBIL, FLAG_WORK_PHONE, FLAG_PHONE, FLAG_EMAIL, OCCUPATION_TYPE, CNT_FAM_MEMBERS
FROM customer_bank_data.staging_application_record
GROUP BY ID, CODE_GENDER, FLAG_OWN_CAR, FLAG_OWN_REALTY, CNT_CHILDREN, AMT_INCOME_TOTAL, NAME_INCOME_TYPE, NAME_EDUCATION_TYPE, NAME_FAMILY_STATUS, NAME_HOUSING_TYPE, DAYS_BIRTH, DAYS_EMPLOYED, FLAG_MOBIL, FLAG_WORK_PHONE, FLAG_PHONE, FLAG_EMAIL, OCCUPATION_TYPE, CNT_FAM_MEMBERS
HAVING COUNT(*) > 1;

-- Remove duplicates in application_record
DELETE t1 FROM customer_bank_data.staging_application_record t1
INNER JOIN customer_bank_data.staging_application_record t2
WHERE t1.ID > t2.ID 
AND t1.ID = t2.ID
AND t1.CODE_GENDER = t2.CODE_GENDER
AND t1.FLAG_OWN_CAR = t2.FLAG_OWN_CAR
AND t1.FLAG_OWN_REALTY = t2.FLAG_OWN_REALTY
AND t1.CNT_CHILDREN = t2.CNT_CHILDREN
AND t1.AMT_INCOME_TOTAL = t2.AMT_INCOME_TOTAL
AND t1.NAME_INCOME_TYPE = t2.NAME_INCOME_TYPE
AND t1.NAME_EDUCATION_TYPE = t2.NAME_EDUCATION_TYPE
AND t1.NAME_FAMILY_STATUS = t2.NAME_FAMILY_STATUS
AND t1.NAME_HOUSING_TYPE = t2.NAME_HOUSING_TYPE
AND t1.DAYS_BIRTH = t2.DAYS_BIRTH
AND t1.DAYS_EMPLOYED = t2.DAYS_EMPLOYED
AND t1.FLAG_MOBIL = t2.FLAG_MOBIL
AND t1.FLAG_WORK_PHONE = t2.FLAG_WORK_PHONE
AND t1.FLAG_PHONE = t2.FLAG_PHONE
AND t1.FLAG_EMAIL = t2.FLAG_EMAIL
AND t1.OCCUPATION_TYPE = t2.OCCUPATION_TYPE
AND t1.CNT_FAM_MEMBERS = t2.CNT_FAM_MEMBERS;

SELECT *
FROM customer_bank_data.staging_application_record;


-- Check duplicates in staging_credit_record
SELECT COUNT(*), ID, MONTHS_BALANCE, STATUS
FROM customer_bank_data.staging_credit_record
GROUP BY ID, MONTHS_BALANCE, STATUS
HAVING COUNT(*) > 1;

-- Remove duplicates in staging_credit_record based on column combinations
DELETE t1 FROM customer_bank_data.staging_credit_record t1
INNER JOIN customer_bank_data.staging_credit_record t2
WHERE t1.ID > t2.ID 
AND t1.ID = t2.ID
AND t1.MONTHS_BALANCE = t2.MONTHS_BALANCE
AND t1.STATUS = t2.STATUS;

SELECT *
FROM customer_bank_data.staging_credit_record;


-- Check for hidden characters in the STATUS field 
SELECT DISTINCT STATUS, LENGTH(STATUS) AS length_of_status
FROM customer_bank_data.credit_record
ORDER BY STATUS;

-- Clean STATUS column values
UPDATE customer_bank_data.staging_credit_record
SET STATUS = REPLACE(REPLACE(REPLACE(REPLACE(STATUS, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), ' ', '');

-- Check for hidden characters in the STATUS field after cleaning
SELECT DISTINCT STATUS, LENGTH(STATUS) AS length_of_status
FROM customer_bank_data.staging_credit_record
ORDER BY STATUS;



-- Add the 'credit_id' column as PRIMARY KEY and AUTO_INCREMENT
ALTER TABLE customer_bank_data.staging_credit_record
ADD CREDIT_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

SELECT *
FROM customer_bank_data.staging_credit_record;


-- Standardize values for some columns in staging_application_record
UPDATE customer_bank_data.staging_application_record
SET CODE_GENDER = UPPER(CODE_GENDER),
    FLAG_OWN_CAR = UPPER(FLAG_OWN_CAR),
    FLAG_OWN_REALTY = UPPER(FLAG_OWN_REALTY);

-- Check the number of empty strings ('') in each column of staging_application_record
SELECT 
    SUM(CASE WHEN CODE_GENDER = '' THEN 1 ELSE 0 END) AS empty_code_gender,
    SUM(CASE WHEN FLAG_OWN_CAR = '' THEN 1 ELSE 0 END) AS empty_flag_own_car,
    SUM(CASE WHEN FLAG_OWN_REALTY = '' THEN 1 ELSE 0 END) AS empty_flag_own_realty,
    SUM(CASE WHEN CNT_CHILDREN IS NULL THEN 1 ELSE 0 END) AS empty_cnt_children,
    SUM(CASE WHEN AMT_INCOME_TOTAL IS NULL THEN 1 ELSE 0 END) AS empty_amt_income_total,
    SUM(CASE WHEN NAME_INCOME_TYPE = '' THEN 1 ELSE 0 END) AS empty_name_income_type,
    SUM(CASE WHEN NAME_EDUCATION_TYPE = '' THEN 1 ELSE 0 END) AS empty_name_education_type,
    SUM(CASE WHEN NAME_FAMILY_STATUS = '' THEN 1 ELSE 0 END) AS empty_name_family_status,
    SUM(CASE WHEN NAME_HOUSING_TYPE = '' THEN 1 ELSE 0 END) AS empty_name_housing_type,
    SUM(CASE WHEN DAYS_BIRTH IS NULL THEN 1 ELSE 0 END) AS empty_days_birth,
    SUM(CASE WHEN DAYS_EMPLOYED IS NULL THEN 1 ELSE 0 END) AS empty_days_employed,
    SUM(CASE WHEN FLAG_MOBIL IS NULL THEN 1 ELSE 0 END) AS empty_flag_mobil,
    SUM(CASE WHEN FLAG_WORK_PHONE IS NULL THEN 1 ELSE 0 END) AS empty_flag_work_phone,
    SUM(CASE WHEN FLAG_PHONE IS NULL THEN 1 ELSE 0 END) AS empty_flag_phone,
    SUM(CASE WHEN FLAG_EMAIL IS NULL THEN 1 ELSE 0 END) AS empty_flag_email,
    SUM(CASE WHEN OCCUPATION_TYPE = '' THEN 1 ELSE 0 END) AS empty_occupation_type,
    SUM(CASE WHEN CNT_FAM_MEMBERS IS NULL THEN 1 ELSE 0 END) AS empty_cnt_fam_members
FROM customer_bank_data.staging_application_record;

-- Change all empty string values ('') in the OCCUPATION_TYPE column to NULL
UPDATE customer_bank_data.staging_application_record
SET OCCUPATION_TYPE = NULL
WHERE OCCUPATION_TYPE = '';


-- Handle null values in the OCCUPATION_TYPE column
UPDATE customer_bank_data.staging_application_record
SET OCCUPATION_TYPE = COALESCE(OCCUPATION_TYPE, 'Unknown');

SELECT *
FROM customer_bank_data.staging_application_record;


-- Check the number of NULL values in each column in credit_record
SELECT 
    SUM(CASE WHEN STATUS = '' THEN 1 ELSE 0 END) AS NULL_STATUS,
    SUM(CASE WHEN MONTHS_BALANCE IS NULL THEN 1 ELSE 0 END) AS NULL_MONTHS_BALANCE,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS NULL_ID,
    SUM(CASE WHEN CREDIT_ID IS NULL THEN 1 ELSE 0 END) AS NULL_CREDIT_ID
FROM customer_bank_data.staging_credit_record;


-- Review Cleaned Data
SELECT * FROM customer_bank_data.staging_application_record;
SELECT * FROM customer_bank_data.staging_credit_record;

