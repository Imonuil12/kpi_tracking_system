-- ==========================================
-- PHASE 2: ER-to-Relational, Data, & Queries
-- ==========================================

-- Clean up existing tables (for safe re-running)
DROP TABLE IF EXISTS EmployeeGoal CASCADE;
DROP TABLE IF EXISTS TeamGoal CASCADE;
DROP TABLE IF EXISTS DepartmentGoal CASCADE;
DROP TABLE IF EXISTS CompanyGoal CASCADE;
DROP TABLE IF EXISTS Goal CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Team CASCADE;
DROP TABLE IF EXISTS Department CASCADE;
DROP TABLE IF EXISTS Company CASCADE;

-- ==========================================
-- 1. ER-to-Relational Mapping (DDL)
-- ==========================================

CREATE TABLE Company (
    companyID SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mainAddress VARCHAR(500)
);

CREATE TABLE Department (
    depID SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    companyID INT NOT NULL,
    FOREIGN KEY (companyID) REFERENCES Company(companyID) ON DELETE CASCADE
);

CREATE TABLE Team (
    teamID SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    depID INT NOT NULL,
    FOREIGN KEY (depID) REFERENCES Department(depID) ON DELETE CASCADE
);

CREATE TABLE Employee (
    employeeID SERIAL PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    teamID INT,
    FOREIGN KEY (teamID) REFERENCES Team(teamID) ON DELETE SET NULL
);

-- Superclass Goal
CREATE TABLE Goal (
    goalID SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    unitOfMeasure VARCHAR(50),
    status VARCHAR(50),
    targetValue NUMERIC(15, 2),
    currentValue NUMERIC(15, 2),
    startDate DATE,
    endDate DATE
);

-- Subclasses of Goal (ISA mapped as separate relations linked by PK=FK)
CREATE TABLE CompanyGoal (
    goalID INT PRIMARY KEY,
    strategy TEXT,
    companyID INT NOT NULL,
    FOREIGN KEY (goalID) REFERENCES Goal(goalID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES Company(companyID) ON DELETE CASCADE
);

CREATE TABLE DepartmentGoal (
    goalID INT PRIMARY KEY,
    budget NUMERIC(15, 2),
    depID INT NOT NULL,
    FOREIGN KEY (goalID) REFERENCES Goal(goalID) ON DELETE CASCADE,
    FOREIGN KEY (depID) REFERENCES Department(depID) ON DELETE CASCADE
);

CREATE TABLE TeamGoal (
    goalID INT PRIMARY KEY,
    teamID INT NOT NULL,
    FOREIGN KEY (goalID) REFERENCES Goal(goalID) ON DELETE CASCADE,
    FOREIGN KEY (teamID) REFERENCES Team(teamID) ON DELETE CASCADE
);

CREATE TABLE EmployeeGoal (
    goalID INT PRIMARY KEY,
    smartGoal TEXT,
    employeeID INT NOT NULL,
    FOREIGN KEY (goalID) REFERENCES Goal(goalID) ON DELETE CASCADE,
    FOREIGN KEY (employeeID) REFERENCES Employee(employeeID) ON DELETE CASCADE
);

-- ==========================================
-- 2. Fill in the database with data (DML)
-- ==========================================

INSERT INTO Company (name, mainAddress) VALUES 
('Acme Corp', '123 Acme Way, Metropolis'),
('Globex', '456 Globex Road, Star City');

INSERT INTO Department (name, location, companyID) VALUES 
('Engineering', 'Floor 2', 1),
('Sales', 'Floor 1', 1),
('Marketing', 'Remote', 2);

INSERT INTO Team (name, depID) VALUES 
('Frontend Team', 1),
('Backend Team', 1),
('Enterprise Sales', 2);

INSERT INTO Employee (firstName, lastName, email, teamID) VALUES 
('Alice', 'Smith', 'alice@acme.com', 1),
('Bob', 'Jones', 'bob@acme.com', 2),
('Charlie', 'Brown', 'charlie@acme.com', 3),
('Diana', 'Prince', 'diana@globex.com', NULL);

-- Generate Goals and Subclass mappings
-- Company Goal
INSERT INTO Goal (name, unitOfMeasure, status, targetValue, currentValue, startDate, endDate) VALUES 
('Increase Q3 Revenue', 'USD', 'In Progress', 1000000.00, 450000.00, '2026-07-01', '2026-09-30');
INSERT INTO CompanyGoal (goalID, strategy, companyID) VALUES (1, 'Aggressive Market Expansion', 1);

-- Department Goal
INSERT INTO Goal (name, unitOfMeasure, status, targetValue, currentValue, startDate, endDate) VALUES 
('Launch New Product API', 'Percent', 'On Track', 100.00, 60.00, '2026-01-01', '2026-06-30');
INSERT INTO DepartmentGoal (goalID, budget, depID) VALUES (2, 50000.00, 1);

-- Team Goal
INSERT INTO Goal (name, unitOfMeasure, status, targetValue, currentValue, startDate, endDate) VALUES 
('Reduce Server Latency', 'Milliseconds', 'Behind', 50.00, 120.00, '2026-02-01', '2026-05-01');
INSERT INTO TeamGoal (goalID, teamID) VALUES (3, 2);

-- Employee Goal
INSERT INTO Goal (name, unitOfMeasure, status, targetValue, currentValue, startDate, endDate) VALUES 
('Complete Auth Migration', 'Features', 'Not Started', 5.0, 0.0, '2026-04-01', '2026-04-30');
INSERT INTO EmployeeGoal (goalID, smartGoal, employeeID) VALUES (4, 'Specific: Migrate all auth. Measurable: 5 components.', 2);

-- Another Team Goal
INSERT INTO Goal (name, unitOfMeasure, status, targetValue, currentValue, startDate, endDate) VALUES 
('Close 10 Enterprise Deals', 'Deals', 'In Progress', 10.0, 3.0, '2026-01-01', '2026-12-31');
INSERT INTO TeamGoal (goalID, teamID) VALUES (5, 3);

-- ==========================================
-- 3. SQL Queries (Demo)
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
