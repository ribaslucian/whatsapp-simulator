/*ALTER TABLE people
ADD CONSTRAINT rule_constraint_people_check_cpf
CHECK (
	cpf ~* '^([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})$'
);*/

CREATE EXTENSION pgcrypto;
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE DOMAIN cpf AS VARCHAR(14) CHECK (VALUE ~* '^([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})$');
CREATE DOMAIN cnpj AS VARCHAR(18) CHECK (VALUE ~* '^([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})$');
