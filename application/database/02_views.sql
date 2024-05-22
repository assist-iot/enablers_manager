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


CREATE VIEW v_pui_docgen_template AS
SELECT
	dt.id,
	dt.name,
	dt.description, 
	dt.main_model,
	dt.models,
	dt.column_filename,
	dm.label,
	dt.filename
FROM pui_docgen_template dt
LEFT JOIN pui_docgen_model dm ON
	dm.model = dt.main_model;

CREATE VIEW v_pui_widget_type AS
SELECT
   ID,
   NAME,
   TYPE,
   COMPONENT,
   DEFINITION
FROM PUI_WIDGET_TYPE;

CREATE VIEW v_pui_widget AS
SELECT
   W.ID,
   W.NAME,
   W.TYPEID,
   WT.TYPE,
   WT.COMPONENT,
   W.DEFINITION
FROM PUI_WIDGET W
LEFT JOIN PUI_WIDGET_TYPE WT ON
   W.TYPEID = WT.ID;

CREATE VIEW v_pui_dashboard AS
SELECT
   ID,
   NAME,
   DEFINITION
FROM PUI_DASHBOARD;

CREATE VIEW v_pui_document AS
SELECT
	d.id,
	d.model,
	d.pk,
	d.description,
	d.language,
	d.filename,
	d.filename_orig,
	d.role,
	dr_tra.description as role_description,
	d.thumbnails,
	case
		when (select count(1) from pui_variable v where v.variable = 'DOCUMENTS_BASE_URL' and v.value <> '-') = 1 then
			(select v.value from pui_variable v where v.variable = 'DOCUMENTS_BASE_URL')
			|| d.model || '/'
			|| d.pk || '/'
			|| d.filename
		else null
	end as url,
	d.datetime,
	dr_tra.lang
FROM pui_document d
LEFT JOIN pui_document_role dr ON
	dr.role = d.role
LEFT JOIN pui_document_role_tra dr_tra ON
	dr_tra.role = dr.role;

CREATE VIEW v_pui_docgen_model AS
SELECT
	dm.model,
	m.entity,
	dm.label || ' (' || m.entity || ')' AS label,
	dm.identity_fields
FROM pui_docgen_model dm
LEFT JOIN pui_model m ON
	m.model = dm.model;