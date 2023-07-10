/***************************************************/
/* SQL Case Study - HR Challenge (Data supplied by Data in Motion) */
/***************************************************/

* Please check other file for how to create the DB in your IDE*


/* 1. Find the longest ongoing project for each department. */

SELECT d.name AS dept,
       p.name AS project_name,
       CONCAT(DATEDIFF(end_date, start_date), ' days') AS project_duration
FROM projects p
JOIN departments d USING (id);


/* 2. Find all employees who are not managers.alter.

there are 2 ways to solve this: (a) the people who are managers have manager in their job title (employees table), so we can use regexp
second option (b) is to combine departments and employees tables*/

select name as employee_name,
       job_title
       from employees
where job_title not regexp 'Manager';

select e.name as employee_name,
       job_title
       from employees e
       left join departments d
       on e.id = d.manager_id
       where d.manager_id is NULL;


/* 3. Find all employees who have been hired after the start of a project in their department. */

      select e.name as employee_name,
	         d.name as dept_name, e.hire_date, p.start_date as project_start_date
	  from employees e
	  join projects p using (department_id)
	  join departments d
	  on d.id = p.department_id
      where  e.hire_date > p.start_date;
      
/*4. Rank employees within each department based on their hire date (earliest hire gets the highest rank) */

     select e.name as employee_name,
	         d.name as dept_name, e.hire_date,
             rank() over (partition by d.name order by e.hire_date) hire_date_rank
	  from employees e
	  join departments d
	  on d.id = e.department_id;
      
      
/* 5. Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department. */

      select e.name as employee_name,
	         d.name as dept_name, e.hire_date,
             datediff(lead(e.hire_date) over (partition by d.name order by e.hire_date), e.hire_date) as duration
	  from employees e
	  join departments d
	  on d.id = e.department_id;


