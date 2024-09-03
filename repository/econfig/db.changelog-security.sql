--changeset author:1 date:20240825

CREATE SCHEMA IF NOT EXISTS security;

CREATE TABLE IF NOT EXISTS security.ai_user
(
  id serial NOT NULL,
  firstname character varying(255),
  lastname character varying(255),
  username character varying(255),
  status character varying(255),
  password character varying(255),
  email character varying(255),
  homefolder character varying(255),
  backupuserid character varying(255),
  manageruserid character varying(255),
  dashboardoption character varying(1) default '0',
  alertsOption character varying(1) default '0',
  reportOption character varying(1) default '0',
  mergeReportOption character varying(1) default '0',
  adhocOption character varying(1) default '0',
  resourceOption character varying(1) default '0',
  quickRunOption character varying(1) default '0',
  mappingOption character varying(1) default '0',
  messageOption character varying(1) default '0',
  datasetOption character varying(1) default '0',
  parameterOption character varying(1) default '0',
  annotationOption character varying(1) default '0',
  notificationOption character varying(1) default '0',
  requestOption character varying(1) default '0',
  adminOption character varying(1) default '0',
  scheduleOption character varying(1) default '0',
  usertype character varying(255),
  default_dashboard character varying(255),
landing_page character varying(255),
locale character varying(255),
timezone character varying(255),
theme character varying(255),
notification character varying(1) default '0',
department character varying(255),
showname character varying(1) default '1',
showimage character varying(1) default '1',
  CONSTRAINT ai_user_pkey PRIMARY KEY (id),
  CONSTRAINT ai_user_username_key UNIQUE (username)
);


CREATE TABLE IF NOT EXISTS security.ai_role
(
  id serial NOT NULL,
  name character varying(255),
  description character varying(255),
  email character varying(255),
  dashboardoption character varying(1) default '0',
  alertsOption character varying(1) default '0',
  reportOption character varying(1) default '0',
  mergeReportOption character varying(1) default '0',
  adhocOption character varying(1) default '0',
  resourceOption character varying(1) default '0',
  quickRunOption character varying(1) default '0',
  mappingOption character varying(1) default '0',
  messageOption character varying(1) default '0',
  datasetOption character varying(1) default '0',
  parameterOption character varying(1) default '0',
  annotationOption character varying(1) default '0',
  notificationOption character varying(1) default '0',
  requestOption character varying(1) default '0',
  adminOption character varying(1) default '0',
  scheduleOption character varying(1) default '0',
  department character varying(255),
  CONSTRAINT ai_role_pkey PRIMARY KEY (id),
  CONSTRAINT ai_role_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS security.ai_user_role
(
  id serial NOT NULL,
  userName character varying(255),
  roleName character varying(255),
  CONSTRAINT ai_user_role_pkey PRIMARY KEY (id),
  CONSTRAINT ai_user_role_ukey UNIQUE (userName,roleName)
);

CREATE TABLE IF NOT EXISTS security.ai_registered_user (
 id serial NOT NULL,
 type character varying(1000) DEFAULT NULL,
 subtype character varying(45) DEFAULT NULL,
 numberofusers integer DEFAULT 0,
 email character varying(255) DEFAULT NULL,
 company character varying(255) DEFAULT NULL,
 department character varying(255) DEFAULT NULL,
 CONSTRAINT ai_registered_user_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS security.ai_department
(
    id serial NOT NULL,
    deptname character varying(255) DEFAULT NULL,
    deptcode character varying(255) DEFAULT NULL,
	type character varying(1000) DEFAULT NULL,
	subtype character varying(45) DEFAULT NULL,
	numberofusers integer DEFAULT 0,
	email character varying(255) DEFAULT NULL,
	company character varying(255) DEFAULT NULL,
	 CONSTRAINT ai_department_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS security.ai_email_users
(
    displayname character varying(255) DEFAULT NULL,
    email character varying(255) DEFAULT NULL,
    status character varying(50) DEFAULT NULL,
    department character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT ai_email_users_pkey PRIMARY KEY (email, department)
);


CREATE TABLE IF NOT EXISTS security.dept_admins
(
    id serial NOT NULL,
    department character varying(255) DEFAULT NULL,
    password character varying(255) DEFAULT NULL,
    username character varying(255) DEFAULT NULL,
    CONSTRAINT dept_admins_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS security.super_admins
(
    id serial NOT NULL,
    password character varying(255) DEFAULT NULL,
    username character varying(255) DEFAULT NULL,
    CONSTRAINT super_admins_pkey PRIMARY KEY (id)
);


insert into security.super_admins values
(1,'8989899D2C314FF543657C44BF8EAB10','Admin');


SELECT SETVAL('security.super_admins_id_seq', (SELECT MAX(id) from security.super_admins));


insert into security.dept_admins values
(1,'Default','8989899D2C314FF543657C44BF8EAB10','Admin');


SELECT SETVAL('security.dept_admins_id_seq', (SELECT MAX(id) from security.dept_admins));


insert into security.ai_user values
(1,'Admin',NULL,'Admin','Active','8989899D2C314FF543657C44BF8EAB10',NULL,'/Admin','2','0',2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,'INT','47|:|Solution Dashboard|:|Admin','Visualization/GridDashboard','en','SYSTEM','Default','0','Default'),
(2,'Paul','Smith','Demo','Active','8989899D2C314FF543657C44BF8EAB10','Paul@aivhub.com','/Demo','1','0',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'INT',NULL,'Documents/Reports','en','SYSTEM','Default','0','Default');

SELECT SETVAL('security.ai_user_id_seq', (SELECT MAX(id) from security.ai_user));

insert into security.ai_role values
(1,'Administrator','Administrator Role','admin-a@aivhub.com',2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,'Default'),
(2,'Sales','Sales Role','support@aivhub.com',1,1,1,1,2,0,1,1,1,0,0,2,1,1,0,2,'Default');

SELECT SETVAL('security.ai_role_id_seq', (SELECT MAX(id) from security.ai_role));

insert into security.ai_user_role values
(1,'Demo','Sales'),
(2,'Admin','Administrator');

SELECT SETVAL('security.ai_user_role_id_seq', (SELECT MAX(id) from security.ai_user_role));

INSERT INTO security.ai_department(id,deptName,deptCode)
VALUES (1,'Default','Default');

SELECT SETVAL('security.ai_department_id_seq', (SELECT MAX(id) from security.ai_department));


commit;