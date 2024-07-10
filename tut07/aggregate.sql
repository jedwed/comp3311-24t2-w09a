CREATE OR REPLACE FUNCTION my_sum(curr_state numeric, curr_value numeric) 
RETURNS numeric AS $$
BEGIN
    RETURN curr_state + curr_value;
END
$$ LANGUAGE plpgsql;

CREATE AGGREGATE my_sum ( numeric ) (
    SFUNC = my_sum,
    STYPE = numeric,
    INITCOND = 0
);

CREATE TYPE my_state AS ( my_sum numeric, my_count numeric );

CREATE OR REPLACE FUNCTION my_average (curr_state my_state, curr_value numeric)
RETURNS my_state AS $$
BEGIN
    curr_state.my_sum := curr_state.my_sum + curr_value;
    curr_state.my_count := curr_state.my_count + 1;
    RETURN curr_state;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION finalise (final_state my_state) RETURNS numeric AS $$
BEGIN
    RETURN final_state.my_sum / final_state.my_count;
END
$$ LANGUAGE plpgsql;

CREATE AGGREGATE my_average ( numeric ) (
    SFUNC = my_average,
    STYPE = my_state,
    INITCOND = '(0,0)',
    FINALFUNC = finalise
);
