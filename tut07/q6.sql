CREATE TABLE R(
    a int, 
    b int, 
    c text
    -- we want primary key (a, b)
);

CREATE OR REPLACE FUNCTION check_primary_key() RETURNS trigger AS $$
BEGIN
    -- NOT NULL constraint
    IF NEW.a IS NULL OR NEW.b IS NULL THEN
        RAISE EXCEPTION 'Primary key cannot be NULL';
    END IF;

    -- Handle case where update doesn't change primary key

    IF OLD.a = NEW.a AND OLD.b = NEW.b THEN
        RETURN NEW;
    END IF;

    -- Enforce primary keys aren't duplicated
    PERFORM
        *
    FROM
        R
    WHERE
        a = NEW.a
        AND b = NEW.b;

    IF found THEN 
        RAISE EXCEPTION 'Primary key must be unique';
    END IF;

    RETURN NEW; 
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER primary_key_check
    BEFORE INSERT OR UPDATE
    ON R
    FOR EACH ROW
    EXECUTE FUNCTION check_primary_key();
