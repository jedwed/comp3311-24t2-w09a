-- Q14
CREATE OR REPLACE FUNCTION unitName(_ouid integer) RETURNS text AS $$
DECLARE
    _orgtype text;
    _basename text;
BEGIN
    SELECT 
        ot.name, o.longname
    INTO
        _orgtype, _basename
    FROM
        orgunittype AS ot
    JOIN
        orgunit AS o
        ON ot.id = o.utype
    WHERE
        o.id = _ouid;

    IF NOT found THEN
        RETURN 'ERROR: No such unit: ' || _ouid;
    END IF;

    -- NOTE: incomplete, but the other organisation types should be pretty straightforward to complete
    IF _orgtype = 'University' THEN
        RETURN 'UNSW';
    ELSIF _orgtype = 'Faculty' THEN
        RETURN  _basename;
    ELSIF _orgtype = 'School' THEN
        RETURN 'School of ' || _basename;
    ELSE
        RETURN NULL;
    END IF;
END
$$ language plpgsql;

-- Q15
CREATE OR REPLACE FUNCTION unitID(partName text) RETURNS integer AS $$
    SELECT 
        o.id
    FROM
        orgunit as o
    WHERE
        o.longname ILIKE '%' || partName || '%';
$$ language sql;


-- Q16
CREATE OR REPLACE FUNCTION facultyOf(_ouid integer) RETURNS integer AS $$
DECLARE
    _parentId integer;
    _oType text;
BEGIN
    -- Base case
    IF _ouid IS NULL THEN
        RETURN NULL;
    END IF;

    SELECT
        ot.name
    INTO
        _oType
    FROM
        orgunittype AS ot
    JOIN
        orgunit AS o
        ON ot.id = o.utype
    WHERE
        o.id = _ouid;

    -- Base case
    IF _oType = 'Faculty' THEN
        RETURN _ouid;
    END IF;

    SELECT 
        owner
    INTO
        _parentId
    FROM
        unitgroups
    WHERE
        member = _ouid;
    
    -- Recursion :O
    RETURN facultyOf(_parentId);
    
END
$$ language plpgsql;
