# Create a new fis called loan
fis <- newfis('Loan');

# Add linguistic variables
# Salaries £0 - 100,000
fis <- addvar(fis,'input', 'salary',c(0, 100000));
# Period of employment 0 - 40 years
fis <- addvar(fis,'input', 'employment', c(0, 40));
# Decision Scale 0 - 100
fis <- addvar(fis,'output', 'decision', c(0, 100));

# Add the Membership functions for each linguistic label
# Salaries
# Low, Medium, High
fis <- addmf(fis, 'input', 1, 'Low',    'trapmf', c(0, 0, 1e4, 3e4));
fis <- addmf(fis, 'input', 1, 'Medium', 'trapmf', c(2.5e4, 3.5e4, 4e4, 5.5e4));
fis <- addmf(fis, 'input', 1, 'High',   'trapmf', c(5e4, 8e4, 1e5, 1e5));
# Employment
# VShort, Short, Medium, Long, VLong
fis <- addmf(fis, 'input', 2, 'VShort', 'trimf', c(0, 0, 1.5));
fis <- addmf(fis, 'input', 2, 'Short',  'trimf', c(0.75, 2, 3.25));
fis <- addmf(fis, 'input', 2, 'Medium', 'trimf', c(15, 20, 25));
fis <- addmf(fis, 'input', 2, 'Long',   'trimf', c(15, 25, 30));
fis <- addmf(fis, 'input', 2, 'VLong',  'trimf', c(20, 40, 40));
# Descision
# Yes, Maybe, No
fis <- addmf(fis, 'output', 1, 'No', 'trimf', c(0, 0, 40));
fis <- addmf(fis, 'output', 1, 'Maybe', 'trapmf', c(15, 40, 60, 85));
fis <- addmf(fis, 'output', 1, 'Yes', 'trimf', c(60, 100, 100));

# Add the rules
# VAGUE RULE DESCRIPTIONS
# GENERATED RULE DESCRIPTIONS
#1. If (salary is High) and (employment is VLong, Long, Medium) then (decision is Yes) (1)
r1 = c(1,1,1,1,1)
rulelist = rbind(r1)
fis <- addrule(fis, rulelist)
showrule(fis)

# This plots the membership functions
par(mfrow=c(3,1))
plotmf(fis,'input',1)
plotmf(fis,'input',2)
plotmf(fis,'output',1)

par(mfrow=c(1,1))
gensurf(fis)