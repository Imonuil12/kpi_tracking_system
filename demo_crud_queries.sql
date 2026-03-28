-- ==========================================
-- 3. SQL CRUD & Join Queries (Demo)
-- Author: Alec Fishbach
-- Purpose: Demonstration of basic CRUD operations
--          and multi-table joins for KPI tracking system
-- Date: 2026-03-27
-- ==========================================

-- A. INSERT Query (Insert Goal + Subclass link)
-- Inserting a new Employee Goal for Alice
INSERT INTO Goal (name, unitOfMeasure, status, targetValue, currentValue, startDate, endDate) 
VALUES ('Redesign UI Layout', 'Percent', 'In Progress', 100.00, 10.00, '2026-03-01', '2026-05-31');
-- Note: In PostgreSQL, if we assume the new goal was 6 based on sequence:
INSERT INTO EmployeeGoal (goalID, smartGoal, employeeID) 
VALUES ((SELECT MAX(goalID) FROM Goal), 'Ensure new accessibility standards are met.', 1);


-- B. UPDATE Query
-- Update current value and status of an existing Goal


-- Show the update works as intended
-- SELECT goalID, name, status, targetValue, currentValue
-- FROM Goal
-- WHERE goalID = 2;

UPDATE Goal 
SET currentValue = 120.00, status = 'Achieved'
WHERE goalID = 2;


-- C. DELETE Query
-- Delete Diana Prince since she doesn't belong to a team yet
DELETE FROM Employee 
WHERE email = 'diana@globex.com';


-- D. SELECT Query 1: (Joining Goal, TeamGoal, and Team)
-- Retrieve all Team Goals, their progress, and the responsible Team name
SELECT 
    t.name AS TeamName, 
    g.name AS GoalName, 
    g.status, 
    g.currentValue, 
    g.targetValue, 
    g.unitOfMeasure
FROM TeamGoal tg
JOIN Goal g ON tg.goalID = g.goalID
JOIN Team t ON tg.teamID = t.teamID;


-- E. SELECT Query 2: (Multilevel JOIN: Employee to Department)
-- List all Employees and their respective Department Names
SELECT 
    e.firstName, 
    e.lastName, 
    t.name AS TeamName, 
    d.name AS DepartmentName
FROM Employee e
LEFT JOIN Team t ON e.teamID = t.teamID
LEFT JOIN Department d ON t.depID = d.depID
ORDER BY d.name, t.name;
