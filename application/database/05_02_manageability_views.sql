CREATE VIEW v_device AS
 SELECT device.id,
    device.name,
    device.description
   FROM device;

CREATE VIEW v_helmrepository AS
 SELECT helmrepository._id,
    helmrepository.name,
    helmrepository.description,
    helmrepository.schema_version,
    helmrepository.type,
    helmrepository.url
   FROM helmrepository;