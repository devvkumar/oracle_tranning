options (skip=1)
load data
infile TEST_AR.csv
append
into table TEST_AR
fields terminated by ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(ID,
NAME,
SALARY,
HIRE_DATE  "TO_DATE(:HIRE_DATE,'DD/MM/YYYY')",
DESCRIPTION )
