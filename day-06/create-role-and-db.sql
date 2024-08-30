-- Create groups 
CREATE ROLE lkddb NOLOGIN noinherit;
CREATE ROLE lkddb_owner LOGIN password '1234' IN ROLE lkddb;
CREATE ROLE lkddb_app_group NOLOGIN IN ROLE lkddb;
CREATE ROLE lkddb_developer_group NOLOGIN IN ROLE lkddb;
CREATE ROLE lkddb_readonly_group NOLOGIN IN ROLE lkddb;


-- Create database
CREATE DATABASE lkddb  TEMPLATE = template0 ENCODING = 'UTF8' OWNER = lkddb_owner;
GRANT CONNECT, TEMP ON DATABASE lkddb TO lkddb;
REVOKE CONNECT, TEMP ON DATABASE lkddb FROM PUBLIC;


-- Connect to new database
\c lkddb 

-- Arrange permissions
ALTER SCHEMA public OWNER TO lkddb_owner;
REVOKE CREATE,USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO lkddb ;


-- Create default privileges
ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lkddb_app_group, lkddb_developer_group;

ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT SELECT, UPDATE ON SEQUENCES TO lkddb_app_group, lkddb_developer_group;

ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT EXECUTE ON FUNCTIONS TO lkddb_app_group, lkddb_developer_group;

ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT USAGE ON TYPES TO lkddb_app_group, lkddb_developer_group;

ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT USAGE ON SCHEMAS TO lkddb_app_group, lkddb_developer_group;
-------------------------------------------------------------------------------------------------
-- Create default readonly privileges
ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT SELECT ON TABLES TO lkddb_readonly_group;
ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT USAGE ON TYPES TO lkddb_readonly_group;
ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT USAGE ON SCHEMAS TO lkddb_readonly_group;
ALTER DEFAULT PRIVILEGES FOR ROLE lkddb_owner GRANT SELECT ON SEQUENCES TO lkddb_readonly_group;


--Grant privileges  existing relations
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO lkddb_app_group, lkddb_developer_group;
GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public  TO lkddb_app_group, lkddb_developer_group;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO lkddb_app_group, lkddb_developer_group;
GRANT USAGE ON SCHEMA public TO lkddb_app_group, lkddb_developer_group;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO lkddb_readonly_group;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public  TO lkddb_readonly_group;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO lkddb_readonly_group;
GRANT USAGE ON SCHEMA public TO lkddb_readonly_group;



CREATE ROLE lkddb_app_user password '1234' login in role lkddb_app_group;
CREATE ROLE lkddb_dev_user password '1234' login in role lkddb_developer_group;
CREATE ROLE lkddb_readonly_user password '1234' login in role lkddb_readonly_group;