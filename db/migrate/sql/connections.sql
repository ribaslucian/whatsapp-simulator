CREATE OR REPLACE FUNCTION rule_trigger_bi_connections() RETURNS TRIGGER
AS $$ BEGIN
	NEW.date_expiration := (now() + INTERVAL '4 hours');
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS rule_trigger_bi_connections ON connections;
CREATE TRIGGER rule_trigger_bi_connections
BEFORE INSERT ON connections
FOR EACH ROW EXECUTE PROCEDURE rule_trigger_bi_connections();
