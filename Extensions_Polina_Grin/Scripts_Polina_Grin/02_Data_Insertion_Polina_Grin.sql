--Insert sample employee data into the table.
INSERT INTO employees (first_name, last_name, email, encrypted_password) VALUES
   ('Dasha', 'Delbano', 'delbano.dasha@student.ehu.lt', crypt('pampampam', gen_salt('bf'))),
   ('Polina', 'Grin', 'grin.polina@student.ehu.lt', crypt('lololo', gen_salt('bf'))),
   ('Anna', 'Trukshanina', 'trukshanina.anna@student.ehu.lt', crypt('hihihi', gen_salt('bf')));
     
