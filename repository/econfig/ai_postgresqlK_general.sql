CREATE SCHEMA IF NOT EXISTS "XXXXX" AUTHORIZATION postgres;//@
SET search_path TO XXXXX;
CREATE TABLE "XXXXX".ai_fileandfolder
(
  id serial NOT NULL,
  description character varying(255),
  owner character varying(255),
  rootfolder character varying(255),
  category character varying(255),
  path character varying(255),
  name character varying(255),
  type character varying(255),
  versionno integer,
  visibilitytype character varying(255),
  visible integer,
  createdby character varying(255),
  createdon timestamp without time zone,
  isdefault integer,
  lastupdatedon timestamp without time zone,
  lastupdatedby character varying(255),
  isarchivable integer DEFAULT 1,
  isarchived integer DEFAULT 0,
  ispurgeable integer DEFAULT 1,
  ispurged integer DEFAULT 0,
  CONSTRAINT ai_fileandfolder_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_privilege
(
  id serial NOT NULL,
  fileid integer,
  privilegetype character varying(255),
  user_rolename character varying(255),
  privilegevalue character varying(255),
  canedit integer DEFAULT 0,
  CONSTRAINT ai_privilege_pkey PRIMARY KEY (id),
  CONSTRAINT ai_privilege_fileid_fkey FOREIGN KEY (fileid) REFERENCES "XXXXX".ai_fileandfolder (id) ON DELETE CASCADE
);//@

CREATE TABLE "XXXXX".ai_privilege_template
(
  id serial NOT NULL,
  privilegetype character varying(255),
  user_rolename character varying(255),
  status character varying(255),
  privilegevalue character varying(255),
  CONSTRAINT ai_privilege_template_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_anot_privilege
(
  id serial NOT NULL,
  dashboard_id character varying(255),
  widget_id character varying(255),  
  user_role_name character varying(255),
  privilege_type character varying(255),
  owner character varying(255),
  privilege_value character varying(1) DEFAULT 0,
  CONSTRAINT ai_anot_privilege_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_request
(
  id serial NOT NULL,
  groupid character varying(255) DEFAULT 0,
  onsuccessnextjobid integer DEFAULT 0,
  onfailnextjobid integer DEFAULT 0,
  frequency character varying(255),
  status character varying(255),
  priority timestamp without time zone DEFAULT now(),
  startdate timestamp without time zone,
  enddate timestamp without time zone,
  approvalrequired integer DEFAULT 0,
  groupapprovalrequired integer DEFAULT 0,
  username character varying(255),
  privilegetemplateid character varying(255) DEFAULT 0,
  reportstatus character varying(255),
  created_by character varying(255),
  created_on timestamp without time zone,
  last_updated_by character varying(255),
  last_updated_on timestamp without time zone,
  fileid character varying(255),
  output_path character varying(255),
  output_name character varying(255),
  output_format character varying(255),
  output_id integer,
  delivery_path character varying(255),
  email_address text,
  email_required character varying(1) default '0',
  email_tousers text,
  email_toroles text,
  email_cc text,
  email_required_cc character varying(1) default '0',
  email_cc_tousers text,
  email_cc_toroles text,
  email_bcc text,
  email_required_bcc character varying(1) default '0',
  email_bcc_tousers text,
  email_bcc_toroles text,
  exportReport character varying(1) default '0',
  inlineReport character varying(1) default '0',
  no_of_try_runreport integer DEFAULT 1,
  no_of_try_approval integer DEFAULT 1,
  no_of_try_groupapproval integer DEFAULT 1,
  no_of_try_email integer DEFAULT 1,
  try_frequency_runreport character varying(10),
  try_frequency_approval character varying(10),
  try_frequency_groupapproval character varying(10),
  try_frequency_email character varying(10),
  servedby character varying(255),
  groupruntype character varying(255),
  groupexecution character varying(255),
  sched_pattern character varying(255),
  approvalto_id character varying(255),
  approvalto_entity character varying(255),
  groupapprovalto_id character varying(255),
  groupapprovalto_entity character varying(255),
  approvedby character varying(255),
  groupapprovedby character varying(255),
  approvalnotificationid integer,
  grpapprovalnotificationid integer,
  groupname character varying(255),
  reportenduser character varying(255),
  requestfor character varying(255),
  output_privileges text,
  output_visibility character varying(255),
  output_suffix character varying(255),
  email_templateid integer,
  recurringid integer,
  nextcreated character(1) DEFAULT 0,
  nbid integer default 0,
  CONSTRAINT ai_request_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_request_task
(
  id serial NOT NULL,
  requestid integer,
  name character varying(255),
  status character varying(255),
  comments text,
  username character varying(255),
  trial integer,
  starttime timestamp without time zone,
  endtime timestamp without time zone,
  errorlog character varying(255),
  CONSTRAINT ai_request_task_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_notification
(
  id serial NOT NULL,
  user_rolename character varying(255),
  notifiedto character varying(255),
  readstatus integer,
  message character varying(255),
  notification_type character varying(255),
  createdon timestamp without time zone,
  acknowledgement character varying(255),
  acknowledgedby character varying(255),
  acknowledgedon timestamp without time zone,
  comments text,
  approvalreport_outputtype character varying(255),
  approvalreport_outputid integer,
  sender character varying(255),
  CONSTRAINT ai_notification_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_recurring_request
(
  id serial NOT NULL,
  requestid integer,
  username character varying(255),
  description character varying(255),
  schedulepattern character varying(255),
  scheduletime time without time zone,
  startdate timestamp without time zone,
  enddate timestamp without time zone,
  status character varying(255),
  nextruntime timestamp without time zone,
  lastruntime timestamp without time zone,
  CONSTRAINT ai_recurring_request_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_request_parameter
(
  id serial NOT NULL,
  requestid integer,
  paramname character varying(255),
  paramvalue text,
  paramdatatype character varying(255),
  CONSTRAINT ai_request_parameter_pkey PRIMARY KEY (id),
  CONSTRAINT ai_request_parameter_requestid_fkey FOREIGN KEY (requestid)
      REFERENCES "XXXXX".ai_request (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);//@



CREATE TABLE "XXXXX".ai_filefolder_output
(
  id serial NOT NULL,
  fileid integer,
  outputtype character varying(45),
  CONSTRAINT ai_filefolder_output_fileid_fkey FOREIGN KEY (fileid) REFERENCES "XXXXX".ai_fileandfolder (id) ON DELETE CASCADE
);//@



CREATE TABLE "XXXXX".ai_parameter
(
  id serial NOT NULL,
  name character varying(255),
  datatype character varying(255),
  format character varying(255),
  displayname character varying(255),
  displaytype character varying(255),
  defaultvalue character varying(255),
  defaultvaluetype character varying(255),
  helptext character varying(255),
  isvisible integer,
  isrequired integer,
  filterby character varying(255),
  filtercondition character varying(255),
  linkedparam character varying(255),
  datasetid integer,
  datasetcolumnname character varying(255),
  value_displaytext text,
  username character varying(255),
  CONSTRAINT ai_parameter_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_quickrun
(
  id serial NOT NULL,
  name character varying(255),
  reportid integer,
  username character varying(255),
  CONSTRAINT ai_quickrun_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_quickrun_parameter
(
  id serial NOT NULL,
  quickrunid integer,
  paramname character varying(255),
  paramvalue character varying(255),
  paramdatatype character varying(255),
  CONSTRAINT ai_quickrun_parameter_pkey PRIMARY KEY (id),
  CONSTRAINT ai_quickrun_parameter_quickrunid_fkey FOREIGN KEY (quickrunid)
      REFERENCES "XXXXX".ai_quickrun (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);//@

CREATE TABLE "XXXXX".ai_audit
(
  id serial NOT NULL,
  resourceid character varying(255),
  resourcetype character varying(255),
  actiontype character varying(255),
  username character varying(255),
  starttime timestamp without time zone,
  comments character varying(255),
  oldvalues character varying(255),
  newvalues character varying(255),
  CONSTRAINT ai_audit_pkey PRIMARY KEY (id)
);//@



CREATE TABLE "XXXXX".ai_quicklink
(
  id serial NOT NULL,
  owner character varying(255),
  name character varying(255),
  link character varying(255),
  path character varying(255),
  shortcutkey character varying(255),
  CONSTRAINT ai_quicklink_pkey PRIMARY KEY (id),
  CONSTRAINT ai_quicklink_name_key UNIQUE (name)
);//@

CREATE TABLE "XXXXX".ai_dm
(
  id serial NOT NULL,
  type character varying(255),
  subject character varying(255),
  description text,
  owner character varying(255),
  visibility character varying(255),
  active character varying(255),
  start_date timestamp without time zone,
  end_date timestamp without time zone,
  created_on timestamp without time zone,
  lastupdated_on timestamp without time zone,
  option1 character varying(255),
  option2 character varying(255),
  option3 character varying(255),
  option4 character varying(255),
  option5 character varying(255),
  option6 character varying(255),
  option7 character varying(255),
  option8 character varying(255),
  option9 character varying(255),
  option10 character varying(255),
  CONSTRAINT ai_dm_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_dm_applicable_area
(
  id serial NOT NULL,
  dm_id integer,
  applicableto_area character varying(255),
  applicableto_area_val character varying(255)
);//@

CREATE TABLE "XXXXX".ai_dm_detail
(
  id serial NOT NULL,
  dm_id integer,
  acknowledging_user character varying(255),
  comments text,
  owner character varying(255),
  optionselected character varying(255),
  datetime timestamp without time zone,
  owner_count integer,
  user_count integer,
  CONSTRAINT ai_dm_detail_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_dm_privilege
(
  id serial NOT NULL,
  dm_id integer,
  privilegetype character varying(255),
  user_rolename character varying(255),
  isacknowledged character varying(1) DEFAULT 0,
  CONSTRAINT ai_dm_privilege_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_usertype_map
(
  id serial NOT NULL,
  usertype character varying(255),
  descriptionname character varying(255)
);//@

CREATE TABLE "XXXXX".ai_backupuser
(
  id serial NOT NULL,
  username character varying(255),
  backupuser character varying(255),
  startdate timestamp without time zone,
  enddate timestamp without time zone,
  CONSTRAINT ai_backupuser_username_pkey PRIMARY KEY (username)
);//@


CREATE TABLE "XXXXX".ai_im_comments
(
  id serial NOT NULL,
  notification_id integer,
  comments text,
  owner_count integer,
  user_count integer,
  CONSTRAINT ai_im_comments_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_timezone
(
  id serial NOT NULL,
  name character varying(50) NOT NULL,
  value character varying(10) DEFAULT NULL,
  CONSTRAINT ai_timezone_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_license
(
  machine_id character varying(255) NOT NULL,
  machine_name character varying(255) NOT NULL,
  license_filename character varying(255) NOT NULL,
  cpuoruser integer,
  created_on timestamp without time zone,
  expiry_date timestamp without time zone,
  last_used timestamp without time zone,
  status character varying(10) NOT NULL,
  is_primary integer DEFAULT 0,
  ulimit integer DEFAULT 0,
  token character varying(255) NOT NULL,
  CONSTRAINT ai_license_machine_name_key UNIQUE (machine_name)
);//@

CREATE TABLE "XXXXX".ai_event(
id serial NOT NULL,
description character varying(255) DEFAULT NULL,
type character varying(255) DEFAULT NULL,
event_number character varying(10) NOT NULL,
owner character varying(255) DEFAULT NULL,
email_templateId integer DEFAULT 0,
CONSTRAINT ai_event_pkey PRIMARY KEY (id),
CONSTRAINT ai_event_number UNIQUE (owner,event_number)
);//@


CREATE TABLE "XXXXX".ai_event_request(
id serial NOT NULL,
event_id integer,
request_id integer,
CONSTRAINT ai_event_request_eventid_fkey FOREIGN KEY (event_id) REFERENCES "XXXXX".ai_event (id) ON DELETE CASCADE,
CONSTRAINT ai_event_request_requestid_fkey FOREIGN KEY (request_id) REFERENCES "XXXXX".ai_request (id) ON DELETE CASCADE
);//@

CREATE TABLE "XXXXX".ai_event_mail(
id serial NOT NULL,
event_id integer,
entity character varying(10) NOT NULL,
recipient text NOT NULL,
CONSTRAINT ai_event_mail_id_fkey foreign key(event_id) REFERENCES "XXXXX".ai_event (id) ON DELETE CASCADE
);//@

CREATE TABLE "XXXXX".ai_external_db(
dbKey character varying(255),
dbName character varying(255) NOT NULL,
CONSTRAINT ai_extdb_pkey PRIMARY KEY (dbKey)
);//@

CREATE TABLE "XXXXX".ai_extdb_priv(
id serial NOT NULL,
dbKey character varying(255),
privilegeType character varying(10) NOT NULL,
user_roleName character varying(255) NOT NULL,
CONSTRAINT ai_extdb_priv_fkey foreign key(dbKey) REFERENCES "XXXXX".ai_external_db (dbKey) ON DELETE CASCADE
);//@

CREATE TABLE "XXXXX".ai_annotation (
  id serial NOT NULL,
  annotationKey character varying(255),
  description text,
  shortDescription character varying(255),
  startDate date,
  endDate date,
  groupName character varying(255),
  owner character varying(255),
  visibilityType character varying(255),
  CONSTRAINT ai_annotation_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_lovrow_mapping(
id serial NOT NULL,
lovId integer default NULL,
mapId integer default NULL,
rowNo character varying(255) default NULL,
owner character varying(255) NOT NULL,
comments character varying(1000) default NULL,
CONSTRAINT ai_lovrow_mapping_pkey PRIMARY KEY (id),
CONSTRAINT ai_lovrow_mapping_lovId_fkey FOREIGN KEY (lovId) REFERENCES "XXXXX".ai_fileandfolder(id),
CONSTRAINT ai_lovrow_mapping_mapId_fkey FOREIGN KEY (mapId) REFERENCES "XXXXX".ai_fileandfolder(id)
);//@

CREATE TABLE "XXXXX".ai_report_management(	
id serial NOT NULL, 
lovId integer DEFAULT NULL, 
lovMappingId integer DEFAULT NULL, 
lovRowId character varying(255) DEFAULT NULL, 
name character varying(255) DEFAULT NULL, 
previousRunId integer DEFAULT NULL, 
previousRunTime timestamp without time zone DEFAULT NULL, 
currentRunId integer DEFAULT NULL, 
currentRunTime timestamp without time zone DEFAULT NULL, 
owner character varying(255) DEFAULT NULL, 
comments character varying(1000) DEFAULT NULL,
CONSTRAINT ai_report_management_pkey PRIMARY KEY (id),
CONSTRAINT ai_report_management_lovId_fkey FOREIGN KEY (lovId) REFERENCES "XXXXX".ai_fileandfolder(id),
CONSTRAINT ai_report_management_lovMappingId_fkey FOREIGN KEY (lovMappingId) REFERENCES "XXXXX".ai_fileandfolder(id)
);//@

CREATE TABLE "XXXXX".ai_datasource (
id serial NOT NULL,
protocol character varying(500),
type_database character varying(500) DEFAULT NULL,
name character varying(500) DEFAULT NULL,
jndi character varying(500) NOT NULL DEFAULT '0',
driver_class_name character varying(500) DEFAULT NULL,
url character varying(1000) DEFAULT NULL,
username character varying(1000) DEFAULT NULL,
password character varying(1000) DEFAULT NULL,
g_credential character varying(1000) DEFAULT NULL,
g_key_type character varying(255) DEFAULT NULL,
g_project_id character varying(1000) DEFAULT NULL,
g_filename character varying(1000) DEFAULT NULL,
g_service_account_id character varying(1000) DEFAULT NULL,
olapDriver character varying(255) DEFAULT NULL,
olapConnStr character varying(255) DEFAULT NULL,
waitTime BIGINT DEFAULT NULL,
department character varying(255),
extra_info text DEFAULT '{}',
CONSTRAINT ai_datasource_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_datasource_type (
id serial NOT NULL,
protocol character varying(500),
type_database character varying(500),
driver_class_name character varying(500),
url character varying(1000),
CONSTRAINT ai_datasource_type_pkey PRIMARY KEY (id)
);//@


CREATE TABLE "XXXXX".ai_time_scheduler_cron (
  id serial NOT NULL,
  actual_end_time timestamp without time zone NULL DEFAULT NULL,
  actual_start_time timestamp without time zone NULL DEFAULT NULL,
  cron_expression character varying(50) DEFAULT NULL,
  end_time timestamp without time zone NULL DEFAULT NULL,
  interval_time character varying(255) DEFAULT NULL,
  start_time timestamp without time zone NULL DEFAULT NULL,
  status character varying(50) DEFAULT NULL,
  type_of_job character varying(50) DEFAULT NULL,
  extra_info text DEFAULT NULL,
  req_rec_id integer,
  server character varying(255) DEFAULT NULL,
  name character varying(45) DEFAULT NULL,
  CONSTRAINT ai_time_scheduler_cron_pkey PRIMARY KEY (id)
);//@

CREATE TABLE "XXXXX".ai_alertSuccess
   (	id serial NOT NULL, 
	alertId integer DEFAULT NULL, 
	status character varying(255), 
	conditionName character varying(500), 
	dateExecuted timestamp without time zone,
	mailedTo character varying(255), 
	owner character varying(255), 
	actualValue character varying(255), 
	valOne character varying(1000), 
	valTwo character varying(1000), 
	CONSTRAINT ai_alertSuccess_pkey PRIMARY KEY (id),
	CONSTRAINT ai_alertSuccess_fkey FOREIGN KEY (alertId) REFERENCES "XXXXX".ai_fileandfolder(id)
	);//@

CREATE TABLE "XXXXX".ai_filetype_output
(
  id serial NOT NULL,
  filetype character varying(45),
  outputtype character varying(45)
);//@

CREATE TABLE IF NOT EXISTS "XXXXX".ai_chathistory
(
    id serial NOT NULL,
    threadname character varying(255),
    recordtime time without time zone,
    history text,
	fileid integer,
    username character varying(255),
    type character varying(255),
    threadid character varying(255),
    CONSTRAINT ai_chathistory_pkey PRIMARY KEY (id)
);//@


CREATE TABLE IF NOT EXISTS "XXXXX".ai_apitoken
(
    id serial,
    key character varying(255) DEFAULT NULL,
    owner character varying(255) DEFAULT NULL,
    department character varying(255) DEFAULT NULL,
    lastused timestamp without time zone DEFAULT NULL,
    name character varying(255) CDEFAULT NULL,
    createddate timestamp without time zone DEFAULT NULL,
    "time" character varying(255) DEFAULT NULL
);//@


insert into "XXXXX".ai_timezone values
(1,'ACDT Australian Central Daylight Time','+10:30'),
(2,'ACST Australian Central Standard Time','+9:30'),
(3,'ADT Atlantic Daylight Time','-3:00'),
(4,'AEDT Australian Eastern Daylight Time','+11:00'),
(5,'AEST Australian Eastern Standard Time','+10:00'),
(6,'AKDT Alaska Standard Daylight Saving Time','-8:00'),
(7,'AKST Alaska Standard Time','-9:00'),
(8,'AST Atlantic Standard Time','-4:00'),
(9,'AWST Australian Western Standard Time','+8:00'),
(10,'BST British Summer Time','+1:00'),
(11,'CDT Central Daylight Saving Time','-5:00'),
(12,'CEST Central Europe Summer Time','+2:00'),
(13,'CET Central Europe Time','+1:00'),
(14,'CST Central Standard Time','-6:00'),
(15,'Default','SYSTEM'),
(16,'EDT Eastern Daylight Saving Time','-4:00'),
(17,'EEST Eastern Europe Summer Time','+3:00'),
(18,'EET Eastern Europe Time','+2:00'),
(19,'EST Eastern Standard Time','-5:00'),
(20,'GMT Greenwich Mean Time','+00:00'),
(21,'HST Hawaiian Standard Time','-10:00'),
(22,'IST Indian Standard Time','+5:30'),
(23,'IST Irish Summer Time','+1:00'),
(24,'MDT Mountain Daylight Saving Time','-6:00'),
(25,'MSD Moscow Summer Time','+4:00'),
(26,'MSK Moscow Time','+3:00'),
(27,'MST Mountain Standard Time','-7:00'),
(28,'PDT Pacific Daylight Saving Time','-7:00'),
(29,'PST Pacific Standard Time','-8:00'),
(30,'WEST Western Europe Summer Time','+1:00'),
(31,'WET Western Europe Time','+00:00');//@


INSERT INTO "XXXXX".ai_filetype_output(id,fileType, outputType)
VALUES (1,'rptdesign','rptdocument'),
(2,'rptdesign','html'),
(3,'rptdesign','pdf'),
(4,'rptdesign','xlsx'),
(5,'rptdesign','docx'),
(6,'rptdesign','xls'),
(7,'rptdesign','xls_spudsoft'),
(8,'jrxml','phtml'),
(9,'jrxml','html'),
(10,'jrxml','pdf'),
(11,'jrxml','xls'),
(12,'jrxml','docx'),
(13,'jasper','phtml'),
(14,'jasper','html'),
(15,'jasper','pdf'),
(16,'jasper','xls'),
(17,'jasper','docx'),
(18,'prpt','prptdocument'),
(19,'prpt','html'),
(20,'prpt','pdf'),
(21,'prpt','xls'),
(22,'prpt','csv'),
(23,'prpt','rtf'),
(24,'prpt','xml'),
(25,'prpt','txt'),
(26,'report','html'),
(27,'report','xlsx'),
(28,'report','xls_spudsoft'),
(29,'report','pdf'),
(30,'rptdesign','pptx'),
(31,'ipynb','pdf'),
(32,'rptdesign','aiv-xlsx');//@

SELECT SETVAL('ai_filetype_output_id_seq', (SELECT MAX(id) from ai_filetype_output));//@


CREATE TABLE "XXXXX".ai_category
(
  id serial NOT NULL,
  category character varying(50),
  folderpath character varying(255),
  CONSTRAINT ai_category_category_key UNIQUE (category)
);//@


insert into "XXXXX".ai_category(id,category,folderPath)
values (1,'REPORTS','/Documents/Reports'),
(2,'QUICKRUN','/Documents/QuickRun'),
(3,'MAPPING','/Documents/Mapping'),
(4,'DASHBOARD','/Dashboard/Dashboards'),
(5,'WIDGET','/Dashboard/Widgets'),
(6,'DATASETS','/Data/DataSets'),
(7,'DATASOURCES','/Data/DataSources'),
(8,'LISTOFVALUES','/Data/ListOfValues'),
(9,'PARAMETERS','/Data/Parameters'),
(10,'APPROVAL','/Approval'),
(11,'RESOURCES','/Resources'),
(12,'ALERTS','/Data/Alerts'),
(13,'MERGE','/Documents/Merge'),
(14,'OLAP_ANALYTIC','/Dashboard/OlapAnalytics'),
(15,'ADHOC','/Documents/Adhoc'),
(16,'APP','APP');//@

SELECT SETVAL('ai_category_id_seq', (SELECT MAX(id) from ai_category));//@


CREATE TABLE "XXXXX".ai_filetype
(
  id serial NOT NULL,
  isoutputtype integer,
  filetype character varying(255),
  longdescription character varying(255),
  classname character varying(255),
  CONSTRAINT ai_filetype_pkey PRIMARY KEY (id),
  CONSTRAINT ai_filetype_filetype_key UNIQUE (filetype)
);//@


INSERT INTO "XXXXX".ai_filetype(id,isOutputType,fileType,longDescription)
VALUES (1,1,'csv','Comma Seprated Value file'),
(2,0,'rptdesign','Birt report design file'),
(3,1,'rptdocument','Birt report document file'),
(4,0,'jrxml','Jasper report file'),
(5,0,'jasper','Jasper Compiled report file'),
(6,0,'prpt','Pentaho report design file'),
(7,1,'prptdocument','Pentaho report document file'),
(8,1,'pdf','Portable document format file'),
(9,1,'png','Portable Network Graphics image'),
(10,1,'jpeg','Joint Photographic Experts Group image'),
(11,1,'jpg','Joint Photographic Experts Group image'),
(12,1,'css','Cascading Style Sheets file'),
(13,1,'etemp','Email Template file'),
(14,1,'js','Javascript file'),
(15,1,'docx','Microsoft word file'),
(16,1,'doc','Microsoft word file'),
(17,1,'rtf','Rich text format file'),
(18,1,'xlsx','Microsoft excel file'),
(19,1,'xls','Microsoft excel file'),
(20,1,'xlsm','Macro Enabled Spreadsheet'),
(21,1,'json','Javascript object Notation'),
(22,1,'rptlibrary','Birt report library'),
(23,1,'rpttemplate','Birt report template'),
(24,1,'merge','Merge report file'),
(25,1,'map','Mapping file'),
(26,1,'xml','XML file'),
(27,1,'html','Hypertext markup language file'),
(28,1,'phtml','Paginated html file'),
(29,1,'dash','Dashboard file'),
(30,1,'dashboard','Cached Dashboard file'),
(31,1,'txt','Plain text file'),
(32,0,'report','Fly Report file'),
(33,1,'ds','Dataset file'),
(34,1,'cds','Cached Dataset file'),
(35,0,'template','Fly Report template'),
(36,1,'pptx','Microsoft power point file'),
(37,0,'ipynb','Jupyter Notebook'),
(38,1,'gbr','Group Bursting Report'),
(39,1,'stash','Group Dataset'),
(40,1,'dml','DML'),
(41,1,'adhoc','ADHOC File'),
(42,1,'aiv-xlsx','AIV XLSX'),
(43,1,'app','AIV');//@

SELECT SETVAL('ai_filetype_id_seq', (SELECT MAX(id) from ai_filetype));//@


commit;//@

SET search_path TO "$user", public;//@


commit;//@
