-- SCHEMA

CREATE SCHEMA  IF NOT EXISTS FinancialAdvisor;

USE FinancialAdvisor;
-- TABLES

CREATE TABLE IF NOT EXISTS designation_type
( 
	 designation_id SMALLINT NOT NULL
	, designation_code VARCHAR(10) NOT NULL 					
	, designation_desc VARCHAR(200) NULL						
	, designation_symbol_name VARCHAR(50) NULL 					
	, is_active BOOLEAN NOT NULL DEFAULT true
	, CONSTRAINT pk_designation_type PRIMARY KEY (designation_id)
);

CREATE TABLE IF NOT EXISTS state_code_type
(	state_code char(2) NOT NULL
	, state_name VARCHAR(35) NOT NULL
	, CONSTRAINT pk_state_code PRIMARY KEY (state_code)
);

CREATE TABLE IF NOT EXISTS title_type
(	title_id SMALLINT NOT NULL
 	, title_type_name VARCHAR(100) NOT NULL
 	, is_active BOOLEAN NOT NULL DEFAULT true
 	, create_date TIMESTAMP NOT NULL DEFAULT NOW()
 	, update_date TIMESTAMP  NULL
 	, CONSTRAINT pk_title_type PRIMARY KEY (title_id)
);

CREATE TABLE IF NOT EXISTS  website_type
( 
	website_type_id SMALLINT  NOT NULL
	, website_type_name VARCHAR(35) NOT NULL 
	, attribute_name VARCHAR(30) NOT NULL  CHECK (attribute_name IN ('Employee', 'Org','Team'))
 	, sort_order SMALLINT NOT NULL
 	, is_active BOOLEAN NOT NULL DEFAULT true
 	, create_date TIMESTAMP  NOT NULL DEFAULT NOW()
 	, update_date TIMESTAMP  NULL
 	, CONSTRAINT pk_website_type PRIMARY KEY (website_type_id)
);

CREATE TABLE IF NOT EXISTS phone_type
(
	phone_type_id SMALLINT NOT NULL
 	, phone_name VARCHAR(35) NOT NULL 
 	, attribute_name VARCHAR(30) NOT NULL CHECK (attribute_name IN ('Org', 'Employee'))
 	, sort_order SMALLINT NOT NULL
 	, is_active BOOLEAN NOT NULL DEFAULT true
	, create_date TIMESTAMP  NOT NULL DEFAULT NOW()
	, update_date TIMESTAMP  NULL
 	, CONSTRAINT pk_phone_type PRIMARY KEY (phone_type_id)
);

CREATE TABLE IF NOT EXISTS employee 
(
	employee_id INT NOT NULL -- GENERATED ALWAYS AS IDENTITY
	,first_name VARCHAR(35) NOT NULL   				--  (longest asof 5/26/22 = 13)
	,middle_name VARCHAR(35) NULL  	   				--  (longest asof 5/26/22 = 18, appears to be erroneous/in audit)
	,last_name VARCHAR(35) NOT NULL    				--  (longest asof 5/26/22 = 20)
	,suffix VARCHAR(35) NULL			   			--  (longest asof 5/26/22 = 3)
	,preferred_name VARCHAR(100) NULL   			--  (longest asof 5/26/22 = 32)	
	,is_active BOOLEAN NOT NULL DEFAULT true
	,photo_name VARCHAR(108) NULL
	,note VARCHAR(1000) NULL
	,created_by VARCHAR(50) NOT NULL   				--  (longest asof 5/26/22 = 24)
	,create_date TIMESTAMP  NOT NULL DEFAULT NOW()
	,updated_by VARCHAR(50) NULL	   				--  (longest asof 5/26/22 = 30)
    ,update_date TIMESTAMP NULL
	,CONSTRAINT pk_employee PRIMARY KEY (employee_id)
) ;


CREATE TABLE IF NOT EXISTS employee_designation 
(
    employee_designation_id INT NOT NULL
    , employee_id INT NOT NULL 
    , designation_id SMALLINT NOT NULL
	, created_by varchar(50) NOT NULL
    , create_date TIMESTAMP  NOT NULL DEFAULT NOW()
    ,CONSTRAINT pk_employee_designation PRIMARY KEY (employee_designation_id)
    , CONSTRAINT fk_employee_designation_designation_type FOREIGN KEY (designation_id)
        REFERENCES designation_type (designation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
    ,CONSTRAINT fk_employee_designation_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS employee_title
(
    employee_title_id integer NOT NULL,
    employee_id integer NOT NULL,
    title_id SMALLINT NOT NULL,
	created_by varchar(50) NOT NULL,
    create_date timestamp NOT NULL DEFAULT now(),
    CONSTRAINT pk_employee_title PRIMARY KEY (employee_title_id),
    CONSTRAINT fk_employee_title_title_type FOREIGN KEY (title_id)
        REFERENCES title_type (title_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_employee_title_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
     CONSTRAINT uc_employee_title_employee_id_title_id UNIQUE (employee_id, title_id)
);


CREATE TABLE IF NOT EXISTS employee_website
(
    employee_website_id integer NOT NULL,
    employee_id integer NOT NULL,
	website varchar(100) NOT NULL,
    website_type_id SMALLINT NOT NULL,
	created_by varchar(50) NOT NULL,
    create_date timestamp NOT NULL DEFAULT now(),
	updated_by varchar(50) NULL,
    update_date timestamp NULL,
    CONSTRAINT pk_employee_website PRIMARY KEY (employee_website_id),
    CONSTRAINT fk_employee_website_website_type FOREIGN KEY (website_type_id)
        REFERENCES website_type (website_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_employee_website_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	CONSTRAINT uc_employee_website_employee_id_website_type_id UNIQUE (employee_id, website_type_id)
);


CREATE TABLE IF NOT EXISTS postal_address
(
	postal_address_id INT NOT NULL
	,address_1 VARCHAR (50) NOT NULL
	,address_2 VARCHAR(50) NULL
	, city VARCHAR(50) NOT NULL
	, state_code CHAR(2) NOT NULL
	, zip_code VARCHAR(10) NOT NULL
	/*,[postal_address_hash] have to figure hashing out*/
	, CONSTRAINT pk_postal_address PRIMARY KEY (postal_address_id)
	-- uc below should be based on hash, which coalesces street_2, coalesce won't work in the constraint definition
    , CONSTRAINT uc_postal_address UNIQUE (address_1, address_2,city, state_code, zip_code)
    , CONSTRAINT fk_postal_address_state_code_type FOREIGN KEY (state_code)
        REFERENCES state_code_type (state_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS phone (
    phone_id INT NOT NULL,
    phone_number VARCHAR(30) NOT NULL,
    phone_extension VARCHAR(8) NULL,
    CONSTRAINT pk_phone PRIMARY KEY (phone_id),
    CONSTRAINT uc_phone_phone_number_phone_extension UNIQUE (phone_number , phone_extension)
);


CREATE TABLE IF NOT EXISTS employee_phone (
    employee_phone_id INT NOT NULL,
    employee_id INT NOT NULL,
    phone_id INT NOT NULL,
    phone_type_id SMALLINT NOT NULL,
    is_used BOOLEAN NOT NULL,
    is_preferred BOOLEAN NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    create_date TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_by VARCHAR(50) NULL,
    update_date TIMESTAMP NULL,
    CONSTRAINT pk_employee_phone PRIMARY KEY (employee_phone_id),
    CONSTRAINT uc_employee_phone_employee_id_phone_type_id UNIQUE (employee_id , phone_type_id),
    CONSTRAINT fk_employee_phone_phone_type FOREIGN KEY (phone_type_id)
        REFERENCES phone_type (phone_type_id)
        MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_employee_phone_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id)
        MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- HAVE TO FIGURE OUT OUT HOW TO ADD FILTERED INDEX
-- CREATE UNIQUE INDEX uix_employee_phone_is_preferred ON public.employee_phone (employee_id, is_preferred) WHERE is_preferred = true;

CREATE TABLE IF NOT EXISTS org
( 
  org_id int not null
  , org_code varchar(5) NULL 
  , org_name varchar(70) NOT NULL 
  , postal_address_id int NULL 
  , is_active BOOLEAN NOT NULL
  , note varchar(1000) NULL
  , CONSTRAINT pk_org PRIMARY KEY (org_id)
  , CONSTRAINT fk_org_postal_address
   FOREIGN KEY(postal_address_id) 
   REFERENCES postal_address(postal_address_id) Match SIMPLE
   ON DELETE NO ACTION
   ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS rep 
(    rep_id int not null	
    , rep_code VARCHAR(4) NOT NULL
	, CONSTRAINT pk_rep PRIMARY KEY (rep_id)
	,CONSTRAINT uc_rep_rep_code UNIQUE (rep_code)
);


CREATE TABLE IF NOT EXISTS employee_rep
(
    employee_rep_id int NOT NULL
    , employee_id int NOT NULL
    , rep_id int NOT NULL
    , created_by VARCHAR(50) NOT NULL
    , create_date TIMESTAMP NOT NULL DEFAULT NOW()
    , CONSTRAINT pk_employee_rep PRIMARY KEY (employee_rep_id)
    , CONSTRAINT fk_employeerep_employee
    FOREIGN KEY(employee_id) 
    REFERENCES employee(employee_id) Match SIMPLE
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    , CONSTRAINT fk_employeerep_rep
    FOREIGN KEY(rep_id) 
    REFERENCES rep(rep_id) Match SIMPLE
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
	, 	CONSTRAINT uc_employee_rep_employee_id_rep_id UNIQUE (employee_id, rep_id)
);


CREATE TABLE IF NOT EXISTS employee_email
(
	employee_email_id INT NOT NULL
	, employee_id INT NOT NULL
	, email_address VARCHAR(255) NOT NULL	
	, email_label VARCHAR(35) NOT NULL
	, is_used BOOLEAN NOT NULL
	, is_preferred BOOLEAN NOT NULL
	, is_active BOOLEAN NOT NULL
	, created_by VARCHAR(50) NOT NULL  
	, create_date TIMESTAMP  NOT NULL DEFAULT NOW()
	, updated_by VARCHAR(50) NULL	  
    , update_date TIMESTAMP NULL
	, CONSTRAINT pk_employee_email PRIMARY KEY (employee_email_id)
	,    CONSTRAINT fk_employee_email_employee FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- HAVE TO FIGURE OUT OUT HOW TO ADD FILTERED INDEX
-- CREATE UNIQUE INDEX uix_employee_email_is_preferred ON public.employee_email (employee_id, is_preferred) WHERE is_preferred = true;


CREATE TABLE IF NOT EXISTS employee_org
(
	employee_org_id int 
	, employee_id int NOT NULL
	, org_id int NOT NULL
	, is_preferred BOOLEAN NOT NULL
	, is_active BOOLEAN NOT NULL
	, created_by VARCHAR(50) NOT NULL
	, create_date TIMESTAMP DEFAULT NOW()
	, updated_by VARCHAR(50) NULL
	, update_date TIMESTAMP NULL
, CONSTRAINT pk_employee_org PRIMARY KEY (employee_org_id)
, CONSTRAINT fk_employee_org_employee
	FOREIGN KEY(employee_id)
	REFERENCES employee(employee_id) Match SIMPLE
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
, CONSTRAINT fk_employee_org_org
	FOREIGN KEY(org_id)
	REFERENCES org(org_id) Match SIMPLE
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
, CONSTRAINT uc_employee_org_employee_id_org_id UNIQUE (employee_id, org_id) 
);

-- HAVE TO FIGURE OUT OUT HOW TO ADD FILTERED INDEX
-- CREATE UNIQUE INDEX uix_employee_org_is_preferred ON public.employee_org (employee_id, is_preferred) WHERE is_preferred = true;

-- VIEWS 


CREATE  VIEW preferred_employee_data
 AS
 SELECT e.employee_id,
    e.first_name,
    e.middle_name,
    e.last_name,
    e.suffix,
    e.preferred_name,
	e.photo_name,
    preferred_email.email_address AS preferred_email_address,
    preferred_phone.phone_number AS preferred_phone_number,
    preferred_phone.phone_extension AS preferred_phone_extension,
    preferred_org.org_code AS preferred_org_code,
    preferred_org.org_name AS preferred_org_name,
    preferred_org.address_1 AS preferred_address_1,
    preferred_org.address_2 AS preferred_address_2,
    preferred_org.city AS preferred_city,
    preferred_org.state_name AS preferred_state_name,
    preferred_org.zip_code AS preferred_zip_code
   FROM employee e
     LEFT JOIN ( SELECT e_1.employee_id,
            e_1.email_address
           FROM employee_email e_1
          WHERE e_1.is_preferred = true) preferred_email ON e.employee_id = preferred_email.employee_id
     LEFT JOIN ( SELECT ep.employee_id,
            p.phone_number,
            p.phone_extension
           FROM employee_phone ep
             JOIN phone p ON ep.phone_id = p.phone_id
          WHERE ep.is_preferred = true) preferred_phone ON e.employee_id = preferred_phone.employee_id
     LEFT JOIN ( SELECT eo.employee_id,
            o.org_code,
            o.org_name,
            a.address_1,
            a.address_2,
            a.city,
            sc.state_name,
            a.zip_code
           FROM employee_org eo
             JOIN org o ON eo.org_id = o.org_id
             JOIN postal_address a ON o.postal_address_id = a.postal_address_id
             JOIN state_code_type sc ON a.state_code = sc.state_code
          WHERE eo.is_preferred = true) preferred_org ON e.employee_id = preferred_org.employee_id
  WHERE e.is_active = true;
  
  
-- FUNCTIONS AND STORED PROCEDURES

DELIMITER //
CREATE FUNCTION concat_emp_rep_codes (employee_id int)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	SELECT group_concat(DISTINCT r.rep_code separator ', ') into @p1
	FROM employee_rep AS er
		INNER JOIN rep AS r
			ON er.rep_id = r.rep_id	
	WHERE er.employee_id = employee_id;
		
	RETURN @p1;
END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION concat_emp_titles (employee_id int)
RETURNS VARCHAR(1000)
DETERMINISTIC
/*
select   concat_emp_titles(5);
*/
BEGIN
	SELECT group_concat(DISTINCT tt.title_type_name ORDER BY tt.title_type_name separator ', ') INTO @p1
	FROM employee_title AS et
		INNER JOIN title_type AS tt
			ON et.title_id = tt.title_id 
	WHERE et.employee_id = employee_id
		and tt.is_active = 1;
	
	RETURN @p1;
END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION concat_emp_websites (employee_id int)
RETURNS VARCHAR(1000)
DETERMINISTIC
/*
SELECT concat_emp_websites(5);
*/
BEGIN
	SELECT group_concat(DISTINCT ew.website ORDER BY ew.website separator ', ') INTO @p1
	FROM employee_website AS ew
		INNER JOIN website_type AS wt 
			ON ew.website_type_id = wt.website_type_id 
		WHERE ew.employee_id = employee_id
			AND wt.attribute_name = 'Employee'
            AND wt.is_active = 1;
            
	RETURN @p1;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION concat_emp_designations (employee_id int)
/*
call concat_emp_designations(5);
*/
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	SELECT group_concat(DISTINCT dt.designation_id separator ', ') INTO @p1
	FROM employee_designation AS ed
		INNER JOIN designation_type AS dt 
			ON ed.designation_id = dt.designation_id
         WHERE  ed.employee_id = employee_id   
            AND dt.is_active = 1;
            
	RETURN @p1;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE designation_get() 
BEGIN
	SELECT designation_id
		, designation_code
		, designation_desc
		, designation_symbol_name
		, is_active
	FROM designation_type
	WHERE is_active = 1;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE phone_type_get() 
BEGIN
	SELECT phone_type_id
		, phone_name
		, attribute_name
		, sort_order
		, is_active
        , create_date 
        , update_date
	FROM phone_type
	WHERE is_active = 1;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE title_type_get ()
BEGIN
	SELECT title_id 
 	, title_type_name 
	, is_active 
 	, create_date 
 	, update_date 
	FROM title_type
	WHERE is_active = true;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE state_province_get ()
BEGIN
	SELECT state_code
 	, state_name 
	FROM state_code_type;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE website_type_get ()
BEGIN
SELECT website_type_id
		, website_type_name
		, attribute_name
		, sort_order
		, is_active
        , create_date 
        , update_date
	FROM website_type
	WHERE is_active = 1;
END//
DELIMITER ;





DELIMITER //
CREATE PROCEDURE employee_get_by_rep_code (repcodes VARCHAR(1000))
/*
call employee_get_by_rep_code ('SX92,SXAB');
*/

BEGIN

	drop table if exists t;
	create table t( txt text );
	insert into t values ('SX92,SXAB');


	drop temporary table if exists rep_codes;
	create temporary table rep_codes( rep_code varchar(4) );
	set @sql = concat("insert into rep_codes (rep_code) values ('", replace(( select group_concat(distinct txt) as data from t), ",", "'),('"),"');");
	prepare stmt1 from @sql;
	execute stmt1;


	SELECT pd.employee_id  
		, pd.first_name
		, pd.middle_name
		, pd.last_name
		, pd.suffix
		, pd.preferred_name
		, pd.preferred_email_address
		, pd.preferred_phone_number
		, pd.preferred_phone_extension
		, pd.preferred_org_code
		, pd.preferred_org_name
		, pd.preferred_address_1
		, pd.preferred_address_2
		, pd.preferred_city
		, pd.preferred_state_name
		, pd.preferred_zip_code
		, concat_emp_rep_codes(pd.employee_id)
		, concat_emp_titles(pd.employee_id)
		, concat_emp_designations (pd.employee_id)
		, pd.photo_name
		, concat_emp_websites(pd.employee_id)
	FROM preferred_employee_data AS pd
		INNER JOIN employee_rep AS er
			ON pd.employee_id = er.employee_id
		INNER JOIN rep AS r 
			ON r.rep_id = er.rep_id
		INNER JOIN rep_codes rep_list
			ON r.rep_code = rep_list.rep_code;
END//
DELIMITER ;
