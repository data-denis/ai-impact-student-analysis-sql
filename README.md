# AI Impact on Students - SQL Analysis

In this project I used SQL to look at how college students' use of generative AI tools (ChatGPT, Copilot, Gemini) relates to their grades, how much they actually retain, and their mental wellbeing. I wanted to see whether more AI use actually helps students or not, since that question keeps coming up and the answer isn't obvious.

The short version: more AI is not automatically better. Students with moderate use had the best GPA change, heavy users had the worst, and heavy use also lined up with the lowest skill retention and the highest dependency.

## The data

I used the [Impact of AI on Students](https://www.kaggle.com/datasets/laveshjadon/ai-impact-on-students) dataset from Kaggle. It has 50,000 student records covering AI usage, study habits, pre and post semester GPA, school AI policy, and wellbeing scores like exam anxiety and burnout.

I started with the raw flat file, then split it into three tables keyed on Student_ID (students_info, ai_usage, wellbeing_info) so I could practice joins on top of the exploratory work.

## Tools

MySQL, written and run in MySQL Workbench.

## Files in this repo

- `01_schema_setup.sql` - creates the three tables and fills them from the raw flat file
- `02_ai_impact_discovery.sql` - the full analysis, from basic exploration to window functions
- `README.md` - this file

## What I did

I built the project in stages that get progressively harder:

- First I set up the schema, splitting the raw flat file into three tables linked by Student_ID, with one primary key table and two that reference it.
- Then I explored the raw data with grouping, CASE statements, and CTEs to get the big-picture trends by major, school policy, year, and usage level.
- Then I rewrote the same kinds of questions across the three joined tables to show multi-table joins.
- Last I added window functions: ranking students within their major, splitting everyone into usage quartiles, and comparing each student to their own major's average.

Every query has a comment above it with the question it answers and what I found, so the file reads top to bottom on its own.

## What I found

- Moderate AI users had the best GPA change. Heavy users had the worst. Some help is good, too much isn't.
- Heavy AI users had the lowest skill retention, which fits the idea that leaning on the tool too hard gets in the way of actually learning. This is a correlation, not proof.
- Schools that banned AI didn't stop students from using it, and those schools had the highest exam anxiety and the highest perceived dependency.
- When I split students into four groups by AI usage, the pattern got clearer. From the lowest to highest usage group, perceived dependency more than doubled (about 2.5 to 5.2), study hours dropped (about 11.9 to 10.1), and paid subscriptions went from the minority to the majority.

## What I'd do next

- Build a Tableau dashboard from these query results to show the quartile and major-level patterns visually
- Check whether the AI-vs-GPA pattern still holds after accounting for where students started GPA-wise
