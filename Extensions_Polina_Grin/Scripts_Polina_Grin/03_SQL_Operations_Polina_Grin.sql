--SQL operations on the "employees" table
SELECT * FROM employees;

UPDATE employees SET last_name = 'Ivanova' WHERE email = 'grin.polina@student.ehu.lt';

DELETE FROM employees WHERE email = 'grin.polina@student.ehu.lt';

SELECT * FROM pg_stat_statements;