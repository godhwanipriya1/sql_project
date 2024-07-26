select -* from employee

---1. Employees with Specific Job Role and Department
---Question 1: Find all employees who have the same job role as 'Sales Representative' and are from 
---the 'Sales' department. Show their empid, name, department, and job role.

select empid,name,department,jobrole from employee 
where jobrole = 'Sales Representative' and department = 'Sales'

---2. Average Salary by Department
---Question 2: Calculate the average salary of employees grouped by their department. Display the department and the average salary.

select avg(salary), department from employee
group by department

---3. Employees Earning Above Average Salary
---Question 3: List the names and salaries of employees who earn more than the average salary of all employees. 
--Use a subquery to find the average salary.

select name,salary from employee 
where salary >(select avg(salary) from employee)

---4. Highest Salary in Each Department
---Question 4: For each department, find the employee with the highest salary. 
---Use window functions to achieve this and display empid, name, department, and salary.
	
WITH RankedSalaries AS (
    SELECT empid, name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
    FROM employee)
SELECT empid, name, department, salary
FROM RankedSalaries
WHERE rank = 1;

---5. Automatic Age Group Update Trigger
---Question 5: Create a trigger that automatically updates the 'agegroup' of an employee 
---based on their 'age' whenever an employee's age is updated.

create or replace function update_age()
RETURNS TRIGGER as $$
BEGIN
	IF NEW.age BETWEEN 18 AND 25 THEN
        NEW.agegroup := '18-25';
    ELSIF NEW.age BETWEEN 26 AND 35 THEN
        NEW.agegroup := '26-35';
    ELSIF NEW.age BETWEEN 36 AND 45 THEN
        NEW.agegroup := '36-45';
    ELSIF NEW.age BETWEEN 46 AND 55 THEN
        NEW.agegroup := '46-55';
    ELSE
        NEW.agegroup := '56+';
    END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

create trigger trigger_update_age
before update on employee
for each row
execute function update_age()

update employee set age = 38 where name = 'Charlie'

---6. Calculate Annual Salary
---Question 6: Write a function to calculate the annual salary of an employee based on their monthly salary. 
---Then, use this function to list empid, name, and their annual salary.

create or replace function calculate_annual_salary(salary int)
RETURNS int as $$
begin
	return salary * 12;
end;
$$ language plpgsql;
	
select empid,name,calculate_annual_salary(salary) as annual_salary from employee

---7. Employees with Names Starting with 'C'
---Question 7: Use a regular expression to find all employees whose names start with 'C'. Display their empid and name.

select empid,name from employee where name like 'C%'

---8. Departments with Average Salary Above 50,000
Question 8: Find departments where the average salary is greater than 50,000. Use the HAVING clause to filter the grouped results.

select avg(salary), department from employee
group by department
having avg(salary) > 50000

---9. Salary Rank Within Each Department
---Question 10: Rank employees based on their salary within each department. 
--Display empid, name, department, salary, and rank.

select empid,name,department,salary,row_number() 
over (partition by department order by salary) as rank from employee

---10. Find Employees with a Salary Above a Certain Amount
---Question 10: Find all employees whose salary is greater than 30,000. Show their empid, name, and salary.

select empid,name,salary from employee where salary > 30000