# Phase 2 Database Implementation

This directory contains the database deliverables and demo SQL for Phase 2 of our KPI Tracking System.

## Files Included
- `kpi_tracking_db.sql`: The complete SQL script containing:
  - DDL statements (Table Definitions, Relational ISA Mapping & `NUMERIC(15,2)` constraints)
  - DML statements (Synthetic Data Generation & Cascading Hierarchy Population)
  - Demo Queries (INSERT, UPDATE, DELETE, and complex SELECT JOINs)

## Setup Instructions
To run this project locally on your machine and practice the demo, follow these exact steps:

1. **Start PostgreSQL**: Make sure you have PostgreSQL installed and running on the standard default port `5432`.
   - On a Mac (via Homebrew): `brew services start postgresql@15`
   - Alternatively, you can just launch **Postgres.app** if you use it.

2. **Create the Demo Database**: Open your terminal and run:
   ```bash
   createdb phase2_demo
   ```

3. **Connect to the Database**: 
   ```bash
   psql -p 5432 -d phase2_demo
   ```

## Running the Demo & Testing Queries
Once you are inside the native `psql` console (you will see the `phase2_demo=#` prompt), you can copy and paste the sections from `kpi_tracking_db.sql` sequentially:

1. **Step 1 - Schema Setup**: Paste the entire top DDL section. Verify the tables were cleanly created by executing:
   ```sql
   \d goal
   \d employeegoal
   ```
2. **Step 2 - Synthesize Data**: Paste the DML INSERT section to cascade the mock dataset into the tables. Verify it with:
   ```sql
   SELECT * FROM company;
   SELECT * FROM employee;
   ```
3. **Step 3 - Demo Scenarios**: Run the 5 unique queries from the bottom section (e.g., INSERT, UPDATE, DELETE, and the two multi-table JOINs for viewing the hierarchical goal tree logic).

### Troubleshooting / Resetting
- If your `createdb` command fails because your terminal is configured to look for a non-standard port (like `8888`), explicitly append the standard port flag to the command: `createdb -p 5432 phase2_demo`.
- If you make a mistake during practice, simply copy the `DROP TABLE ... CASCADE;` block from the very top of the `.sql` file, run it in the console, and it will cleanly wipe the database so you can start over from Step 1!
