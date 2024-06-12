CREATE TABLE team (
    name varchar(50) PRIMARY KEY,
);

CREATE TABLE player (
    name varchar(50) PRIMARY KEY,
    team varchar(50) NOT NULL REFERENCES team (name)
);

ALTER TABLE team ADD FOREIGN KEY (captain) REFERENCES players (name);
