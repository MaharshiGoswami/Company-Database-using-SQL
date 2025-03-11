SHOW DATABASES;
create database project;
USE bookdetails;
SHOW TABLES;

SELECT*FROM DEPARTMENT;

#Department
CREATE TABLE DEPARTMENT ( DNo INT PRIMARY KEY, DName VARCHAR(50), MgrSSN CHAR(9), MgrStartDate DATE);
alter table DEPARTMENT add constraint fk_MgSSN foreign key(MgrSSN) references EMPLOYEE(SSN);
DESC DEPARTMENT;

#Employee

CREATE TABLE EMPLOYEE (
    SSN CHAR(9) PRIMARY KEY,    
    Name VARCHAR(50),
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    SuperSSN CHAR(9),           
    DNo INT,                    
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)    
);

# DLocation

CREATE TABLE DLOCATION (
    DNo INT,                   
    DLoc VARCHAR(50),
    PRIMARY KEY (DNo, DLoc),   
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);  

SELECT*FROM DLOCATION;
#Project

CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY, 
    PName VARCHAR(50),
    PLocation VARCHAR(50),
    DNo INT,   
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);
select*from project;

#Work On

CREATE TABLE WORKS_ON (
    SSN CHAR(9),       
    PNo INT,           
    Hours DECIMAL(4, 2),        
    PRIMARY KEY (SSN, PNo),   
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),  
    FOREIGN KEY (PNo) REFERENCES PROJECT(PNo)     
);
select*from Works_on;


#DEPARTMENT Details
INSERT INTO DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate) VALUES
(1, 'Accounts', NULL, '2024-09-25'),
(2, 'HR', NULL, '2019-03-01'),
(3, 'Engineering', NULL, '2018-07-10'),
(5, 'IT', NULL, '2021-06-20');

UPDATE DEPARTMENT
SET MgrSSN = '111111111'
WHERE DNo = 1;

UPDATE DEPARTMENT
SET MgrSSN = '222222222'
WHERE DNo = 2;

UPDATE DEPARTMENT
SET MgrSSN = '333333333'
WHERE DNo = 3;

UPDATE DEPARTMENT
SET MgrSSN = '444444444'
WHERE DNo = 5;

select*from DEPARTMENT;

#EMPLOYEE Deails
INSERT INTO EMPLOYEE VALUES
('111111111', 'Mike Scott', 'US', 'M', 700000, NULL, 1),
('222222222', 'Jane Doe', 'BT', 'F', 650000, '111111111', 2),
('333333333', 'Robert Smith', 'AUS', 'M', 600000, '222222222', 3),
('444444444', 'Trixie Scott', 'CN', 'F', 500000, NULL, 1),
('555555555', 'Michael Jackson', 'NZ', 'M', 750000, '111111111', 2),
('666666666', 'Tim Lee', 'CN', 'F', 550000, '333333333', 5);

alter table EMPLOYEE change name Ename varchar(50);
UPDATE EMPLOYEE set Address='123 A' where SSN = '111111111';
SELECT*FROM EMPLOYEE;

#DLOCATION Details
INSERT INTO DLOCATION VALUES 
(1, 'New York'),
(2, 'ScotLand'),
(3, 'Tasmania'),
(5, 'HongKong');
select*from DLOCATION;

#PROJECT Details
INSERT INTO PROJECT VALUES 
(101, 'IoT', 'London', 5),
(102, 'Cloud Migration', 'San Francisco', 3),
(103, 'AI Development', 'Beijing', 1),
(104, 'Cybersecurity', 'Los Angeles', 5);
select*from PROJECT;

#WORKS_ON Details
INSERT INTO WORKS_ON (SSN, PNo, Hours) VALUES
('111111111', 101, 20),   
('222222222', 102, 15),    
('333333333', 103, 25),   
('444444444', 101, 10),   
('555555555', 104, 30),   
('666666666', 101, 15); 

select*from WORKS_ON; 


# 1.Make a list of all project numbers for projects that involve an employee whose last 
#name is ‘Scott’, either as a worker or as a manager of the department that controls 
#the project. 
SELECT DISTINCT P.PNo
FROM PROJECT P
JOIN DEPARTMENT D ON P.DNo = D.DNo
LEFT JOIN EMPLOYEE E ON E.DNo = P.DNo OR E.SSN = P.PNo
WHERE (E.Ename LIKE '%Scott%' OR D.MgrSSN = E.SSN);

# 2.Show the resulting salaries if every employee working on the ‘IoT’ project is 
# given a 10 percent raise.
SELECT E.Ename, E.Salary, E.Salary * 1.10 AS NewSalary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.SSN = W.SSN
JOIN PROJECT P ON W.PNo = P.PNo
WHERE P.PName = 'IoT';

# 3.Find the sum of the salaries of all employees of the ‘Accounts’ department, as well 
# as the maximum salary, the minimum salary, and the average salary in this 
# department
SELECT 
SUM(E.Salary) AS TotalSalaries,
MAX(E.Salary) AS MaxSalary,
MIN(E.Salary) AS MinSalary,
AVG(E.Salary) AS AvgSalary
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DNo = D.DNo
WHERE D.DName = 'Accounts';

# 4.Retrieve the name of each employee who works on all the projects controlled by 
# department number 4 (use NOT EXISTS operator). For each department that has 
# more than five employees, retrieve the department number and the number of its 
# employees who are making more than Rs. 6,00,000. 
SELECT E.Ename 
FROM EMPLOYEE E
WHERE NOT EXISTS (
SELECT P.PNo 
FROM PROJECT P
WHERE P.DNo = 4 
AND NOT EXISTS (
SELECT W.SSN 
FROM WORKS_ON W 
WHERE W.PNo = P.PNo 
AND W.SSN = E.SSN
)
);

select*from Works_on;

