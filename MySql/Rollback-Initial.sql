DROP PROCEDURE IF EXISTS financialadvisor.employee_get_by_rep_code;
DROP PROCEDURE IF EXISTS financialadvisor.designation_get;
DROP PROCEDURE IF EXISTS financialadvisor.phone_type_get;
DROP PROCEDURE IF EXISTS financialadvisor.state_province_get;
DROP PROCEDURE IF EXISTS financialadvisor.title_type_get;
DROP PROCEDURE IF EXISTS financialadvisor.website_type_get;
DROP FUNCTION IF EXISTS	financialadvisor.concat_emp_designations;
DROP FUNCTION IF EXISTS	financialadvisor.concat_emp_rep_codes;
DROP FUNCTION IF EXISTS	financialadvisor.concat_emp_titles;
DROP FUNCTION IF EXISTS	financialadvisor.concat_emp_websites;
DROP VIEW IF EXISTS financialadvisor.preferred_employee_data;
DROP TABLE IF EXISTS financialadvisor.employee_org;
DROP TABLE IF EXISTS financialadvisor.org;
DROP TABLE IF EXISTS financialadvisor.postal_address;
DROP TABLE IF EXISTS financialadvisor.employee_title;
DROP TABLE IF EXISTS financialadvisor.employee_rep;
DROP TABLE IF EXISTS financialadvisor.employee_website;
DROP TABLE IF EXISTS financialadvisor.rep;
DROP TABLE IF EXISTS financialadvisor.employee_designation;
DROP TABLE IF EXISTS financialadvisor.employee_email;
DROP TABLE IF EXISTS financialadvisor.employee_phone;
DROP TABLE IF EXISTS financialadvisor.phone;
DROP TABLE IF EXISTS financialadvisor.employee;
DROP TABLE IF EXISTS financialadvisor.title_type;
DROP TABLE IF EXISTS financialadvisor.website_type;
DROP TABLE IF EXISTS financialadvisor.phone_type;
DROP TABLE IF EXISTS financialadvisor.state_code_type;
DROP TABLE IF EXISTS financialadvisor.designation_type;
DROP SCHEMA IF EXISTS financialadvisor;