CREATE OR REPLACE VIEW student_courses (student_id, student_family, student_given, subject_code, subject_name, course_term) AS 
    SELECT
        stu.id,
        p.family,
        p.given,
        s.code,
        s.name,
        t.code
    FROM
        subjects AS s
    JOIN
        courses AS c
        ON s.id = c.subject
    JOIN
        course_enrolments AS ce
        ON c.id = ce.course
    JOIN
        students AS stu
        ON ce.student = stu.id
    JOIN
        people AS p
        ON stu.id = p.id
    JOIN
        terms AS t
        ON c.term = t.id;
        
