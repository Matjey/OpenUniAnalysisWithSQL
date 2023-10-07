USE openUni;
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

--Data Types for each column in the tables. 

-- For the studentinfo table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'studentinfo';

-- For the assestment table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'assessments';

-- For the studentAssessment table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'studentAssessment';

-- For the courses table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'courses';

-- For the studentRegistration table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'studentRegistration';

-- Change the data type for some columns

-- Step 1: Alter the data type of the "code_module" column to nvarchar(255)
ALTER TABLE studentRegistration
ALTER COLUMN code_module NVARCHAR(255);
-- Step 2: Alter the data type of the "id_student" column to nvarchar(50)
ALTER TABLE studentRegistration
ALTER COLUMN id_student NVARCHAR(50);

--3. Retrieve the total number of students
SELECT COUNT(id_student) as total_students
FROM studentinfo;

-- 4. Retrieve the number of students registered for each module
SELECT c.code_module, COUNT(sr.id_student) as NumberOfStudents
FROM courses c
LEFT JOIN studentRegistration sr
ON sr.code_module = c.code_module
GROUP BY c.code_module;

--5. Retrieve the students who have unregistered from a module presentation
SELECT id_student, code_presentation, date_unregistration
FROM studentRegistration 
WHERE date_unregistration IS NOT NULL;


--6. Find the number of students Passed, Failed  and withdrawn
SELECT final_result, COUNT(*) as score_count
FROM studentInfo
WHERE final_result in ('Pass', 'Fail', 'Withdrawn')
GROUP BY final_result;

--7.	Retrieve the average score for each assessment
SELECT a.assessment_type, ROUND(AVG(sa.score), 2) AS avg_score
FROM assessments a
LEFT JOIN studentAssessment sa 
ON a.id_assessment = sa.id_assessment
GROUP BY a.assessment_type;

-- Find the courses with the highest and lowest average assessment scores:
SELECT c.code_module, ROUND(AVG(sa.score),2) AS avg_score
FROM courses c
JOIN studentRegistration sr ON c.code_module = sr.code_module
JOIN studentAssessment sa ON sr.id_student = sa.id_student
GROUP BY c.code_module
ORDER BY avg_score DESC;

--b.Find the highest and lowest scores of students by their gender
SELECT
    si.gender,
    MAX(sa.score) AS highest_score,
    MIN(sa.score) AS lowest_score
FROM
    studentInfo si
JOIN
    studentAssessment sa ON si.id_student = sa.id_student
GROUP BY
    si.gender;

--b.Total registered student by gender
SELECT gender, COUNT(id_student) as total_per_gender
FROM studentInfo
WHERE gender in ('F', 'M')
GROUP BY gender;

--c.Retrieved course registered by each gender
SELECT c.code_module, gender, COUNT(si.id_student) AS num_of_student
FROM courses c
JOIN studentInfo si ON c.code_module = si.code_module
JOIN studentRegistration sr ON sr.id_student = si.id_student
GROUP BY gender, c.code_module

-- Retrived the average score by age_band
SELECT
    si.age_band, COUNT(si.id_student) as num_of_students,
    ROUND(AVG(sa.score),2) as avgScore_by_agegroup
FROM studentInfo si
JOIN studentAssessment sa ON si.id_student = sa.id_student
GROUP BY si.age_band;