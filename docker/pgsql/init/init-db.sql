do
$$
    begin
        if not exists (select * from pg_user where usename = 'neconomicon') then
            create role neconomicon;
        end if;
    end
$$
;
ALTER ROLE neconomicon WITH CREATEDB;
ALTER USER neconomicon WITH ENCRYPTED PASSWORD '12345';
SELECT 'CREATE DATABASE neconomicon_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'neconomicon_test')\gexec
GRANT ALL PRIVILEGES ON DATABASE neconomicon_test TO neconomicon;