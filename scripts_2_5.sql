/* a. first one with 2 Gb and 1 datafile, tablespace should be named "uber​" */
CREATE TABLESPACE uber
DATAFILE '/u01/app/oracle/oradata/XE/uber.dbf' SIZE 2048M
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

/* Undo tablespace with 25Mb of space and 1 datafile*/

CREATE UNDO TABLESPACE undotbs_01
DATAFILE '/u01/app/oracle/oradata/XE/undo0101.dbf' SIZE 25M REUSE AUTOEXTEND ON;

/*c. Bigfile tablespace of 5Gb*/
CREATE BIGFILE TABLESPACE bigtbs 
DATAFILE '/u01/app/oracle/oradata/XE/bigtbs01.dbf' SIZE 5G;

/*d. Set the undo tablespace to be used in the system*/
ALTER SYSTEM SET UNDO_TABLESPACE = undotbs_01 scope = both;

/*3. Create a DBA user (with the role DBA) and assign it to the tablespace called "uber​", this user has
	unlimited space on the tablespace (The user should have permission to connect) (0.1)*/

CREATE USER dba_user IDENTIFIED BY dba_user
DEFAULT TABLESPACE  uber
QUOTA UNLIMITED ON uber;

GRANT DBA TO dba_user;

GRANT CONNECT TO dba_user;


/*4. Create 2 profiles. (0.1)*/

/*a. Profile 1: "clerk" password life 40 days, one session per user, 10 minutes idle, 4 failed login attempts*/

CREATE PROFILE clerk LIMIT
SESSIONS_PER_USER 1
PASSWORD_LIFE_TIME 40
IDLE_TIME 10
FAILED_LOGIN_ATTEMPTS 4;

/*b. Profile 3: "development" password life 100 days, two session per user, 30 minutes idle, no
failed login attempts*/

CREATE PROFILE development LIMIT 
SESSIONS_PER_USER 2
PASSWORD_LIFE_TIME 100
IDLE_TIME 30
FAILED_LOGIN_ATTEMPTS UNLIMITED;

/*a. 2 of them should have the clerk profile and the remaining the development profile, all the users
should be allow to connect to the database.*/

CREATE USER clerk_user1
IDENTIFIED BY password123
DEFAULT TABLESPACE uber
PROFILE clerk;
	
CREATE USER clerk_user2
IDENTIFIED BY password123
DEFAULT TABLESPACE uber
PROFILE clerk;

CREATE USER developer_user1
IDENTIFIED BY password123
DEFAULT TABLESPACE uber
PROFILE development;
	
CREATE USER developer_user2
IDENTIFIED BY password123
DEFAULT TABLESPACE uber
PROFILE development;

GRANT CONNECT TO clerk_user1;
GRANT CONNECT TO clerk_user2;
GRANT CONNECT TO developer_user1;
GRANT CONNECT TO developer_user2;

/*b. Lock one user associate with clerk profile (0.1)*/
ALTER USER clerk_user1 ACCOUNT LOCK;