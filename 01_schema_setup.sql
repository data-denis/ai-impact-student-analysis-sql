-- ==============================================================================
-- PROJECT: Generative AI Impact on Higher Education Academic Performance
-- AUTHOR: Denis
-- FILE: Schema setup
-- DESCRIPTION: Builds the normalized schema from the raw flat file. Creates the
--              three tables, keyed on Student_ID, and populates them from the
--              imported Kaggle dataset.
-- ==============================================================================
-- The raw file (ai_student_impact_dataset) is imported from the Kaggle CSV via
-- the MySQL Workbench import wizard. This script then splits that flat table into
-- three normalized tables: one parent (students_info) and two children that
-- reference it by Student_ID.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- STEP 1: CREATE TABLES
-- students_info is the parent table (one row per student, Student_ID as primary
-- key). ai_usage and wellbeing_info reference it through a foreign key.
-- ------------------------------------------------------------------------------

CREATE TABLE `students_info` (
  `Student_ID` int NOT NULL,
  `Major_Category` text,
  `Year_of_Study` text,
  `Traditional_Study_Hours` double DEFAULT NULL,
  `Skill_Retention_Score` double DEFAULT NULL,
  `Pre_Semester_GPA` double DEFAULT NULL,
  `Post_Semester_GPA` double DEFAULT NULL,
  PRIMARY KEY (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ai_usage` (
  `Student_ID` int NOT NULL,
  `Weekly_GenAI_Hours` double DEFAULT NULL,
  `Primary_Use_Case` text,
  `Perceived_AI_Dependency` int DEFAULT NULL,
  `Paid_Subscription` text,
  `Prompt_Engineering_Skill` text,
  `Tool_Diversity` int DEFAULT NULL,
  FOREIGN KEY (`Student_ID`) REFERENCES `students_info` (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wellbeing_info` (
  `Student_ID` int NOT NULL,
  `Institutional_Policy` text,
  `Anxiety_Level_During_Exams` int DEFAULT NULL,
  `Burnout_Risk_Level` text,
  FOREIGN KEY (`Student_ID`) REFERENCES `students_info` (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------------------------
-- STEP 2: POPULATE TABLES FROM THE FLAT FILE
-- Insert the parent first so the foreign keys in the child tables resolve.
-- Each INSERT copies only the columns that belong to that table.
-- ------------------------------------------------------------------------------

INSERT INTO students_info
    (Student_ID, Major_Category, Year_of_Study, Traditional_Study_Hours,
     Skill_Retention_Score, Pre_Semester_GPA, Post_Semester_GPA)
SELECT
     Student_ID, Major_Category, Year_of_Study, Traditional_Study_Hours,
     Skill_Retention_Score, Pre_Semester_GPA, Post_Semester_GPA
FROM ai_student_impact_dataset;

INSERT INTO ai_usage
    (Student_ID, Weekly_GenAI_Hours, Primary_Use_Case, Perceived_AI_Dependency,
     Paid_Subscription, Prompt_Engineering_Skill, Tool_Diversity)
SELECT
     Student_ID, Weekly_GenAI_Hours, Primary_Use_Case, Perceived_AI_Dependency,
     Paid_Subscription, Prompt_Engineering_Skill, Tool_Diversity
FROM ai_student_impact_dataset;

INSERT INTO wellbeing_info
    (Student_ID, Institutional_Policy, Anxiety_Level_During_Exams, Burnout_Risk_Level)
SELECT
     Student_ID, Institutional_Policy, Anxiety_Level_During_Exams, Burnout_Risk_Level
FROM ai_student_impact_dataset;
