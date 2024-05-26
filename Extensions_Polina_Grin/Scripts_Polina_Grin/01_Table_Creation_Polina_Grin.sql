--To install an extension
CREATE EXTENSION pg_stat_statements;

CREATE EXTENSION pgcrypto;

--Create a new table called "employees"
CREATE TABLE employees (
   id serial PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   email VARCHAR(255),
   encrypted_password TEXT
);