/*
 * Q2 
 * A new government initiative to get more young people into work 
 * cuts the salary levels of all workers under 25 by 20%. 
 * Write an SQL statement to implement this policy change.
 */

-- Cut salary levels of workers under 25 by 20%

UPDATE 
    employees
SET
    salary = 0.8 * salary
WHERE
    age < 25;


/*
 * Q3
 * The company has several years of growth and high profits, 
 * and considers that the Sales department is primarily responsible for this. 
 * Write an SQL statement to give all employees in the Sales department a 10% pay rise.
 */

UPDATE
    employees
SET
    salary = 1.1 * salary
WHERE
    eid in (
        SELECT
            eid
        FROM
            worksIn
        JOIN
            departments
            ON worksIn.did = departments.did
        WHERE
            departments.dname = 'Sales'
    );

-- Employees in the sales department
-- SELECT
--     eid
-- FROM
--     worksIn
--     ON employees.eid = worksIn.eid
-- JOIN
--     departments
--     ON worksIn.did = departments.did;
-- WHERE
--     departments.dname = 'Sales';
