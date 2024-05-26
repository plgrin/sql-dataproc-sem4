--Install the required extension
CREATE EXTENSION postgres_fdw;

--Set up a foreign server
CREATE SERVER same_server_postgres
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (dbname 'db_two');

--Create a user mapping
CREATE USER MAPPING FOR CURRENT_USER
SERVER same_server_postgres
OPTIONS (USER 'postgres', password 'postgreuser29');


--Define a foreign table to access the 'remote_table'
CREATE FOREIGN TABLE local_remote_table (
   id INTEGER,
   name VARCHAR(255),
   age INTEGER)
SERVER same_server_postgres
OPTIONS (schema_name 'public', TABLE_NAME 'remote_table');

-- Data Manipulation Language (DML) operations on the foreign table
SELECT * FROM local_remote_table;
INSERT INTO local_remote_table (id, name, age) VALUES (4, 'Dasha Delbano', 18);
UPDATE local_remote_table SET age = 19 WHERE name = 'Polina Grin';
DELETE FROM local_remote_table WHERE name = 'Georgii Bachilo';
