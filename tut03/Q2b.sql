CREATE TABLE teacher (
    staffNo integer PRIMARY KEY
);

CREATE TABLE subject (
    subjectCode char(8),
    PRIMARY KEY (subjectCode)
);

CREATE TABLE teaches (
    teacher integer REFERENCES teacher (staffNo),
    subject char(8) REFERENCES subject (subjectCode),
    PRIMARY KEY (teacher, subject)
);
