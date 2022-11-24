'''Begin'''
'''Test Query'''
SELECT *
FROM title

'''Drop Query'''
DROP TABLE retirement_titles

''' Create a dummy table that contains Employees first name, last name, birth date, title, and title dates'''
SELECT Employees.emp_no,
	Employees.first_name,
	Employees.last_name,
	Employees.birth_date,
	Titles.title,
	Titles.from_date,
	Titles.to_date
INTO retirement_test
FROM Employees
INNER JOIN Titles
ON Employees.emp_no = Titles.emp_no;

''' Create table without birth date column.  Also orders by birth date between 1952 and 1955'''
SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	to_date
INTO retirement_titles
FROM retirement_test
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no;

'''Checks the table contents'''
SELECT *
FROM retirement_titles

'''Drops dummy table'''
DROP TABLE retirement_test

'''Retrieve the employee number, first and last name, and title columns from the Retirement Titles table.
These columns will be in the new table that will hold the most recent title of each employee.
Use the DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
Exclude those employees that have already left the company by filtering on to_date to keep only those dates that are equal to '9999-01-01'.
Create a Unique Titles table using the INTO clause.
Sort the Unique Titles table in ascending order by the employee number and descending order by the last date (i.e., to_date) of the most recent title.'''

CREATE TABLE unique_titles
AS
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC

''' Check unique_titles Table'''
SELECT *
FROM unique_titles

''' Write another query in the Employee_Database_challenge.sql file to retrieve the number of employees by their most recent job title who are about to retire.
First, retrieve the number of titles from the Unique Titles table.
Then, create a Retiring Titles table to hold the required information.
Group the table by title, then sort the count column in descending order.'''
CREATE TABLE retiring_titles
AS
SELECT Count (title), title
FROM unique_titles
GROUP BY unique_titles.title
ORDER BY unique_titles.count DESC;

''' Check retiring_titles'''
SELECT *
FROM retiring_titles

''' End Deliverable 1'''

'''Begin Deliverable 2'''
'Creates table that joins employees, dept_emp, and titles.  Filters current employees who are a certain age to determine mentorship eligibilty '
CREATE TABLE mentorship_eligibilty
AS
SELECT DISTINCT ON (employees.emp_no) employees.emp_no,
	employees.first_name,
	employees.last_name,
	employees.birth_date,
	dept_emp.from_date,
	dept_emp.to_date,
	titles.title
FROM employees
	INNER JOIN  dept_emp
	ON employees.emp_no = dept_emp.emp_no
	INNER JOIN  titles
	ON employees.emp_no = titles.emp_no
WHERE (dept_emp.to_date = '9999-01-01') AND (employees.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY employees.emp_no;

'Check mentorship_eligibilty table'
SELECT *
FROM mentorship_eligibilty

'Total Active Employees Query'
SELECT *
FROM titles
WHERE to_date = '9999-01-01'

'Mentorship eligible title count'
SELECT Count (title), title
FROM mentorship_eligibilty
GROUP BY title
ORDER BY count DESC;
