USE customer_bank_data;

-- Counting the number of customers based on payment delay categories (status 0-5, C, X)
SELECT 
    STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_credit_record
GROUP BY STATUS;

-- Analyzing the average annual income of customers with different payment delay statuses
SELECT 
    cr.STATUS, 
    AVG(ar.AMT_INCOME_TOTAL) AS avg_income
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY cr.STATUS;



-- Payment Delay by Income Category
SELECT 
    ar.NAME_INCOME_TYPE, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY ar.NAME_INCOME_TYPE, cr.STATUS;

-- Relationship between Occupation Type and Credit Payment Delays
SELECT 
    ar.OCCUPATION_TYPE, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr
ON ar.ID = cr.ID
GROUP BY ar.OCCUPATION_TYPE, cr.STATUS;

-- Influence of Family Size on Credit Delays
SELECT 
    ar.CNT_FAM_MEMBERS, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY ar.CNT_FAM_MEMBERS, cr.STATUS;

-- Analyzing customers with delays of more than 60 days (status 2 to 5) by occupation type and family size berdasarkan jenis pekerjaan dan jumlah anggota keluarga.
SELECT 
    ar.OCCUPATION_TYPE, 
    ar.CNT_FAM_MEMBERS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
WHERE cr.STATUS IN ('2', '3', '4', '5')
GROUP BY ar.OCCUPATION_TYPE, ar.CNT_FAM_MEMBERS;



-- Relationship Between Employment Duration and Credit Payment Delays
SELECT 
    ABS(ar.DAYS_EMPLOYED) AS employment_duration, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY employment_duration, cr.STATUS;

-- Showing the number of currently unemployed customers with payment delays
SELECT 
    cr.STATUS, 
    COUNT(*) AS num_unemployed_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
WHERE ar.DAYS_EMPLOYED > 0
GROUP BY cr.STATUS;



-- Analyzing the distribution of customer education levels by payment delay status
SELECT 
    ar.NAME_EDUCATION_TYPE, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY ar.NAME_EDUCATION_TYPE, cr.STATUS;



-- Influence of Car Ownership on Credit Delays
SELECT 
    ar.FLAG_OWN_CAR, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY ar.FLAG_OWN_CAR, cr.STATUS;


-- Calculating the average number of days employed for customers with 30-59 day payment delays
SELECT 
    AVG(ar.DAYS_EMPLOYED) AS avg_days_employed
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
WHERE cr.STATUS = '1';



-- Showing the relationship between the number of children and payment delays over 90 days.
SELECT 
    ar.CNT_CHILDREN, 
    COUNT(cr.STATUS) AS num_late_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
WHERE cr.STATUS IN ('3', '4', '5')
GROUP BY ar.CNT_CHILDREN;

-- Influence of Family Size on Credit Delays
SELECT 
    ar.CNT_FAM_MEMBERS, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY ar.CNT_FAM_MEMBERS, cr.STATUS;

-- Calculating the average family size of customers who pay on time
SELECT 
    AVG(ar.CNT_FAM_MEMBERS) AS avg_family_size
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
WHERE cr.STATUS = 'C';



-- Showing the number of customers who own property by payment delay status
SELECT 
    ar.FLAG_OWN_REALTY, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY ar.FLAG_OWN_REALTY, cr.STATUS;



-- Showing payment delay trends based on monthly data
SELECT 
    cr.MONTHS_BALANCE, 
    COUNT(*) AS num_late_customers
FROM customer_bank_data.staging_credit_record cr
WHERE cr.STATUS IN ('2', '3', '4', '5')
GROUP BY cr.MONTHS_BALANCE
ORDER BY cr.MONTHS_BALANCE;



-- Influence of Customer Age on Credit Payment Delays
SELECT 
    ABS(ar.DAYS_BIRTH / 365) AS age, 
    cr.STATUS, 
    COUNT(*) AS num_customers
FROM customer_bank_data.staging_application_record ar
JOIN customer_bank_data.staging_credit_record cr 
ON ar.ID = cr.ID
GROUP BY age, cr.STATUS;




