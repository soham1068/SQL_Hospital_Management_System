CALL AddTreatment(1, 1, '2024-04-12', '09:00:00', 1, 3);
use hms;
SELECT * FROM Treats;
SELECT * FROM Medicine;
Create table Treats(
 Dr_no INT NOT NULL,
 P_no INT NOT NULL, 
 dte Date,  
 Primary Key(Dr_no, P_no), 
 Foreign Key(Dr_no) references Doctor(doctor_id), 
 foreign key(P_no) references Patient(p_id) );
 
 
Create table medical_report( 
report_id INT Primary Key auto_increment, 
patient_id INT, 
doctor_id INT, 
r_date date, 
total_cost INT,
Foreign Key(patient_id) references Patient(p_id), 
Foreign Key(doctor_id) references Doctor(doctor_id) );
 
 delimiter //  --(trigger 2)

create trigger new_treatment_report
after insert on treats
for each row
begin
insert into medical_report(patient_id, doctor_id, r_date) values (new.p_no, new.dr_no, new.dte);
end;
//
delimiter ;
insert into treats(dr_no, p_no, dte) values (10, 3, '2024-04-25');
select* from treats;
select* from medical_report;


Create table medicine( 
medicine_id INT Primary Key NOT NULL auto_increment, 
m_name VarChar(20), 
price INT, quantity_prescribed INT, 
report_id int, 
Foreign Key(report_id) references medical_report(report_id) );


delimiter // --(procedure 1)

create procedure add_medicine(
	mname varchar(10),
	quantity int,
	mprice int,
	rid int
)
begin
insert into medicine(m_name, quantity_prescribed, price, report_id) values (mname, quantity, mprice, rid);
end;
//

delimiter ;
drop trigger update_total_cost_report
delimiter //

create trigger update_total_cost_report
after insert on medicine
for each row
begin
    update medical_report
    set total =  IFNULL(total, 0) + (new.price * new.quantity_prescribed)
    where report_id = new.report_id;
end;
//

delimiter ;
call add_medicine('dollo', 5, 50, 11);
select*from medicine;
select* from medical_report;
call add_medicine('para', 1, 20, 11);

delete from medicine;
update medical_report set total = NULL where report_id = 10;

CREATE TABLE Doctor (     doctor_id INT PRIMARY KEY AUTO_INCREMENT,     
name VARCHAR(100) NOT NULL,    
 gender ENUM('Male', 'Female', 'Other'),     
specialisation VARCHAR(100) NOT NULL,      
email VARCHAR(100),     -- Composite attribute: contact_info 
phone VARCHAR(15),         
languages VARCHAR(1000), -- Multivalued attribute: languages_spoken
CONSTRAINT chk_gender CHECK (gender IN ('Male', 'Female', 'Other')) );

CREATE TABLE Department (D_number INT PRIMARY KEY, Dname VARCHAR(100) );

ALTER TABLE Doctor ADD COLUMN Dno INT;
ALTER TABLE Doctor ADD CONSTRAINT fk_dno FOREIGN KEY (Dno) REFERENCES Department(D_number);

Alter table Department Add column Sr_ssn INT;
Alter table Department Add constraint fk_Sr_ssn foreign key (Sr_ssn) references Doctor(Doctor_id);

delimiter // --(trigger 1)
CREATE TRIGGER before_insert_doctor
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.Dno IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Cannot insert doctor without assigning to a department';
    END IF;
END;
//
delimiter ;
select* from doctor;
select *from department;
INSERT INTO Doctor (doctor_id, Name, Gender, Specialisation, email, phone, languages, Dno)
VALUES
(1, 'Dr. Smith', 'Male', 'Cardiology', 'smith@gmail.com','123456789', 'English, Spanish', NULL);

delimiter // --(procedure 2)
create procedure add_supervisor(dname varchar(100), dgender varchar(10), dspecial varchar(100),
 demail varchar(100), dphone varchar(15), dlang varchar(50), ddno int)
begin
insert into doctor(name, gender, specialisation, email, phone, languages, dno)
values (dname, dgender, dspecial, demail, dphone, dlang, ddno);

update department
set sr_ssn = last_insert_id()
where d_number = ddno;
end;
//

Create table Patient( p_id INT PRIMARY KEY AUTO_INCREMENT,
 p_name varchar(50) NOT NULL, 
 age INT, 
 gender ENUM('Male', 'Female', 'Other'), 
 p_email VARCHAR(100), 
 p_phone VARCHAR(50) );
 
insert into department values(203, 'dental', NULL);
call add_supervisor('Sara', 'Female', 'dental', 'sara@gmail.com', '987654321', ' english, hindi', 203);
select * from doctor;
select * from department;

update department set sr_ssn = NULL where d_number = 202;
delete from doctor where doctor_id = 9;
delete from department where D_number = 201;
update department set dname = 'cardiology' where d_number = 202;
