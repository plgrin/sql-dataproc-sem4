--Create a sample table with some data:
CREATE TABLE remote_table (
id serial PRIMARY KEY,
name VARCHAR(255),
age INTEGER);
 
INSERT INTO remote_table (name, age) VALUES
('Polina Grin', 12),
('Anna Trukshanina', 15),
('Georgii Bachilo', 14);