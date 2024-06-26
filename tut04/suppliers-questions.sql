/*
 * Q12
 * Find the names of suppliers who supply some red part.
 */
SELECT
    DISTINCT sname
FROM 
    suppliers AS s
JOIN
    catalog AS c
    ON s.sid = c.sid
JOIN
    parts AS p
    ON c.pid = p.pid
WHERE
    p.colour = 'red';
    

/*
 * Q13
 * Find the sids of suppliers who supply some red or green part.
 */
SELECT
    DISTINCT sname
FROM 
    suppliers AS s
JOIN
    catalog AS c
    ON s.sid = c.sid
JOIN
    parts AS p
    ON c.pid = p.pid
WHERE
    p.colour = 'red' OR p.colour = 'green';

/*
 * Q14
 * Find the sids of suppliers who supply some red part or whose address is 221 Packer Street.
 */
SELECT
    DISTINCT sname
FROM 
    suppliers AS s
JOIN
    catalog AS c
    ON s.sid = c.sid
JOIN
    parts AS p
    ON c.pid = p.pid
WHERE
    p.colour = 'red' OR s.address = '221 Packer Street';

/*
 * NOTE: there is a lot of duplicated code in the above
 * Consider using SQL VIEWS to create abstractions that make the code
 * more readably: avoid the eyesore of multiple joins.
 */

/*
 * Q15
 * Find the sids of suppliers who supply some red part and some green part.
 *
 * NOTE: cannot simply change the above condition to p.colour = 'red' AND p.colour = 'green'
 * since a tuple cannot simultaneously have a colour of red and green. 
 * Must use set operation INTERSECT
 */


SELECT
    s.sname
FROM
    suppliers AS s
JOIN
    catalog AS c
    ON s.sid = c.sid
JOIN
    parts AS p
    ON c.pid = p.pid
WHERE
    p.colour = 'red'
INTERSECT
SELECT
    s.sname
FROM
    suppliers AS s
JOIN
    catalog AS c
    ON s.sid = c.sid
JOIN
    parts AS p
    ON c.pid = p.pid
WHERE
    p.colour = 'green';

/*
 * Q16
 * Find the sids of suppliers who supply every part.
 */

-- Suppliers who supply every part is logically equivalent to:
-- Suppliers for whomst there doesn't exist a part that they haven't supplied

SELECT 
    sid
FROM
    suppliers AS s
WHERE NOT EXISTS (
    -- Subquery for all pids that the current supplier doesn't supply
    SELECT 
        pid 
    FROM 
        parts
    EXCEPT
    SELECT 
        pid 
    FROM 
        catalog 
    WHERE 
        sid = s.sid
)


/*
 * Q22
 * Find the pids of the most expensive part(s) supplied by suppliers named "Yosemite Sham".
 */

SELECT
    pid
FROM
    catalog AS c
JOIN
    suppliers AS s
    ON c.sid = s.sid
WHERE
    s.sname = 'Yosemite Sham'
    AND cost = (
        -- Subquery for highest cost
        SELECT 
            MAX(cost)
        FROM
            catalog AS c
        JOIN
            suppliers AS s
            ON c.sid = s.sid
        WHERE
            s.sname = 'Yosemite Sham'
    );

-- NOTE: Using a auxiliary view to create an abstraction makes the code easier to read and write


CREATE VIEW yosemiteSupplies (pid, cost) AS
    SELECT
        c.pid, c.cost
    FROM
        catalog AS c
    JOIN
        suppliers AS s
        ON c.sid = s.sid
    WHERE
        s.sname = 'Yosemite Sham';


SELECT
    pid
FROM
    yosemiteSupplies
WHERE
    cost = (
        SELECT 
            MAX(cost) 
        FROM 
            yosemiteSupplies
    );

