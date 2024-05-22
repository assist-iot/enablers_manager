-- models
INSERT INTO pui_model VALUES ('device', 'v_device', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model VALUES ('helmrepository', 'v_helmrepository', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model VALUES ('k8scluster', 'v_k8scluster', '{"order":[{"column":"_id","direction":"asc"}]}', NULL);
INSERT INTO pui_model VALUES ('enabler', 'v_enabler', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model VALUES ('cars', 'v_cars', '{"order":[{"column":"name","direction":"asc"}]}', NULL);
INSERT INTO pui_model VALUES ('pilot3b', 'v_pilot3b', '{"order":[{"column":"name","direction":"asc"}]}', NULL);

-- profiles
INSERT INTO pui_profile VALUES ('ASSIST');
INSERT INTO pui_profile_tra VALUES ('ASSIST', 'es', 1, 'Assist-IoT');
INSERT INTO pui_profile_tra VALUES ('ASSIST', 'en', 1, 'Assist-IoT');
INSERT INTO pui_profile_tra VALUES ('ASSIST', 'fr', 1, 'Assist-IoT');
INSERT INTO pui_profile_tra VALUES ('ASSIST', 'ca', 1, 'Assist-IoT');

-- functionality
INSERT INTO pui_functionality VALUES ('VIEW_ASSISTIOT_COMPONENTS', 'PUI');
INSERT INTO pui_functionality VALUES ('READ_DEVICE', 'PUI');
INSERT INTO pui_functionality VALUES ('WRITE_DEVICE', 'PUI');
INSERT INTO pui_functionality VALUES ('READ_HELM_REPOSITORY', 'PUI');
INSERT INTO pui_functionality VALUES ('WRITE_HELM_REPOSITORY', 'PUI');
INSERT INTO pui_functionality VALUES ('READ_K8S_CLUSTER', 'PUI');
INSERT INTO pui_functionality VALUES ('WRITE_K8S_CLUSTER', 'PUI');
INSERT INTO pui_functionality VALUES ('READ_GROUP_OF_CARS', 'PUI');
INSERT INTO pui_functionality VALUES ('READ_CARS', 'PUI');
INSERT INTO pui_functionality VALUES ('READ_ENABLER', 'PUI');
INSERT INTO pui_functionality VALUES ('WRITE_ENABLER', 'PUI');
INSERT INTO pui_functionality VALUES ('PLUGINS', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('PILOT_3B', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PILOT3B_CLOUD_DASH', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PILOT3B_EDGE_DASH', 'PUI');
INSERT INTO pui_functionality (functionality, subsystem) VALUES('READ_PILOT3B_FL', 'PUI');

-- functionality translations
INSERT INTO pui_functionality_tra VALUES ('VIEW_ASSISTIOT_COMPONENTS', 'es', 1, 'Componentes de prueba');
INSERT INTO pui_functionality_tra VALUES ('READ_DEVICE', 'es', 1, 'Visualización de dispositivos');
INSERT INTO pui_functionality_tra VALUES ('WRITE_DEVICE', 'es', 1, 'Edición de dispositivos');
INSERT INTO pui_functionality_tra VALUES ('READ_HELM_REPOSITORY', 'es', 1, 'Repositorios de Helm');
INSERT INTO pui_functionality_tra VALUES ('READ_HELM_REPOSITORY', 'en', 1, 'Helm repositories');
INSERT INTO pui_functionality_tra VALUES ('WRITE_HELM_REPOSITORY', 'es', 1, 'Edición de repositorios Helm');
INSERT INTO pui_functionality_tra VALUES ('WRITE_HELM_REPOSITORY', 'en', 1, 'Manage Helm repositories');
INSERT INTO pui_functionality_tra VALUES ('READ_K8S_CLUSTER', 'es', 1, 'Clusters de K8s');
INSERT INTO pui_functionality_tra VALUES ('READ_K8S_CLUSTER', 'en', 1, 'K8s Clusters');
INSERT INTO pui_functionality_tra VALUES ('READ_CARS', 'es', 1, 'Coches');
INSERT INTO pui_functionality_tra VALUES ('READ_CARS', 'en', 1, 'Cars');
INSERT INTO pui_functionality_tra VALUES ('READ_GROUP_OF_CARS', 'es', 1, 'Grupo de Coches');
INSERT INTO pui_functionality_tra VALUES ('READ_GROUP_OF_CARS', 'en', 1, 'Group of Cars');
INSERT INTO pui_functionality_tra VALUES ('WRITE_K8S_CLUSTER', 'es', 1, 'Edición de clusters de K8s');
INSERT INTO pui_functionality_tra VALUES ('WRITE_K8S_CLUSTER', 'en', 1, 'Manage K8s clusters');
INSERT INTO pui_functionality_tra VALUES ('READ_ENABLER', 'es', 1, 'Enablers');
INSERT INTO pui_functionality_tra VALUES ('READ_ENABLER', 'en', 1, 'Enablers');
INSERT INTO pui_functionality_tra VALUES ('WRITE_ENABLER', 'es', 1, 'Edición de enablers');
INSERT INTO pui_functionality_tra VALUES ('WRITE_ENABLER', 'en', 1, 'Manage enablers');
INSERT INTO pui_functionality_tra VALUES ('PLUGINS', 'es', 1, 'Plugins');
INSERT INTO pui_functionality_tra VALUES ('PLUGINS', 'en', 1, 'Plugins');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('PILOT_3B', 'es', 1, 'Visualización de Pilot3b');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('PILOT_3B', 'en', 1, 'View Pilot3b');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PILOT3B_CLOUD_DASH', 'es', 1, 'Visualización del dashboard en cloud piloto3b');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PILOT3B_CLOUD_DASH', 'en', 1, 'Cloud dashboard view Pilot3b');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PILOT3B_EDGE_DASH', 'es', 1, 'Visualización del dashboard en edge piloto3b');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PILOT3B_EDGE_DASH', 'en', 1, 'Edge dashboard view Pilot3b');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PILOT3B_FL', 'es', 1, 'Visualización del enabler FL');
INSERT INTO pui_functionality_tra (functionality, lang, lang_status, "name") VALUES('READ_PILOT3B_FL', 'en', 1, 'FL View Pilot3b');
-- menu
INSERT INTO pui_menu VALUES (4000,NULL,NULL,NULL,NULL,'menu.clustersdevices','far fa-chart-network');
INSERT INTO pui_menu VALUES (4001,4000,'k8scluster','k8scluster','READ_K8S_CLUSTER','menu.k8scluster',NULL);
INSERT INTO pui_menu VALUES (4002,4000,'k8scluster','clustertopology','READ_K8S_CLUSTER','menu.clustertopology',NULL);
INSERT INTO pui_menu VALUES (4003,4000,'device','device','READ_DEVICE','menu.device',NULL);
INSERT INTO pui_menu VALUES (5000,NULL,NULL,NULL,NULL,'menu.enablers','fal fa-laptop-code');
INSERT INTO pui_menu VALUES (5001,5000,'helmrepository','helmrepository','READ_HELM_REPOSITORY','menu.helmrepository',NULL);
INSERT INTO pui_menu VALUES (5002,5000,'enabler','enabler','READ_ENABLER','menu.enabler',NULL);
INSERT INTO pui_menu VALUES (6000,NULL,NULL,'plugins', 'PLUGINS','menu.plugins','far fa-analytics');
INSERT INTO pui_menu VALUES (8000,NULL,NULL,NULL,NULL,'menu.cars','fas fa-car');
INSERT INTO pui_menu VALUES (8004,8000,'cars','groupofcars','READ_GROUP_OF_CARS','menu.groupofcars',NULL);
INSERT INTO pui_menu VALUES (8005,8000,'cars','cars','READ_CARS','menu.cars',NULL);
INSERT INTO pui_menu VALUES (8006,8000,'cars','pilot3a','READ_CARS','menu.pilot3a',NULL);
INSERT INTO pui_menu (node, parent, model, component, functionality, "label", icon_label) VALUES(9000, NULL, NULL, NULL, NULL, 'menu.pilot3b', 'fa-regular fa-garage');
INSERT INTO pui_menu VALUES (9001,9000,'pilot3b','pilot3bcloud','READ_PILOT3B_CLOUD_DASH','menu.pilot3bclouddash',NULL);
INSERT INTO pui_menu VALUES (9002,9000,'pilot3b','pilot3bedge','READ_PILOT3B_EDGE_DASH','menu.pilot3bedgedash',NULL);
INSERT INTO pui_menu VALUES (9003,9000,'pilot3b','pilot3bfl','READ_PILOT3B_FL','menu.pilot3bfl',NULL);
-- profile-functionalities
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'READ_DEVICE');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'WRITE_DEVICE');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'READ_HELM_REPOSITORY');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'WRITE_HELM_REPOSITORY');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'READ_K8S_CLUSTER');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'READ_GROUP_OF_CARS');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'READ_CARS');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'WRITE_K8S_CLUSTER');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'READ_ENABLER');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI', 'WRITE_ENABLER');
INSERT INTO pui_profile_functionality VALUES ('ADMIN_PUI','PLUGINS');

INSERT INTO pui_profile_functionality VALUES ('ASSIST','UPDATE_CURRENT_USER');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','READ_ENABLER');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','READ_K8S_CLUSTER');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','WRITE_K8S_CLUSTER');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','WRITE_ENABLER');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','READ_HELM_REPOSITORY');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','WRITE_HELM_REPOSITORY');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','READ_DEVICE');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','WRITE_DEVICE');
INSERT INTO pui_profile_functionality VALUES ('ASSIST','PLUGINS');

-- users
INSERT INTO pui_user VALUES ('test', 'Test', '$2a$10$n051LmWG.14IyAHxsN06XeuUN9D5zzLo4Iu.NdIzgPtR9xp31N29K', 'en', 'test@assist.eu', 0, NULL, 'dd/MM/yyyy', NULL, '2022-03-24 17:39:46.148+01', '127.0.0.1', NULL, 0, 0, NULL, NULL);
INSERT INTO pui_user VALUES ('assist','Assist-IoT user','$2a$10$arP1Q.LFqwO0s5EeQr1Sx.MbxNQeEVaPpKUo9ZCdj3AkvB5fhy9ku','en','user@assist-iot.eu',0,NULL,'yyyy-MM-dd',NULL,'2022-06-10 12:19:16.568+02','127.0.0.1',NULL,0,0,NULL,NULL);
INSERT INTO pui_user VALUES ('operator','Assist-IoT PIlot3a user','$2a$10$arP1Q.LFqwO0s5EeQr1Sx.MbxNQeEVaPpKUo9ZCdj3AkvB5fhy9ku','en','operator@assist.eu',0,NULL,'yyyy-MM-dd',NULL,'2022-06-10 12:19:16.568+02','127.0.0.1',NULL,0,0,NULL,NULL);

-- users-profiles
INSERT INTO pui_user_profile VALUES ('test', 'ANONYMOUS');
INSERT INTO pui_user_profile VALUES ('assist', 'ASSIST');

-- widget type
INSERT INTO PUI_WIDGET_TYPE (NAME, TYPE, COMPONENT, DEFINITION) VALUES('PUI9 Basic Datatable', 'VuetifyDatatable', 'PuiWidgetDatatable', '{
   {
   "title":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.title",
      "value":null,
      "required":true
   },
   "entityName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.entity",
      "value":null,
      "required":true
   },
   "detailModel":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.detailModel",
      "value":null,
      "required":false
   },
   "detailPrimaryKey":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.detailPrimaryKey",
      "value":null,
      "required":false
   },
   "filter":{
      "component":"pui-text-area",
      "label":"form.puiwidget.definition.filter",
      "value":null,
      "required":false
   },
   "searchable":{
      "component":"pui-checkbox",
      "label":"form.puiwidget.definition.searchable",
      "value":true,
      "required":false
   },
   "hidePagination":{
      "component":"pui-checkbox",
      "label":"form.puiwidget.definition.hide_pagination",
      "value":false,
      "required":false
   }
}');
INSERT INTO PUI_WIDGET_TYPE (NAME, TYPE, COMPONENT, DEFINITION) VALUES('PUI9 Basic Bar Chart', 'EChartsBar', 'PuiWidgetEChart', '{
   "title":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.title",
      "value":null,
      "required":true
   },
   "entityName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.entity",
      "value":null,
      "required":true
   },
   "columnName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.name",
      "value":null,
      "required":true
   },
   "columnValue":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.value",
      "value":null,
      "required":true
   },
   "tooltipValue":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.tooltip",
      "value":null,
      "required":false
   },
   "chartOptions":{
      "component":"pui-text-area",
      "label":"form.puiwidget.definition.options",
      "value":null,
      "required":false
   }
}');
INSERT INTO PUI_WIDGET_TYPE (NAME, TYPE, COMPONENT, DEFINITION) VALUES('PUI9 Basic Line Chart', 'EChartsLine', 'PuiWidgetEChart', '{
   "title":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.title",
      "value":null,
      "required":true
   },
   "entityName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.entity",
      "value":null,
      "required":true
   },
   "columnName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.name",
      "value":null,
      "required":true
   },
   "columnValue":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.value",
      "value":null,
      "required":true
   }
}');
INSERT INTO PUI_WIDGET_TYPE (NAME, TYPE, COMPONENT, DEFINITION) VALUES('PUI9 Basic Pie Chart', 'EChartsPie', 'PuiWidgetEChart', '{
   "title":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.title",
      "value":null,
      "required":true
   },
   "entityName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.entity",
      "value":null,
      "required":true
   },
   "columnName":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.name",
      "value":null,
      "required":true
   },
   "columnValue":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.value",
      "value":null,
      "required":true
   },
   "tooltipValue":{
      "component":"pui-text-field",
      "label":"form.puiwidget.definition.tooltip",
      "value":null,
      "required":false
   },
   "chartOptions":{
      "component":"pui-text-area",
      "label":"form.puiwidget.definition.options",
      "value":null,
      "required":false
   },
   "theme":{
      "component":"pui-select",
      "label":"form.puiwidget.definition.echartstheme",
      "value":"roma",
      "required":true,
      "items":["infographic","dark","roma","vintage"]
   }
}');

INSERT INTO pui_dashboard VALUES (1, 'Test-dashboard', '[{"x":0,"y":0,"w":6,"h":13,"i":0,"widget":1,"moved":false,"resized":{"width":915,"height":491}}]');

INSERT INTO device VALUES (1, 'Device', 'An example device');
INSERT INTO device VALUES (2, 'IoT gate', 'IoT gateway');
INSERT INTO device VALUES (3, 'Other', 'Other device');

INSERT INTO pui_multi_instance_process VALUES ('PasswordValidityCheck', 1440, 'MINUTES', '7e66ae14-3fbb-4c4d-9c35-d81e2901b645', NULL, '2022-04-05 16:42:59.98+02');
INSERT INTO pui_multi_instance_process VALUES ('CleanResetPasswordToken', 30, 'MINUTES', '7e66ae14-3fbb-4c4d-9c35-d81e2901b645', '2022-04-05 16:43:00.733+02', '2022-04-05 16:43:00.459+02');
INSERT INTO pui_multi_instance_process VALUES ('SessionsDatabaseCleaner', 30, 'MINUTES', '7e66ae14-3fbb-4c4d-9c35-d81e2901b645', '2022-04-05 16:43:01.102+02', '2022-04-05 16:43:00.919+02');
INSERT INTO pui_multi_instance_process VALUES ('CleanImportExport', 1440, 'MINUTES', '7e66ae14-3fbb-4c4d-9c35-d81e2901b645', NULL, '2022-04-05 16:43:01.172+02');

INSERT INTO pui_widget VALUES (1, 'Test-devices', 1, '{"title":{"component":"pui-text-field","label":"form.puiwidget.definition.title","value":"Test-devices-widget","required":true},"entityName":{"component":"pui-text-field","label":"form.puiwidget.definition.entity","value":"device","required":true},"detailModel":{"component":"pui-text-field","label":"form.puiwidget.definition.detailModel","value":"device","required":false},"detailPrimaryKey":{"component":"pui-text-field","label":"form.puiwidget.definition.detailPrimaryKey","value":"id:Code,name:Name,description:Description","required":false},"filter":{"component":"pui-text-area","label":"form.puiwidget.definition.filter","value":null,"required":false},"searchable":{"component":"pui-checkbox","label":"form.puiwidget.definition.searchable","value":true,"required":false},"hidePagination":{"component":"pui-checkbox","label":"form.puiwidget.definition.hide_pagination","value":false,"required":false}}');
INSERT INTO pui_variable (variable, value, description) VALUES('PILOT_3B_CLOUD_DASHBOARD', 'http://localhost:30180/', 'Pilot 3B cloud dashboard URL');
INSERT INTO pui_variable (variable, value, description) VALUES('PILOT_3B_EDGE_DASHBOARD', 'http://localhost:30180/', 'Pilot 3B edge dashboard URL');
INSERT INTO pui_variable (variable, value, description) VALUES('PILOT_3B_FL_DASHBOARD', 'http://localhost:30180/', 'Pilot 3B FL dashboard URL');

