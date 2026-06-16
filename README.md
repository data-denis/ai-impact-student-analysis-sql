# AI Impact on Students: SQL Analysis

For my SQL analysis project, I decided to examine how generative AI usage among college students affects their GPAs, their retention of knowledge, and their mental wellbeing. The topic is relevant, and there are quite a few debates going on right now, with no real consensus on whether the technology is useful for students or not.

The short summary: less is not necessarily better here. Students who use AI moderately have the most positive changes in GPA. At the same time, excessive usage is negatively correlated with GPA and associated with worse skill retention and higher dependency.

## The data

I used the [Impact of AI on Students](https://www.kaggle.com/datasets/laveshjadon/ai-impact-on-students) dataset, sourced from Kaggle. It contains 50,000 observations of various student characteristics, including AI use, study hours, GPA before and after the semester, the AI policies of their respective schools, and wellbeing factors such as anxiety and dependency.

I worked with the dataset in its original raw form and split it into three tables: one containing student information (students_info), one with AI usage details (ai_usage), and one related to wellbeing (wellbeing_info).

## Tools

MySQL, written and run in MySQL Workbench.

## Files included in this repository

- `01_schema_setup.sql` creates the tables and fills them from the original flat file dataset
- `02_ai_impact_discovery.sql` holds the analysis queries, from simple exploration up to window functions
- `README.md` is this file

## What I did

To build the analysis, I went through the process step by step, increasing the difficulty as I went:

First, I created the schema, splitting the original flat file into three tables and linking them by a common field (Student_ID). One table was the primary table, and the other two referenced it.

Second, I explored the data with grouping, CASE WHEN statements, and CTEs to find the general patterns in GPA change, skill retention, dependency, and other metrics, broken down by the students' major, the AI policy of their university, and so on.

Third, I asked the same types of questions, but this time using joins across multiple tables.

Fourth, I added window functions, such as ranking students within their major, calculating usage quartiles, and comparing each individual's values against the average for their major.

Every query has a descriptive comment above it with the question it answers, so the script reads top to bottom on its own.

## Results

Moderate AI use correlates positively with GPA change. Heavy AI use, on the other hand, correlates negatively. The right amount of AI assistance seems to help, but too much of it hurts.

Heavier AI use also correlates with lower skill retention, which fits the idea that leaning on the tool too much gets in the way of actually learning the material. This is a correlation, not proof of cause.

Schools that banned AI did not stop students from using it. Students at those schools still reported using AI, and those same schools showed the highest exam anxiety and the highest perceived dependency, which suggests bans may not be doing what they are meant to.

Splitting students into four equal groups by AI usage made the pattern clearer. Going from the lowest usage group to the highest, perceived dependency more than doubled (from roughly 2.5 to 5.2), traditional study hours dropped (from roughly 11.9 to 10.1), and paid subscriptions went from the minority to the majority of the group.

## What I would do next

I would build a Tableau dashboard from these query results to show the quartile and major level patterns visually, and I would check whether the relationship between AI use and GPA still holds after accounting for where each student started GPA wise.
