-- ==============================================================================
-- PROJECT: Generative AI Impact on Higher Education Academic Performance
-- AUTHOR: Denis
-- DESCRIPTION: End-to-end data analysis examining the relationship between GenAI 
--              adoption, academic performance (GPA), and student mental wellbeing.
-- ==============================================================================
--                 [ Raw Data Flat File ]
-- 			     ai_student_impact_dataset
--                            │
--                            ▼  (Normalized Schema)
--          ┌─────────────────┼─────────────────┐
--          ▼                 ▼                 ▼
--   students_info         ai_usage       wellbeing_info
--   (Student_ID PK)    (Student_ID FK)   (Student_ID FK)
-- ==============================================================================
-- PHASE 1: EXPLORATORY DATA ANALYSIS (SINGLE FLAT TABLE)
-- Description: Working with the raw 'ai_student_impact_dataset' to uncover macro 
--              academic trends before data normalization.
-- ==============================================================================

-- Query 1.1: Averages by major
-- FINDING: STEM students use AI the most and also show the highest GPA change and
--          skill retention. The gap in AI usage compared to other majors is notable.
SELECT 
    Major_Category AS major, 
    ROUND(AVG(Pre_Semester_GPA), 2) AS avg_starting_gpa, 
    ROUND(AVG(Post_Semester_GPA), 2) AS avg_final_gpa,
    ROUND(AVG(Post_Semester_GPA) - AVG(Pre_Semester_GPA), 2) AS gpa_change, 
    ROUND(AVG(Traditional_Study_Hours), 2) AS avg_study_hours, 
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Skill_Retention_Score), 2) AS avg_skill_retention
FROM ai_student_impact_dataset
GROUP BY Major_Category
ORDER BY gpa_change DESC;

-- Query 1.2: Averages by institutional policy
-- FINDING: Schools that ban AI show the lowest skill retention and GPA change, and
--          students report using AI anyway, suggesting bans may not be effective.
SELECT 
    Institutional_Policy AS policy, 
    ROUND(AVG(Pre_Semester_GPA), 2) AS avg_starting_gpa, 
    ROUND(AVG(Post_Semester_GPA), 2) AS avg_final_gpa, 
    ROUND(AVG(Post_Semester_GPA) - AVG(Pre_Semester_GPA), 2) AS gpa_change,
    ROUND(AVG(Traditional_Study_Hours), 2) AS avg_study_hours, 
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Skill_Retention_Score), 2) AS avg_skill_retention
FROM ai_student_impact_dataset
GROUP BY Institutional_Policy
ORDER BY gpa_change DESC;

-- Query 1.3: Averages by year of study
-- FINDING: GPA change improves as students progress through their academic years,
--          but all other metrics remain largely the same across year groups.
SELECT 
    Year_of_Study AS academic_year, 
    ROUND(AVG(Pre_Semester_GPA), 2) AS avg_starting_gpa, 
    ROUND(AVG(Post_Semester_GPA), 2) AS avg_final_gpa, 
    ROUND(AVG(Post_Semester_GPA) - AVG(Pre_Semester_GPA), 2) AS gpa_change,
    ROUND(AVG(Traditional_Study_Hours), 2) AS avg_study_hours, 
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Skill_Retention_Score), 2) AS avg_skill_retention
FROM ai_student_impact_dataset
GROUP BY Year_of_Study
ORDER BY academic_year ASC;

-- Query 1.4: How does AI usage relate to GPA change?
-- FINDING: Moderate AI usage is associated with the highest GPA improvement, while
--          heavy usage shows the worst result, suggesting balance is key.
WITH ai_gpa AS 
( 
SELECT 
    Student_ID, 
    Pre_Semester_GPA, 
    Post_Semester_GPA,
    CASE 
        WHEN Weekly_GenAI_Hours < 5 THEN 'Low'
        WHEN Weekly_GenAI_Hours BETWEEN 5 AND 25 THEN 'Moderate'
        ELSE 'Heavy'
    END AS ai_usage
FROM ai_student_impact_dataset
)
SELECT 
    ai_usage, 
    ROUND(AVG(Post_Semester_GPA) - AVG(Pre_Semester_GPA), 2) AS gpa_change, 
    COUNT(*) AS total_students
FROM ai_gpa
GROUP BY ai_usage
ORDER BY gpa_change DESC;

-- Query 1.5: Do heavy AI users have lower skill retention scores? (single table version)
-- FINDING: Heavy AI use is associated with the lowest skill retention, while moderate
--          use shows the highest.
WITH ai_skills AS 
( 
SELECT 
    Skill_Retention_Score,
    CASE 
        WHEN Weekly_GenAI_Hours < 5 THEN 'Low'
        WHEN Weekly_GenAI_Hours BETWEEN 5 AND 25 THEN 'Moderate'
        ELSE 'Heavy'
    END AS ai_usage
FROM ai_student_impact_dataset
)
SELECT 
    ai_usage, 
    ROUND(AVG(Skill_Retention_Score), 2) AS avg_skill_retention
FROM ai_skills
GROUP BY ai_usage
ORDER BY avg_skill_retention DESC;

-- Query 1.6: How do AI usage and study habits differ between students whose GPA
--            improved vs declined? (single table version)
-- FINDING: Students with a negative GPA change show slightly higher AI usage and
--          lower traditional study hours.
WITH gpa_change AS  
(
SELECT 
    Traditional_Study_Hours, 
    Weekly_GenAI_Hours,
    Skill_Retention_Score,
    CASE 
        WHEN Post_Semester_GPA - Pre_Semester_GPA < 0 THEN 'Negative'
        ELSE 'Positive'
    END AS outcome
FROM ai_student_impact_dataset
)
SELECT 
    outcome, 
    ROUND(AVG(Traditional_Study_Hours), 2) AS avg_study_hours, 
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours,
    ROUND(AVG(Skill_Retention_Score), 2) AS avg_skill_retention
FROM gpa_change
GROUP BY outcome
ORDER BY avg_ai_hours DESC;

-- Query 1.7: Burnout risk level (single table)
-- FINDING: High burnout risk correlates with heavy weekly AI hours and higher
--          dependency scores. This is an association, not proof that academic
--          pressure causes tool reliance.
SELECT 
    Burnout_Risk_Level AS burnout_level,
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Anxiety_Level_During_Exams), 2) AS avg_exam_anxiety,
    ROUND(AVG(Perceived_AI_Dependency), 2) AS avg_ai_dependency
FROM ai_student_impact_dataset
GROUP BY Burnout_Risk_Level
ORDER BY avg_ai_hours DESC;

-- Query 1.8: Policy effect (single table)
-- FINDING: Strict campus bans do not eliminate usage; instead, they correlate with
--          the highest exam anxiety and perceived tool dependency.
SELECT 
    Institutional_Policy AS policy,
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Anxiety_Level_During_Exams), 2) AS avg_exam_anxiety,
    ROUND(AVG(Perceived_AI_Dependency), 2) AS avg_ai_dependency,
    COUNT(*) AS total_students
FROM ai_student_impact_dataset
GROUP BY Institutional_Policy
ORDER BY avg_ai_hours DESC;

-- Query 1.9: Usage effect (single table)
-- FINDING: Students using AI for automated tasks like writing assignments log the
--          highest weekly hours and show the highest dependency scores.
SELECT 
    Primary_Use_Case AS use_case,
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Anxiety_Level_During_Exams), 2) AS avg_exam_anxiety,
    ROUND(AVG(Perceived_AI_Dependency), 2) AS avg_ai_dependency,
    COUNT(*) AS total_students
FROM ai_student_impact_dataset
GROUP BY Primary_Use_Case
ORDER BY avg_ai_hours DESC;


-- ==============================================================================
-- PHASE 2: RELATIONAL DATABASE ANALYSIS (MULTI-TABLE JOINS)
-- Description: Transitioning to queries using separated normalized tables 
--              (ai_usage, wellbeing_info, students_info) to demonstrate multi-key joining capability.
-- ==============================================================================

-- Query 2.1: Are burnout risk and anxiety related to AI usage?
-- FINDING: Students with higher burnout risk tend to use AI significantly more,
--          suggesting a relationship worth exploring further rather than a direct cause.
SELECT 
    wb.Burnout_Risk_Level AS burnout_level, 
    ROUND(AVG(wb.Anxiety_Level_During_Exams), 2) AS avg_exam_anxiety, 
    ROUND(AVG(au.Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(au.Perceived_AI_Dependency), 2) AS avg_ai_dependency 
FROM ai_usage AS au
JOIN wellbeing_info AS wb
	ON au.Student_ID = wb.Student_ID    
GROUP BY wb.Burnout_Risk_Level
ORDER BY avg_ai_hours DESC;

-- Query 2.2: How do AI usage and study habits differ between students whose GPA
--            improved vs declined? (joins version)
-- FINDING: Negative academic outcomes correlate with higher total AI usage combined
--          with lower traditional study time.
WITH gpa_change AS 
(
SELECT 
    si.Pre_Semester_GPA, 
    si.Post_Semester_GPA, 
    wb.Anxiety_Level_During_Exams, 
    au.Weekly_GenAI_Hours, 
    si.Traditional_Study_Hours,
    CASE
        WHEN si.Post_Semester_GPA - si.Pre_Semester_GPA < 0 THEN 'Negative'
        ELSE 'Positive'
    END AS outcome
FROM ai_usage AS au
JOIN wellbeing_info AS wb
	ON au.Student_ID = wb.Student_ID    
JOIN students_info AS si
	ON si.Student_ID = au.Student_ID
 )   
SELECT 
    outcome, 
    ROUND(AVG(Anxiety_Level_During_Exams), 2) AS avg_exam_anxiety, 
    ROUND(AVG(Weekly_GenAI_Hours), 2) AS avg_ai_hours, 
    ROUND(AVG(Traditional_Study_Hours), 2) AS avg_study_hours
FROM gpa_change
GROUP BY outcome
ORDER BY avg_ai_hours DESC;

-- Query 2.3: Do heavy AI users have lower skill retention scores? (with a join)
-- FINDING: High-volume AI interaction is associated with a sharp drop-off in skill
--          retention, consistent with the idea that over-reliance may impede
--          independent learning (correlation, not proven causation).
WITH skill_table AS
(
SELECT 
    au.Weekly_GenAI_Hours, 
    si.Skill_Retention_Score,
    CASE
        WHEN au.Weekly_GenAI_Hours < 5 THEN 'Low'
        WHEN au.Weekly_GenAI_Hours BETWEEN 5 AND 25 THEN 'Moderate'
        ELSE 'Heavy'
    END AS usage_category
FROM students_info AS si
JOIN ai_usage AS au
	ON si.Student_ID = au.Student_ID 
)
SELECT 
    usage_category, 
    ROUND(AVG(Skill_Retention_Score), 2) AS avg_skill_retention
FROM skill_table
GROUP BY usage_category
ORDER BY avg_skill_retention DESC;

-- ==============================================================================
-- PHASE 3: WINDOW FUNCTION ANALYSIS (RANKING, QUARTILES, GROUP BENCHMARKS)
-- Description: Applying window functions to rank within groups, segment the 
--              population into data-driven quartiles, and benchmark individuals 
--              against their peer-group averages without collapsing rows.
-- ==============================================================================

-- Query 3.1: Within each major, who are the top 3 students by GPA improvement?
-- FINDING: Surfaces the strongest GPA gainers within each major individually. Ranking
--          is reset per major via PARTITION BY, isolating top performers on a
--          per-group basis rather than across the full population.
WITH ranks AS 
(
SELECT Student_ID, Major_Category, Year_of_Study,
Post_Semester_GPA - Pre_Semester_GPA AS gpa_change,
ROW_NUMBER() OVER(PARTITION BY Major_Category ORDER BY Post_Semester_GPA - Pre_Semester_GPA DESC) AS ranking
FROM students_info
)
SELECT * 
FROM ranks
WHERE ranking <= 3;

-- Query 3.2: Splitting students into four equal groups (quartiles) by AI usage,
--            does the GPA and wellbeing pattern hold across the full range?
-- FINDING: As AI usage rises from the lowest to the highest quartile, perceived
--          dependency more than doubles and traditional study hours decline, while
--          paid-subscription share flips from minority to majority. GPA change stays
--          relatively flat across quartiles, a more nuanced result than the earlier
--          hand-set Low/Moderate/Heavy buckets suggested.
WITH groups_by_usage AS
(
SELECT 
NTILE(4) OVER(ORDER BY Weekly_GenAI_Hours ASC) AS usage_groups,
Weekly_GenAI_Hours,
Perceived_AI_Dependency,
Tool_Diversity,
Paid_Subscription,
Traditional_Study_Hours,
Anxiety_Level_During_Exams,
(si.Post_Semester_GPA - si.Pre_Semester_GPA) AS gpa_change
FROM ai_usage AS au
JOIN students_info AS si
	ON si.Student_ID = au.Student_ID
JOIN wellbeing_info AS wb
	ON au.Student_ID = wb.Student_ID
)
SELECT AVG(Weekly_GenAI_Hours),
AVG(Perceived_AI_Dependency),
AVG(Tool_Diversity),
SUM(CASE WHEN Paid_Subscription = 'TRUE' THEN 1 ELSE 0 END) AS paid_yes,
SUM(CASE WHEN Paid_Subscription = 'FALSE' THEN 1 ELSE 0 END) AS paid_no,
AVG(Traditional_Study_Hours),
AVG(Anxiety_Level_During_Exams),
AVG(gpa_change)
FROM groups_by_usage
GROUP BY usage_groups
;

-- Query 3.3: Which students use AI more than the average for their own major?
-- FINDING: Benchmarks each student against their own major's average weekly AI usage
--          using AVG() OVER (PARTITION BY major), flagging within-group outliers
--          rather than measuring against a single global mean.
WITH usage_table AS
(
SELECT si.Student_ID, Major_Category, Weekly_GenAI_Hours, AVG(Weekly_GenAI_Hours) OVER(PARTITION BY Major_Category) avg_Weekly_GenAI_Hours, Year_of_Study, 
Post_Semester_GPA - Pre_Semester_GPA AS gpa_change
FROM students_info si
JOIN ai_usage au
	ON si.Student_ID = au.Student_ID
)
SELECT * 
FROM usage_table
WHERE Weekly_GenAI_Hours > avg_Weekly_GenAI_Hours
;
