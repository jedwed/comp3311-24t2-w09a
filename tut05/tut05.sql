-- Q1
CREATE OR REPLACE FUNCTION sqr(num numeric) RETURNS numeric AS $$
BEGIN
    RETURN num * num;
END
$$ language plpgsql;

-- Q2
CREATE OR REPLACE FUNCTION spread (input text) RETURNS text AS $$
DECLARE
    res text := '';
BEGIN
    -- Loop through each character
    FOR index IN 1..LENGTH(input)
    LOOP
        res := res || SUBSTRING(input, index, 1) || ' ';
    END LOOP;
    return res;
END
$$ language plpgsql;

-- Q3
CREATE OR REPLACE FUNCTION seq(n integer) RETURNS setof integer AS $$
BEGIN
    FOR i IN 1..n
    LOOP
        RETURN NEXT i;
    END LOOP;
END
$$ language plpgsql;

-- Q4
CREATE OR REPLACE FUNCTION seq(lo int, hi int, inc int) RETURNS setof integer AS $$
BEGIN
    IF inc > 0 THEN
        FOR i IN lo..hi BY inc
        LOOP
            RETURN NEXT i;
        END LOOP;
    ELSIF inc < 0 THEN
        FOR i IN REVERSE lo..hi BY ABS(inc)
        LOOP
            RETURN NEXT i;
        END LOOP;
    END IF;
END
$$ language plpgsql;
