CREATE EXTENSION IF NOT EXISTS UNACCENT;

CREATE TABLE pui_language (
	isocode CHARACTER VARYING(2),
	name CHARACTER VARYING(100) NOT NULL,
	isdefault INTEGER DEFAULT 0 NOT NULL,
	enabled INTEGER DEFAULT 1 NOT NULL,
	CONSTRAINT pk_pui_language PRIMARY KEY (isocode),
	CONSTRAINT ck_lang_def CHECK (isdefault in (0, 1))
);

CREATE TABLE pui_user (
	usr CHARACTER VARYING(100),
	name CHARACTER VARYING(200) NOT NULL,
	password CHARACTER VARYING(100),
	language CHARACTER VARYING(2),
	email CHARACTER VARYING(100),
	disabled INTEGER DEFAULT 0 NOT NULL,
	disabled_date timestamptz(3),
	dateformat CHARACTER VARYING(10) DEFAULT 'dd/MM/yyyy' NOT NULL,
	reset_password_token CHARACTER VARYING(100),
	last_access_time timestamptz(3),
	last_access_ip CHARACTER VARYING(50),
	last_password_change timestamptz(3),
	login_wrong_attempts INTEGER DEFAULT 0 NOT NULL,
	change_password_next_login INTEGER DEFAULT 0 NOT NULL,
	secret_2fa CHARACTER VARYING(50),
	reset_password_token_date timestamptz(3),
	CONSTRAINT pk_pui_user PRIMARY KEY (usr),
	CONSTRAINT ck_lang_dis CHECK (disabled in (0, 1)),
	CONSTRAINT fk_user_language FOREIGN KEY (language) REFERENCES pui_language(isocode) ON DELETE SET NULL,
	CONSTRAINT ck_dateformat CHECK (dateformat in ('yyyy/MM/dd', 'yyyy-MM-dd', 'dd/MM/yyyy', 'dd-MM-yyyy'))
);

CREATE TABLE pui_session (
	uuid CHARACTER VARYING(100) NOT NULL,
	usr CHARACTER VARYING(100) NOT NULL,
	created timestamptz(3) NOT NULL,
	expiration timestamptz(3) NOT NULL,
	lastuse timestamptz(3) NOT NULL,
	persistent INTEGER DEFAULT 0 NOT NULL,
	jwt TEXT NOT NULL,
	CONSTRAINT pk_pui_session PRIMARY KEY (uuid)
);

CREATE TABLE pui_subsystem (
	subsystem CHARACTER VARYING(3),
	CONSTRAINT pk_pui_subsystem PRIMARY KEY (subsystem)
);

CREATE TABLE pui_subsystem_tra (
	subsystem CHARACTER VARYING(3),
	lang CHARACTER VARYING(2),
	lang_status INTEGER DEFAULT 0 NOT NULL,
	name CHARACTER VARYING(200) NOT NULL,
	CONSTRAINT pk_pui_subsystem_tra PRIMARY KEY (subsystem, lang),
	CONSTRAINT fk_subsystem_tra_subsystem FOREIGN KEY (subsystem) REFERENCES pui_subsystem(subsystem) ON DELETE CASCADE,
	CONSTRAINT fk_subsystem_tra_lang FOREIGN KEY (lang) REFERENCES pui_language(isocode) ON DELETE CASCADE,
	CONSTRAINT ck_subsystem_tra_status CHECK (lang_status in (0, 1))
);

CREATE TABLE pui_functionality (
	functionality CHARACTER VARYING(100),
	subsystem CHARACTER VARYING(3) NOT NULL,
	CONSTRAINT pk_pui_functionality PRIMARY KEY (functionality),
	CONSTRAINT fk_func_subsystem FOREIGN KEY (subsystem) REFERENCES pui_subsystem(subsystem) ON DELETE CASCADE
);

CREATE TABLE pui_functionality_tra (
	functionality CHARACTER VARYING(100),
	lang CHARACTER VARYING(2),
	lang_status INTEGER DEFAULT 0 NOT NULL,
	name CHARACTER VARYING(200) NOT NULL,
	CONSTRAINT pk_pui_functionality_tra PRIMARY KEY (functionality, lang),
	CONSTRAINT fk_func_tra_func FOREIGN KEY (functionality) REFERENCES pui_functionality(functionality) ON DELETE CASCADE,
	CONSTRAINT fk_func_tra_lang FOREIGN KEY (lang) REFERENCES pui_language(isocode) ON DELETE CASCADE,
	CONSTRAINT ck_func_tra_status CHECK (lang_status in (0, 1))
);

CREATE TABLE pui_profile (
	profile CHARACTER VARYING(100),
	CONSTRAINT pk_pui_profile PRIMARY KEY (profile)
);

CREATE TABLE pui_profile_tra (
	profile CHARACTER VARYING(100),
	lang CHARACTER VARYING(2),
	lang_status INTEGER DEFAULT 0 NOT NULL,
	name CHARACTER VARYING(200) NOT NULL,
	CONSTRAINT pk_pui_profile_tra PRIMARY KEY (profile, lang),
	CONSTRAINT fk_profile_tra_profile FOREIGN KEY (profile) REFERENCES pui_profile(profile) ON DELETE CASCADE,
	CONSTRAINT fk_profile_tra_lang FOREIGN KEY (lang) REFERENCES pui_language(isocode) ON DELETE CASCADE,
	CONSTRAINT ck_profile_tra_status CHECK (lang_status in (0, 1))
);

CREATE TABLE pui_profile_functionality (
	profile CHARACTER VARYING(100),
	functionality CHARACTER VARYING(100),
	CONSTRAINT pk_pui_profile_functionality PRIMARY KEY (profile, functionality),
	CONSTRAINT fk_prof_func_prof FOREIGN KEY (profile) REFERENCES pui_profile(profile) ON DELETE CASCADE,
	CONSTRAINT fk_prof_func_func FOREIGN KEY (functionality) REFERENCES pui_functionality(functionality) ON DELETE CASCADE
);

CREATE TABLE pui_user_profile (
	USR CHARACTER VARYING(100),
	profile CHARACTER VARYING(100),
	CONSTRAINT pk_pui_user_profile PRIMARY KEY (USR, profile),
	CONSTRAINT fk_user_profile_user FOREIGN KEY (USR) REFERENCES pui_user(USR) ON DELETE CASCADE,
	CONSTRAINT fk_user_profile_profile FOREIGN KEY (profile) REFERENCES pui_profile(profile) ON DELETE CASCADE
);

CREATE TABLE pui_model (
	model CHARACTER VARYING(100),
	entity CHARACTER VARYING(100),
	configuration TEXT,
	filter TEXT,
	CONSTRAINT pk_pui_grid PRIMARY KEY (model)
);

CREATE TABLE pui_user_model_filter (
	id SERIAL,
	usr CHARACTER VARYING(100) NOT NULL,
	model CHARACTER VARYING(100) NOT NULL,
	label CHARACTER VARYING(200) NOT NULL,
	filter TEXT NOT NULL,
	CONSTRAINT pk_pui_user_filter PRIMARY KEY (id),
	CONSTRAINT fk_user_model_filter_usr FOREIGN KEY (usr) REFERENCES pui_user(usr) ON DELETE CASCADE,
	CONSTRAINT fk_user_model_filter_model FOREIGN KEY (model) REFERENCES pui_model(model) ON DELETE CASCADE
);

CREATE TABLE pui_model_filter (
	id SERIAL,
	model CHARACTER VARYING(100) NOT NULL,
	label CHARACTER VARYING(200) NOT NULL,
	description CHARACTER VARYING(300),
	filter TEXT NOT NULL,
	isdefault INTEGER DEFAULT 0 NOT NULL,
	CONSTRAINT pk_pui_grid_filter PRIMARY KEY (id),
	CONSTRAINT ck_model_filter_def CHECK (isdefault in (0, 1)),
	CONSTRAINT fk_model_filter_model FOREIGN KEY (model) REFERENCES pui_model(model) ON DELETE CASCADE
);

CREATE TABLE pui_user_model_config (
	id SERIAL,
	usr CHARACTER VARYING(100) NOT NULL,
	model CHARACTER VARYING(100) NOT NULL,
	configuration TEXT NOT NULL,
	type CHARACTER VARYING(50) NOT NULL,
	CONSTRAINT pk_pui_user_grid_config PRIMARY KEY (id),
	CONSTRAINT fk_user_config_usr FOREIGN KEY (usr) REFERENCES pui_user(usr) ON DELETE CASCADE,
	CONSTRAINT fk_user_config_model FOREIGN KEY (model) REFERENCES pui_model(model) ON DELETE CASCADE
);

CREATE TABLE pui_menu (
	node INTEGER,
	parent INTEGER,
	model CHARACTER VARYING(100),
	component CHARACTER VARYING(100),
	functionality CHARACTER VARYING(100),
	label CHARACTER VARYING(100) NOT NULL,
	icon_label CHARACTER VARYING(100),
	CONSTRAINT pk_pui_menu PRIMARY KEY (node),
	CONSTRAINT fk_menu_model FOREIGN KEY (model) REFERENCES pui_model(model),
	CONSTRAINT fk_menu_func FOREIGN KEY (functionality) REFERENCES pui_functionality(functionality),
	CONSTRAINT fk_menu_parent FOREIGN KEY (parent) REFERENCES pui_menu(node)
);

CREATE TABLE pui_variable (
	variable CHARACTER VARYING(50),
	value TEXT NOT NULL,
	description CHARACTER VARYING(500) NOT NULL,
	CONSTRAINT pk_pui_variable PRIMARY KEY (variable)
);

CREATE TABLE pui_elasticsearch_views (
    appname CHARACTER VARYING(100) NOT NULL DEFAULT 'DEFAULT',
    viewname CHARACTER VARYING(100) NOT NULL,
    identity_fields CHARACTER VARYING(100) NOT NULL,
    CONSTRAINT pk_elasticsearch_views PRIMARY KEY (appname, viewname)
);

CREATE TABLE pui_audit (
	id SERIAL,
	model CHARACTER VARYING(100) NOT NULL,
	type CHARACTER VARYING(50) NOT NULL,
	pk CHARACTER VARYING(100),
	datetime timestamptz(3) NOT NULL,
	usr CHARACTER VARYING(100) NOT NULL,
	ip CHARACTER VARYING(100) NOT NULL DEFAULT '0.0.0.0',
	content TEXT,
	client CHARACTER VARYING(100),
	CONSTRAINT pk_pui_audit PRIMARY KEY (id)
);

CREATE TABLE pui_importexport (
	id SERIAL,
	model character varying(100) NOT NULL,
	usr character varying(100) NOT NULL,
	datetime timestamptz(3) NOT NULL,
	filename_csv character varying(100) NOT NULL,
	filename_json character varying(100) NOT NULL,
	executed INTEGER DEFAULT 0 NOT NULL,
	CONSTRAINT pk_pui_impexp PRIMARY KEY (id),
	CONSTRAINT fk_pui_impexp_model FOREIGN KEY (model) REFERENCES pui_model(model),
	CONSTRAINT fk_pui_impexp_usr FOREIGN KEY (usr) REFERENCES pui_user(usr),
	CONSTRAINT ck_executed CHECK (executed in (0, 1))
);

CREATE TABLE pui_multi_instance_process (
    id character varying(100) NOT NULL,
    period integer not null,
    time_unit character varying(15) not null,
    instance_assignee_uuid character varying(100),
    latest_execution timestamptz(3),
    latest_heartbeat timestamptz(3),
    CONSTRAINT pk_pui_parallel_process PRIMARY KEY (id)
);

CREATE VIEW v_pui_language AS
SELECT
	l.isocode,
	l.name,
	l.isdefault,
	l.enabled
FROM pui_language l;

CREATE VIEW v_pui_variable AS
SELECT
	v.variable,
	v.value,
	v.description
FROM pui_variable v;

CREATE VIEW v_pui_user AS
SELECT
	u.usr,
	u.name,
	u.email,
	u.language,
	u.dateformat,
	u.disabled,
	u.disabled_date,
	u.last_access_time,
	u.last_access_ip,
	u.last_password_change,
	u.login_wrong_attempts,
	u.change_password_next_login
FROM pui_user u;

CREATE VIEW v_pui_audit AS
SELECT
	a.id,
	a.datetime,
	a.usr,
	pu.name AS username,
	a.client,
	a.ip,
	a.type,
	a.model,
	a.pk,
	a.content
FROM pui_audit a
LEFT JOIN v_pui_user pu ON pu.usr = a.usr;

CREATE VIEW v_pui_subsystem AS
SELECT
	s.SUBSYSTEM,
	s_tra.NAME,
	s_tra.lang
FROM PUI_SUBSYSTEM s
LEFT JOIN PUI_SUBSYSTEM_TRA s_tra ON
	s_tra.SUBSYSTEM = s.SUBSYSTEM;

CREATE VIEW v_pui_functionality AS
SELECT
	f.functionality,
	f_tra.name,
	f.subsystem,
	s_tra.name as subsystem_name,
	s_tra.lang
FROM pui_functionality f
LEFT JOIN pui_subsystem s ON
	s.subsystem = f.subsystem
LEFT JOIN pui_functionality_tra f_tra ON
	f_tra.functionality = f.functionality
LEFT JOIN pui_subsystem_tra s_tra ON
	s_tra.subsystem = s.subsystem AND
	s_tra.lang = f_tra.lang;

CREATE VIEW v_pui_profile AS
SELECT
	p.profile,
	p_tra.name,
	p_tra.lang
FROM pui_profile p
LEFT JOIN pui_profile_tra p_tra ON
	p_tra.profile = p.profile;



CREATE VIEW v_pui_profile_functionality AS
SELECT
	pf.profile,
	p_tra.name as profile_name,
	pf.functionality,
	p_tra.lang
FROM pui_profile_functionality pf
LEFT JOIN pui_profile p ON
	p.profile = pf.profile
LEFT JOIN pui_profile_tra p_tra ON
	p_tra.profile = p.profile;

CREATE VIEW v_pui_user_functionality AS
SELECT
	up.usr,
	pf.functionality,
	f_tra.name AS functionality_name,
	pf.profile,
	p_tra.name AS profile_name
FROM pui_user_profile up
INNER JOIN pui_profile_functionality pf ON
	pf.profile = up.profile
LEFT JOIN pui_profile p ON
	p.profile = pf.profile
LEFT JOIN pui_functionality f ON
	f.functionality = pf.functionality
LEFT JOIN pui_profile_tra p_tra ON
	p_tra.profile = p.profile
LEFT JOIN pui_functionality_tra f_tra ON
	f_tra.functionality = f.functionality AND
	f_tra.lang = p_tra.lang
WHERE f_tra.lang = 'es';

-- languages
INSERT INTO pui_language VALUES ('es', 'Español', 1, 1);
INSERT INTO pui_language VALUES ('en', 'English', 0, 1);
INSERT INTO pui_language VALUES ('fr', 'Français', 0, 1);
INSERT INTO pui_language VALUES ('ca', 'Català', 0, 1);

-- models
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puiaudit', 'v_pui_audit', '{"order":[{"column":"datetime","direction":"asc"}]}', '{"columns":[{"name":"id","visibility":"hidden"},{"name":"datetime","visibility":"visible"},{"name":"usr","visibility":"visible"},{"name":"client","visibility":"visible"},{"name":"ip","visibility":"visible"},{"name":"type","visibility":"hidden"},{"name":"model","visibility":"hidden"},{"name":"pk","visibility":"hidden"},{"name":"content","visibility":"hidden"}],"order":[{"column":"datetime","direction":"desc"}]}');
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puidocgenattribute', 'pui_docgen_attribute', '{"order":[{"column":"label","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puidocgentemplate', 'v_pui_docgen_template', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puidocgenmodel', 'v_pui_docgen_model', '{"order":[{"column":"label","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puidocument', 'v_pui_document', '{"order":[{"column":"id","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puifunctionality', 'v_pui_functionality', '{"order":[{"column":"functionality","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puilanguage', 'v_pui_language', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puiprofile', 'v_pui_profile', '{"order":[{"column":"profile","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puisubsystem', 'v_pui_subsystem', '{"order":[{"column":"subsystem","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puiuser', 'v_pui_user', '{"order":[{"column":"usr","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puivariable', 'v_pui_variable', '{"order":[{"column":"variable","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puidashboard', 'v_pui_dashboard', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puiwidget', 'v_pui_widget', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puiwidgettype', 'v_pui_widget_type', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puialertconfiguration', 'v_pui_alert_configuration', NULL, '{"order":[{"column":"id","direction":"asc"}]}');
INSERT INTO pui_model (model, entity, "configuration", "filter") VALUES('puialert', 'v_pui_alert', NULL, '{"order":[{"column":"id","direction":"asc"}]}');

-- profiles
INSERT INTO pui_profile VALUES ('ADMIN_PUI');
INSERT INTO pui_profile_tra VALUES ('ADMIN_PUI', 'es', 1, 'Administración');
INSERT INTO pui_profile_tra VALUES ('ADMIN_PUI', 'en', 1, 'Administration');
INSERT INTO pui_profile_tra VALUES ('ADMIN_PUI', 'fr', 1, 'Administration');
INSERT INTO pui_profile_tra VALUES ('ADMIN_PUI', 'ca', 1, 'Administració');

INSERT INTO pui_profile VALUES ('ANONYMOUS');
INSERT INTO pui_profile_tra VALUES ('ANONYMOUS', 'es', 1, 'Anónimo');
INSERT INTO pui_profile_tra VALUES ('ANONYMOUS', 'en', 1, 'Anonymous');
INSERT INTO pui_profile_tra VALUES ('ANONYMOUS', 'fr', 1, 'Anonymous');
INSERT INTO pui_profile_tra VALUES ('ANONYMOUS', 'ca', 1, 'Anònim');

-- subsystems
INSERT INTO pui_subsystem VALUES ('PUI');
INSERT INTO pui_subsystem_tra VALUES ('PUI', 'es', 1, 'Administración de PUI');
INSERT INTO pui_subsystem_tra VALUES ('PUI', 'en', 1, 'PUI Administration');
INSERT INTO pui_subsystem_tra VALUES ('PUI', 'fr', 1, 'Administration de PUI');
INSERT INTO pui_subsystem_tra VALUES ('PUI', 'ca', 1, 'Administració de PUI');

INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_AUDIT', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('ACTION_PUI_AUDIT', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_FUNCTIONALITY', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_LANGUAGE', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_LANGUAGE', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_PROFILE', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_PROFILE', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_USER', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_USER', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('CHANGE_USER_PASSWORDS', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('UPDATE_CURRENT_USER', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_VARIABLE', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_VARIABLE', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_GENERATED_ENTITY', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_GENERATED_ENTITY', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('GEN_PUI_GENERATED_ENTITY', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('LIST_LOGIN', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('LIST_PUI_SESSIONS', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('KILL_PUI_SESSIONS', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('EXECUTE_IMPORT_EXPORT', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('EXECUTE_COPY', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_ELASTICSEARCH', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_ELASTICSEARCH', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('ADMIN_ELASTICSEARCH', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_DOCGEN', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('GEN_PUI_DOCGEN', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_DOCUMENT', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_DOCUMENT', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_WIDGET', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_WIDGET', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_DASHBOARD', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_DASHBOARD', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('MENU_PUI_WIDGET', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PUI_ALERT', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('WRITE_PUI_ALERT', 'PUI');

INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_AUDIT', 'es', 1, 'Visualización de auditoría');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_AUDIT', 'en', 1, 'View PUI Audit');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_AUDIT', 'fr', 1, 'View PUI Audit');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_AUDIT', 'ca', 1, 'Visualització d''auditoria');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ACTION_PUI_AUDIT', 'es', 1, 'Acción para ver la auditoría');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ACTION_PUI_AUDIT', 'en', 1, 'PUI Audit action');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ACTION_PUI_AUDIT', 'fr', 1, 'PUI Audit action');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ACTION_PUI_AUDIT', 'ca', 1, 'Acció per a veure l''auditoria');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_FUNCTIONALITY', 'es', 1, 'Visualización de funcionalidades');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_FUNCTIONALITY', 'en', 1, 'View funcionalities');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_FUNCTIONALITY', 'fr', 1, 'View funcionalities');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_FUNCTIONALITY', 'ca', 1, 'Visualització de funcionalitats');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_LANGUAGE', 'es', 1, 'Visualización de Idiomas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_LANGUAGE', 'en', 1, 'View languages');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_LANGUAGE', 'fr', 1, 'View languages');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_LANGUAGE', 'ca', 1, 'Visualització d''idiomes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_LANGUAGE', 'es', 1, 'Edición de Idiomas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_LANGUAGE', 'en', 1, 'Manage languages');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_LANGUAGE', 'fr', 1, 'Manage languages');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_LANGUAGE', 'ca', 1, 'Edició d''idiomes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_PROFILE', 'es', 1, 'Visualización de perfiles');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_PROFILE', 'en', 1, 'View profiles');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_PROFILE', 'fr', 1, 'View profiles');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_PROFILE', 'ca', 1, 'Visualització de perfils');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_PROFILE', 'es', 1, 'Edición de perfiles');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_PROFILE', 'en', 1, 'Manage profiles');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_PROFILE', 'fr', 1, 'Manage profiles');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_PROFILE', 'ca', 1, 'Edició de perfils');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_USER', 'es', 1, 'Visualización de usuarios');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_USER', 'en', 1, 'View application users');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_USER', 'fr', 1, 'View application users');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_USER', 'ca', 1, 'Visualització d''usuaris');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_USER', 'es', 1, 'Edición de usuarios');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_USER', 'en', 1, 'Manage application users');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_USER', 'fr', 1, 'Manage application users');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_USER', 'ca', 1, 'Edició d''usuaris');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('CHANGE_USER_PASSWORDS', 'es', 1, 'Modificar contraseñas de los usuarios');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('CHANGE_USER_PASSWORDS', 'en', 1, 'Modify users passwords');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('CHANGE_USER_PASSWORDS', 'fr', 1, 'Modifier les mots de passe des utilisateurs');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('CHANGE_USER_PASSWORDS', 'ca', 1, 'Modificar contrasenyes dels usuaris');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('UPDATE_CURRENT_USER', 'es', 1, 'Modificar usuario actual');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('UPDATE_CURRENT_USER', 'en', 1, 'Modify current user');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('UPDATE_CURRENT_USER', 'fr', 1, 'Modifier l''utilisateur actuel');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('UPDATE_CURRENT_USER', 'ca', 1, 'Modificar usuari actual');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_VARIABLE', 'es', 1, 'Visualización de variables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_VARIABLE', 'en', 1, 'View variable');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_VARIABLE', 'fr', 1, 'View variable');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_VARIABLE', 'ca', 1, 'Visualització de variables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_VARIABLE', 'es', 1, 'Edición de variables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_VARIABLE', 'en', 1, 'Manage variable');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_VARIABLE', 'fr', 1, 'Manage variable');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_VARIABLE', 'ca', 1, 'Edició de variables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_GENERATED_ENTITY', 'es', 1, 'Visualización para tablas generadas automáticamente');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_GENERATED_ENTITY', 'en', 1, 'View autogen tables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_GENERATED_ENTITY', 'fr', 1, 'View autogen tables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_GENERATED_ENTITY', 'ca', 1, 'Visualització de taules generades automàticament');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_GENERATED_ENTITY', 'es', 1, 'Edición de tablas generadas automáticamente');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_GENERATED_ENTITY', 'en', 1, 'Manage autogen tables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_GENERATED_ENTITY', 'fr', 1, 'Manage autogen tables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_GENERATED_ENTITY', 'ca', 1, 'Edició de taules generades automàticament');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_GENERATED_ENTITY', 'es', 1, 'Generación automática de tablas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_GENERATED_ENTITY', 'en', 1, 'Generate autogen tables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_GENERATED_ENTITY', 'fr', 1, 'Generate autogen tables');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_GENERATED_ENTITY', 'ca', 1, 'Generació automàtica de taules');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_LOGIN', 'es', 1, 'Visualización de logins');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_LOGIN', 'en', 1, 'View PUI Logins');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_LOGIN', 'fr', 1, 'View PUI Logins');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_LOGIN', 'ca', 1, 'Visualització de logins');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_PUI_SESSIONS', 'es', 1, 'Listar sesiones abiertas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_PUI_SESSIONS', 'en', 1, 'List opened sessions');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_PUI_SESSIONS', 'fr', 1, 'Liste des sessions ouvertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('LIST_PUI_SESSIONS', 'ca', 1, 'Llistar sessions obertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('KILL_PUI_SESSIONS', 'es', 1, 'Eliminar sesiones abiertas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('KILL_PUI_SESSIONS', 'en', 1, 'Remove opened sessions');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('KILL_PUI_SESSIONS', 'fr', 1, 'Supprimer les sessions ouvertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('KILL_PUI_SESSIONS', 'ca', 1, 'Eliminar sessions obertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_IMPORT_EXPORT', 'ca', 1, 'Acció de Import/Export');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_IMPORT_EXPORT', 'en', 1, 'Action Import/Export');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_IMPORT_EXPORT', 'fr', 1, 'Action Import/Export');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_IMPORT_EXPORT', 'es', 1, 'Acción de Import/Export');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_COPY', 'es', 1, 'Acción de Copiar Registro');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_COPY', 'en', 1, 'Action Copy Registry');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_COPY', 'fr', 1, 'Action copier un document');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('EXECUTE_COPY', 'ca', 1, 'Acció de Copiar Registre');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_ELASTICSEARCH', 'es', 1, 'Consultas ElasticSearch');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_ELASTICSEARCH', 'en', 1, 'ElasticSearch requests');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_ELASTICSEARCH', 'fr', 1, 'ElasticSearch demandes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_ELASTICSEARCH', 'ca', 1, 'Consultes ElasticSearch');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_ELASTICSEARCH', 'es', 1, 'Modificaciones ElasticSearch');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_ELASTICSEARCH', 'en', 1, 'ElasticSearch modifications');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_ELASTICSEARCH', 'fr', 1, 'ElasticSearch modifications');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_ELASTICSEARCH', 'ca', 1, 'Modificacions ElasticSearch');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ADMIN_ELASTICSEARCH', 'es', 1, 'Administrar ElasticSearch');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ADMIN_ELASTICSEARCH', 'en', 1, 'Manage modifications');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ADMIN_ELASTICSEARCH', 'fr', 1, 'ElasticSearch admin');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('ADMIN_ELASTICSEARCH', 'ca', 1, 'Administrar ElasticSearch');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCGEN', 'es', 1, 'Edición de Generación de Documentos');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCGEN', 'en', 1, 'Manage Document Generation');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCGEN', 'fr', 1, 'Manage Document Generation');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCGEN', 'ca', 1, 'Edició de Generació de Documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_DOCGEN', 'es', 1, 'Generación de Documentos');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_DOCGEN', 'en', 1, 'Document Generation');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_DOCGEN', 'fr', 1, 'Document Generation');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('GEN_PUI_DOCGEN', 'ca', 1, 'Generació de Documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DOCUMENT', 'es', 1, 'Visualización de documentos adjuntos');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DOCUMENT', 'en', 1, 'View documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DOCUMENT', 'fr', 1, 'View documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DOCUMENT', 'ca', 1, 'Visualització de documents adjunts');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCUMENT', 'es', 1, 'Edición documentos');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCUMENT', 'en', 1, 'Manage documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCUMENT', 'fr', 1, 'Manage documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DOCUMENT', 'ca', 1, 'Edició de documents');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_WIDGET', 'es', 1, 'Visualización de widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_WIDGET', 'en', 1, 'View PUI Widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_WIDGET', 'fr', 1, 'View PUI Widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_WIDGET', 'ca', 1, 'Visualització de widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_WIDGET', 'es', 1, 'Edición de widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_WIDGET', 'en', 1, 'Manage PUI Widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_WIDGET', 'fr', 1, 'Manage PUI Widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_WIDGET', 'ca', 1, 'Edició de widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DASHBOARD', 'es', 1, 'Visualización de dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DASHBOARD', 'en', 1, 'View PUI Dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DASHBOARD', 'fr', 1, 'View PUI Dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_DASHBOARD', 'ca', 1, 'Visualització de dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DASHBOARD', 'es', 1, 'Edición de dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DASHBOARD', 'en', 1, 'Manage PUI Dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DASHBOARD', 'fr', 1, 'Manage PUI Dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_DASHBOARD', 'ca', 1, 'Edició de dashboard');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_WIDGET', 'es', 1, 'Menú de PUI widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_WIDGET', 'en', 1, 'Menu PUI Widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_WIDGET', 'fr', 1, 'Menu PUI Widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_WIDGET', 'ca', 1, 'Menú de PUI widgets');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_ALERT', 'es', 1, 'Visualización de alertas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_ALERT', 'en', 1, 'View alerts');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_ALERT', 'fr', 1, 'Affichage des alertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PUI_ALERT', 'ca', 1, 'Visualització d''alertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_ALERT', 'es', 1, 'Edición alertas');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_ALERT', 'en', 1, 'Manage alerts');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_ALERT', 'fr', 1, 'Modification des alertes');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('WRITE_PUI_ALERT', 'ca', 1, 'Edició d''alertes');

-- profile-functionalities
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_AUDIT');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'ACTION_PUI_AUDIT');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_FUNCTIONALITY');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_LANGUAGE');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_LANGUAGE');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_PROFILE');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_PROFILE');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_USER');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_USER');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'CHANGE_USER_PASSWORDS');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'UPDATE_CURRENT_USER');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_VARIABLE');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_VARIABLE');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_GENERATED_ENTITY');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_GENERATED_ENTITY');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'GEN_PUI_GENERATED_ENTITY');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'LIST_LOGIN');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'LIST_PUI_SESSIONS');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'KILL_PUI_SESSIONS');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_DOCGEN');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'GEN_PUI_DOCGEN');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_DOCUMENT');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_DOCUMENT');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'EXECUTE_IMPORT_EXPORT');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'EXECUTE_COPY');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_ELASTICSEARCH');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_ELASTICSEARCH');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'ADMIN_ELASTICSEARCH');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_WIDGET');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_WIDGET');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_DASHBOARD');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_DASHBOARD');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'MENU_PUI_WIDGET');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'READ_PUI_ALERT');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'WRITE_PUI_ALERT');


-- menu
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(1000, NULL, NULL, NULL, NULL, 'menu.accounts', 'fal fa-users');
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(1001, 1000, 'puiuser', NULL, 'WRITE_PUI_USER', 'menu.puiuser', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(1002, 1000, 'puiprofile', NULL, 'READ_PUI_PROFILE', 'menu.puiprofile', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(1003, 1000, 'puifunctionality', NULL, 'READ_PUI_FUNCTIONALITY', 'menu.puifunctionality', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2000, NULL, NULL, NULL, NULL, 'menu.configuration', 'fal fa-sliders-h');
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2001, 2000, 'puilanguage', NULL, 'WRITE_PUI_LANGUAGE', 'menu.puilanguage', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2002, 2000, 'puivariable', NULL, 'WRITE_PUI_VARIABLE', 'menu.puivariable', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2003, 2000, NULL, NULL, NULL, 'menu.elasticsearch', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2004, 2000, 'puiaudit', NULL, 'LIST_LOGIN', 'menu.puiaudit', NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2005, 2000, NULL, 'session', 'LIST_PUI_SESSIONS', 'menu.puisession', NULL);
-- INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2006, 2000, 'puidocgentemplate', NULL, 'GEN_PUI_DOCGEN', 'menu.puidocgen', NULL);
-- INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2007, 2000, 'puialertconfiguration', NULL, 'WRITE_PUI_ALERT', 'menu.puialertconfiguration', NULL);
-- INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(2008, 2000, 'puialert', NULL, 'READ_PUI_ALERT', 'menu.puialert', NULL);


-- users
INSERT INTO pui_user VALUES ('admin', 'Admin', '$2a$10$z7T1x/t8rhJgPLA/0DijL.4XQXeruaRkYweDx3h.OrlvS0M04vHAm', 'es', 'admin@prodevelop.es', 0, NULL,'dd/MM/yyyy',NULL,NULL,NULL,NULL,'0','0',NULL,null); -- admin
INSERT INTO pui_user VALUES ('anonymous', 'Anonymous', '$2a$10$QxVszsreux9jwGHPP5Sh/.wqVyWcIBP69O.AjeA4qc62Ya4RY7lKS', 'es', 'anonymous@prodevelop.es', 0, null,'dd/MM/yyyy',NULL,NULL,null,NULL,'0','0',NULL,null); -- anonymous

-- users-profiles
INSERT INTO pui_user_profile VALUES ('admin', 'ADMIN_PUI');
INSERT INTO pui_user_profile VALUES ('anonymous', 'ANONYMOUS');

-- variables
-- LDAP_PASSWORD, MAIL_SMTP_PASS, SESSION_JWT_SECRET values are
-- encrypted with AES using the secret '01234567890123456789012345678901'
INSERT INTO pui_variable (variable, value, description) VALUES('ALERTS_EXECUTOR_DELAY', '10', 'tiempo en minutos para ejecutar el proceso de envío de alertas por email');
INSERT INTO pui_variable (variable, value, description) VALUES('APPLICATION_LEGAL_TEXT', '-', 'Texto legal de la aplicación');
INSERT INTO pui_variable (variable, value, description) VALUES('APPLICATION_NAME', 'APPNAME', 'Nombre de la aplicación');
INSERT INTO pui_variable (variable, value, description) VALUES('BASE_CLIENT_URL', 'http://localhost/admin', 'URL base de la web cliente');
INSERT INTO pui_variable (variable, value, description) VALUES('DEVELOPMENT_ENVIRONMENT', 'true', 'indica si estamos en el entorno de desarrollo-preproducción o producción (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCGEN_PATH', '/var/www/html/app/docgen', 'ruta absoluta donde se almacenan las plantillas para generación de documentos');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCUMENTS_BASE_URL', '-', 'URL base para obtener ficheros adjuntos a través del Apache. Ejemplo: ''http://localhost/appdocs/''. Si no se quiere, poner valor ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCUMENTS_CLEAN_ENABLED', 'false', 'habilita el proceso de limpieza de Documentos no existentes (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCUMENTS_PATH', '/var/www/html/app/documents', 'ruta absoluta donde se almacenan los documentos adjuntos');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCUMENTS_THUMBNAILS_CROP', 'true', 'indica si las imágenes se deben cortar en caso de tener que reducir su tamaño (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCUMENTS_THUMBNAILS_GENERATE', 'false', 'indica si se deben generar thumbnails (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('DOCUMENTS_THUMBNAILS_VALUES', '150x150,240x180,640x480', 'lista separada por comas de los tamaños de los thumbnails para documentos adjuntos de tipo imagen');
INSERT INTO pui_variable (variable, value, description) VALUES('ELASTICSEARCH_ACTIVE', 'true', 'Si Elastic Search está activado para la aplicación o no (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('FCM_ENABLED', 'true', 'indica si las notificaciones push están habilitadas o no (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('FCM_TOPIC_PREFIX', 'DESA_', 'Prefijo para los topics. Se recomienda que contenga el nombre del entorno de despliegue (DESA_/PRE_/PRO_)');
INSERT INTO pui_variable (variable, value, description) VALUES('GRIDFILTER_SHOW_SQL_BTN', 'false', 'true/false, indica si se debe mostrar el botón SQL en la definición de filtros de usuario');
INSERT INTO pui_variable (variable, value, description) VALUES('GRIDFILTER_SHOW_SUBGROUP_BTN', 'false', 'true/false, indica si se debe mostrar el botón añadir subgrupo en la definición de filtros de usuario');
INSERT INTO pui_variable (variable, value, description) VALUES('IMPORTEXPORT_PATH', '/var/www/html/app/importexport', 'ruta absoluta donde se almacenan los ficheros de import/export');
INSERT INTO pui_variable (variable, value, description) VALUES('LDAP_ACTIVE', 'false', 'Indica si el LDAP está activo o no (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('LDAP_DOMAIN', 'prode_domi.es', 'Dominio a usar en el LDAP. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('LDAP_PASSWORD', '-', 'Password del usuario de conexión al LDAP. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('LDAP_URL', 'ldap://130.0.2.90:389', 'URL del servidor LDAP en formato ldap://server:ip. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('LDAP_USER', 'ldapI1803', 'Usuario de conexión al LDAP. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('LOGIN_ALLOW_ANONYMOUS', 'true', 'permitir sesiones de usuarios anónimos (usuario anonymous)');
INSERT INTO pui_variable (variable, value, description) VALUES('LOGIN_ENABLE_2FA', 'false', 'Habilitar/Deshabilitar doble factor de autenticación (2FA) mediante QR a nivel de aplicación (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('LOGIN_MAX_ATTEMPTS', '-', 'Número máximo de intentos de login antes de ser bloqueado. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_FROM', 'no-reply@prodevelop.es', 'Email por defecto para el FROM. Especificar ''-'' si no se quiere valor');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_SMTP_AUTH', 'true', 'Usar autenticación en el servidor SMTP (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_SMTP_HOST', 'smtp.office365.com', 'Host SMTP. Especificar ''-'' si no se quiere valor');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_SMTP_PASS', '-', 'Contraseña del usuario SMTP. Especificar ''-'' si no se quiere valor');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_SMTP_PORT', '587', 'Puerto SMTP. Especificar ''-'' si no se quiere valor');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_SMTP_STARTTLS_ENABLE', 'true', 'Usar seguridad TLS en el servidor SMTP (true/false)');
INSERT INTO pui_variable (variable, value, description) VALUES('MAIL_SMTP_USER', 'no-reply@prodevelop.es', 'Usuario SMTP. Especificar ''-'' si no se quiere valor');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_CHANGE_MAIL_SUBJECT_LABEL_ID', '-', 'Etiqueta de traducción del título del email de cambio de contraseña. ''-'' para valor por defecto del framework');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_EXPIRATION_DAYS', '-', 'Periodo de validez de la contraseña (en días). Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_EXPIRATION_MAIL_NOTIFY', 'false', 'Indica si se debe notificar por email a los usuarios cuando su contraseña está a punto de expirar. true/false');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_EXPIRATION_MAIL_SUBJECT_LABEL_ID', '-', 'Etiqueta de traducción del título del email de expiración de contraseña. ''-'' para valor por defecto del framework');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_PATTERN', '-', 'Patrón que la contraseña debe cumplir. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_PATTERN_INFO', '-', 'Descripción del patrón. Puede ser un JSON con un valor para cada idioma. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('PASSWORD_REMEMBER_DAYS', '-', 'Recordar cambio de contraseña a los usuarios con N días de antelación. Si no se quiere, especificar ''-''');
INSERT INTO pui_variable (variable, value, description) VALUES('SESSION_JWT_SECRET', 'dwMJYDwMsisLVvWS1O/lA9V1W6lcd60ToK7rghYAt/1Gr5gWNOJECAe1W9WUMvTro4Ulia+mNy0Fa2xZakGj0dFlGvoImCMGhY1M5uX/ni92mhl3yf3QfbD7s0pidZe+', 'clave secreta para cifrar los tokens JWT');
INSERT INTO pui_variable (variable, value, description) VALUES('SESSION_PERSISTENT_DURATION', '30', 'Tiempo en días que una sesión persistente estará vigente desde la última vez que se usó');
INSERT INTO pui_variable (variable, value, description) VALUES('SESSION_RECREATE_IF_NOT_IN_DB', 'false', 'Recrear la sesión aún si no existe en BBDD. Se recomienda tenerlo a ''false''');
INSERT INTO pui_variable (variable, value, description) VALUES('SESSION_TIMEOUT', '30', 'tiempo en minutos para invalidar la sesión de usuario');

-- Menu & Funcionality Kibana
INSERT INTO pui_functionality (functionality, subsystem) VALUES('MENU_PUI_DASHBOARD_KIBANA', 'PUI');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_KIBANA', 'es', 1, 'Visualización de BKPI');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_KIBANA', 'en', 1, 'View BKPI');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_KIBANA', 'fr', 1, 'Visualisation de BKPI');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_KIBANA', 'ca', 1, 'Visualització de BKPI');
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(900, NULL, NULL, 'business-kpi', 'MENU_PUI_DASHBOARD_KIBANA', 'dashboard.kibana', 'far fa-analytics');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'MENU_PUI_DASHBOARD_KIBANA');
INSERT INTO pui_variable (variable, value, description) VALUES('BUSINESS_KPI_URL', 'http://localhost:30180/', 'Elasticsearch URL');


-- Menu & Funcionality Promtheus
INSERT INTO pui_functionality (functionality, subsystem) VALUES('MENU_PUI_DASHBOARD_PROMETHEUS', 'PUI');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_PROMETHEUS', 'es', 1, 'Visualización de Prometheus');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_PROMETHEUS', 'en', 1, 'View Prometheus');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_PROMETHEUS', 'fr', 1, 'Visualisation de Prometheus');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('MENU_PUI_DASHBOARD_PROMETHEUS', 'ca', 1, 'Visualització de Prometheus');
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(910, NULL, NULL, 'prometheus', 'MENU_PUI_DASHBOARD_PROMETHEUS', 'dashboard.prometheus', 'far fa-fire');
INSERT INTO pui_profile_functionality (profile, functionality) VALUES('ADMIN_PUI', 'MENU_PUI_DASHBOARD_PROMETHEUS');
INSERT INTO pui_variable (variable, value, description) VALUES('PROMETHEUS_URL', 'http://localhost:50000/', 'Prometheus URL');
