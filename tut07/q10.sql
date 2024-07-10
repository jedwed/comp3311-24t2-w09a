CREATE TABLE student (
    sid integer,
    name text,
    PRIMARY KEY (sid)
);

CREATE TABLE course (
    code char(8),
    lic text,
    quota integer,
    numStudents integer DEFAULT 0,
    PRIMARY KEY (code)
);

CREATE TABLE enrolment (
    course char(8),
    sid integer,
    PRIMARY KEY (course, sid),
    FOREIGN KEY (course) REFERENCES Course(code),
    FOREIGN KEY (sid) REFERENCES Student(sid)
);

CREATE OR REPLACE FUNCTION num_students_insertion_update() RETURNS TRIGGER AS $$
BEGIN
    UPDATE
        course
    SET
        numStudents = numStudents + 1
    WHERE
        code = NEW.course;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER num_students_insertion_check
    AFTER INSERT
    ON enrolment
    FOR EACH ROW
    EXECUTE FUNCTION num_students_insertion_update();
    

-- Assertion to ensure the numStudents field in each course is equal to
-- the number of enrolments in that course
-- CREATE ASSERTION num_students_check CHECK (
--     NOT EXISTS (
--         SELECT
--             *
--         FROM
--             course AS c
--         WHERE
--             numStudents <> (
--                 SELECT 
--                     count(*)
--                 FROM
--                     enrolment
--                 WHERE
--                     course = c.code
--             )
--     )
-- );

-- Sample data for testing
insert into Course values ('COMP1511', 'Jake Renzella', 1000);
insert into Course values ('COMP1531', 'Hayden Smith' , 1000);
insert into Course values ('COMP3311', 'Yuekang Li'   , 1000);

insert into Student values (0, 'John Smith'   );
insert into Student values (1, 'John Doe'     );
insert into Student values (2, 'Daniel Jacobs');
