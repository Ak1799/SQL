#Q1
create database employee;

#Q2
select * from emp_record_table;
select * from proj_table;
select * from data_science_team;

#Q3
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, dept from emp_record_table;

#Q4 - Using case statement
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, dept, emp_rating,
		CASE
        when emp_rating <2 then 'less than 2'
        when emp_rating between 2 and 4 then 'between 2 and 4'
		else 'greater than 4'
        END as Emp_Rating_Status
from emp_record_table;
        
#Q5
select EMP_ID, concat(FIRST_NAME," ",LAST_NAME) as Name, dept from emp_record_table where dept = 'finance';

#Q6
select EMP_ID, concat(FIRST_NAME," ",LAST_NAME) as Name, MANAGER_ID from emp_record_table;

select m.EMP_ID, concat(e.FIRST_NAME," ",e.LAST_NAME) as Emp_Name, concat(m.FIRST_NAME," ",m.LAST_NAME) as Manager_Name,
    count(*) over(partition by concat(m.FIRST_NAME," ",m.LAST_NAME)) as Number_Of_Emp
    from emp_record_table m join emp_record_table e
    on e.MANAGER_ID = m.EMP_ID;
    
#Q7
select * from emp_record_table where dept = 'healthcare'
union
select * from emp_record_table where dept = 'finance' ;

# Q7 another way
select * from emp_record_table where dept in ('healthcare','finance');

#Q8
select EMP_ID, FIRST_NAME, LAST_NAME, role , dept, emp_rating, max(emp_rating) over(partition by dept) as emp_rating_max from emp_record_table;

#Q9
select EMP_ID, min(salary) over(partition by role) as Min_Salary, salary, FIRST_NAME, LAST_NAME, dept,max(salary) over(partition by role) as Max_Salary from emp_record_table;

#Q10
select EMP_ID, FIRST_NAME, LAST_NAME, exp, rank() over(order by exp desc) as 'rank' from emp_record_table where salary > 6000;

#Q11
select EMP_ID, FIRST_NAME, LAST_NAME, Salary, country, continent from emp_record_table where salary > 6000 order by country, continent;

#Q12 - we have mentioned 'e' because every derived table must have its own alias
select EMP_ID, FIRST_NAME, LAST_NAME, exp from (select * from emp_record_table where exp>10) as e;

#Q13
/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `P_emp`()
BEGIN
select * from emp_record_table where exp > 3;
END
*/
call p_emp;

#Q14 - creating a user defined function

/*
CREATE DEFINER=`root`@`localhost` FUNCTION `emp_status`(eid varchar (5)) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
 declare Ex int; 
 declare str varchar(50);
 select exp into Ex from data_science_team where emp_id = eid; # whatever name in the first line will be given here
	 if ex <=2 then set str = 'JUNIOR DATA SCIENTIST';
	 elseif ex <=5 then set str ='ASSOCIATE DATA SCIENTIST';
	 elseif ex <=10 then set str ='SENIOR DATA SCIENTIST';
	 elseif ex <=12 then set str ='LEAD DATA SCIENTIST';
	 elseif ex <=16 then set str ='MANAGER';
	 end if;
RETURN str;
END
*/

select *, emp_status(emp_id) from data_science_team;

#Q15
create index idx_first_name on emp_record_table(First_Name);
select * from emp_record_table where first_name = 'eric';

#Q16
select * from emp_record_table;
select EMP_ID, FIRST_NAME, Role, Exp, 0.05*salary*emp_rating as Bonus from emp_record_table;

#Q17
select EMP_ID, FIRST_NAME, Role, Exp, Salary, Continent, Country, 
avg(Salary) over(partition by country) As Avg_Salary_Country, 
avg(Salary) over(partition by continent) As Avg_Salary_Continent 
from emp_record_table;
