CREATE TABLE device (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL
);

CREATE TABLE helmrepository (
    _id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    schema_version character varying,
    type character varying,
    url character varying
);