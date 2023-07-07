--  designation type
insert into designation_type (designation_id, designation_code, designation_desc, designation_symbol_name, is_active)
values
(1,'AAMS','Accredited Asset Management Specialist','Trademark', 1)
,(2,'ACAS','Associate of the Casualty Actuarial Society', null, 1)
,(6,'AIF','Accredited Investment Fiduciary','Registered Trademark', 1)
,(35, 'CRPC', 'Chartered Retirement Planning Counselor', 'Trademark', 1);


--  state code
insert into state_code_type (state_code, state_name) 
values ('AL','Alabama'), ('MO','Missouri') ;

--  phone type
insert into phone_type (phone_type_id, phone_name, attribute_name, sort_order, is_active, create_date) 
values (1,'main', 'Employee', 1,1,'2019-01-17 19:34:34.587')
,(2,'direct', 'Employee', 2,1,'2019-01-17 19:34:34.587');

--  website type
insert into website_type (website_type_id, website_type_name, attribute_name, sort_order, is_active, create_date)
values
  (1, 'Website',	'Employee',	1,	1,	'2019-01-17 19:35:40.467')
, (2, 'LinkedIn',	'Employee',	2,	1,	'2019-01-17 19:35:40.467')
, (3, 'Facebook',	'Employee',	3,	1,	'2019-01-17 19:35:40.467');

--  title type
insert into title_type (title_id, title_type_name, is_active, create_date)
values 
(3,	'Financial Advisor',	1,	'2018-09-06 00:00:00.000')
,  (10,'Managing Director/Investments',	1	,'2018-09-06 00:00:00.000')
, (19,'Senior Vice President/Investments',	1	,'2018-09-06 00:00:00.000')
,(36,	'Portfolio Analyst',	1,	'2018-09-06 00:00:00.000');


-- 099 employee
insert into financialadvisor.employee (employee_id, first_name, middle_name,  last_name, preferred_name, is_active, created_by) 
values (5, 'Lashawn', 'H', 'Warden', 'Lashawn H. Warden', 1, '2019-02-07 19:37:17')
     , (7, 'Clarine', 'X', 'Graves', 'Clarine X. Graves', 1, '2019-02-07 19:37:17');

-- phone
insert into phone (phone_id, phone_number)
values
(10649, '2568986785'), (57,	'2052716205'), (63,	'2054143332'), (77,	'2054404565');


-- employee phone
insert into employee_phone (employee_phone_id, employee_id, phone_id, phone_type_id, is_used, is_preferred, created_by, create_date)
values
(531,	5,	10649,	1,	1,	0,	'Admin', '2019-02-07 19:37:17.600')
,(9916,	5,	57,	2,	1,	1,	'Admin',	'2019-02-07 19:37:17.600')
,(177,	7,	63,	1,	0,	0,	'Admin',	'2019-02-07 19:37:17.600')
,(179,	7,	77,	2,	1,	1,	'Admin',	'2019-02-07 19:37:17.600');


-- employee email
insert into employee_email (employee_email_id, employee_id, email_address, email_label, is_used, is_preferred, is_active, created_by,  create_date)
values
  (5,	5,	'WardenL@MyDomain123.com',	'Work',	1,	1,	1,	'Admin',	'2019-02-07 19:37:18.317')
, (6,	7,	'GravesC@MyDomain123.com',	'Work',	1,	1,	1,	'Admin',	'2019-02-07 19:37:18.317');


-- employee desisgnation
insert into employee_designation (employee_designation_id, employee_id, designation_id, created_by, create_date)
values (1,	5,	6,		'Admin',	'2019-02-07 19:37:16.147')
,(1070,	7,	35,		'Jimmy Conners',	'2020-06-26 15:43:26.630');

-- 104 rep
insert into financialadvisor.rep (rep_id, rep_code) 
values 
(1803, 'SX06'), (7998, 'D601'), (1822,'SX92');

-- 105 employee rep
insert into employee_rep (employee_rep_id, employee_id, rep_id, created_by, create_date)
values (5,5,1803, 'Admin','2019-02-07 19:37:15.723')
, (7766, 5,7998, 'Melanie Rawr', '2020-10-01 13:45:13.680' )
, (7,7,1822,'Admin', '2019-02-07 19:37:15.723');


-- employee title
insert into employee_title (employee_title_id, employee_id, title_id, created_by, create_date)
values
(1,	5,	19,	'Admin', '2019-02-07 19:37:15.350')
, (5,	5,	36,	'Admin', '2019-02-07 19:37:15.350')
, (7,	7,	3,	'Admin',	'2019-02-07 19:37:15.350');


-- postal address
insert into postal_address  (postal_address_id, address_1, address_2, city, state_code, zip_code) 
values (237,	'248 Johnston Street SE',	NULL,	'Decatur',	'AL',	'35601')
, (326,	'800 Shades Creek Parkway',	'Suite 750',	'Birmingham',	'AL',	'35209');

-- org
insert into org (org_id, org_code, org_name, postal_address_id, is_active, note)
values	
(354,	'6BC',	'Decatur, AL PCG',	237	,1,	'Satelite of Birmingham, AL (#6AC)')
,(329,'6AC','Birmingham, AL (PCG)',	326,	1,	'(877) 478-3763 Toll-Free');


-- employee org
insert into employee_org (employee_org_id,employee_id,org_id,is_preferred,is_active,created_by,create_date)
values
(6385, 5,	354,	1,	1,	'Betsy Russ',	'2020-10-01 13:45:27.007')
,(7,	7,	329,	1,	1,	'Admin',	'2019-02-07 19:37:17.100');
