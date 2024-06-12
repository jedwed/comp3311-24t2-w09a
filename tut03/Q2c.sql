CREATE TABLE teacher (
    staffNo integer PRIMARY KEY
);

CREATE TABLE subject (
    subjectCode char(8) PRIMARY KEY,
    teacher integer NOT NULL REFERENCES teacher (staffNo)
);
