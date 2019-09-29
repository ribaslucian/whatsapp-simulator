CREATE OR REPLACE FUNCTION rule_trigger_bi_balances_no_repeat_uniq_identification() RETURNS trigger
AS $$ BEGIN
  IF (
          (SELECT COUNT(*)
          FROM identifications
          WHERE (type_acronym_id = 100001 OR type_acronym_id = 100002)
          AND value = NEW.value) > 0
  ) THEN
          RAISE EXCEPTION 'DOCUMENT ALREADY EXISTS';
          RETURN NULL;
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS rule_trigger_bi_balances_no_repeat_uniq_identification ON identifications;
CREATE TRIGGER rule_trigger_bi_balances_no_repeat_uniq_identification
BEFORE INSERT ON identifications
FOR EACH ROW EXECUTE PROCEDURE rule_trigger_bi_balances_no_repeat_uniq_identification();