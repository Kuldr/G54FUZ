#install.packages("FuzzyR")
#install.packages("shiny")
library(shiny)
library(FuzzyR)

# Creates a fis object.
fis <- newfis('cw', defuzzMethod = 'centroid')

# Add linguistic variables
# Temperature | What Range
fis <- addvar(fis, 'input',  'Temperature', c(28, 40))
# Headache | What Range
fis <- addvar(fis, 'input',  'Headache',    c(0, 10))
# Urgency | 0-100 (CW also says 0-10)
fis <- addvar(fis, 'output', 'Urgency',     c(0, 100))

# Add the Membership functions for each linguistic label
# Temperature 
# Hypothermia https://en.wikipedia.org/wiki/Hypothermia Mild 32-35, Moderate 28-32
# Normal https://en.wikipedia.org/wiki/Hyperthermia Normal 36.5-37.5
# Stronger Evidence for normal temperature https://onlinelibrary.wiley.com/doi/full/10.1046/j.1471-6712.2002.00069.x
#   Suggests 33.2–38.2 for normal oral temperature 35, 37.25 (LQ, UQ)
# Fever/Hyperthermia >37.5/38.3
# Severe Hypothermia (<28) too low / Severe Hyperthermia (>40) too high
#   Both have lack of body functions and are life threatening so shouldn't require a system to diagonose
#fis <- addmf(fis, 'input', 1, 'Low Danger', 'trapmf', c(28, 28, 31.5, 32));
#fis <- addmf(fis, 'input', 1, 'Low',        'trapmf', c(31.5, 32, 33.5, 34));
#fis <- addmf(fis, 'input', 1, 'Normal',     'trapmf', c(33.5, 34, 37.5, 38));
#fis <- addmf(fis, 'input', 1, 'Mild Fever', 'trapmf', c(37.5, 38, 38.5, 39));
#fis <- addmf(fis, 'input', 1, 'High Fever', 'trapmf', c(38.5, 39, 40, 40));
fis <- addmf(fis, 'input', 1, 'Low Danger', 'gaussmf', c(((32-28)/3), 28));
fis <- addmf(fis, 'input', 1, 'Low',        'gaussmf', c(((34-31.5)/3), (31.5+(34-31.5)/2)));
fis <- addmf(fis, 'input', 1, 'Normal',     'gaussmf', c(((38-33.5)/3), (34+(37.5-34)/2))); # This is a problem as the limits aren't semetric
fis <- addmf(fis, 'input', 1, 'Mild Fever', 'gaussmf', c(((39-37.5)/3), (37.5+(39-37.5)/2)));
fis <- addmf(fis, 'input', 1, 'High Fever', 'gaussmf', c(((40-38.5)/3), 40));
# Headache
# Minor, Moderate, Severe
# Based of this scale https://i.pinimg.com/originals/73/f7/04/73f70404a947aed73480508e6a9f75d3.png
fis <- addmf(fis, 'input', 2, 'Minor',    'trapmf', c(0, 0, 3, 4));
fis <- addmf(fis, 'input', 2, 'Moderate', 'trapmf', c(3, 4, 6, 7));
fis <- addmf(fis, 'input', 2, 'Severe',   'trapmf', c(6, 7, 10, 10));
#fis <- addmf(fis, 'input', 2, 'Minor',    'gaussmf', c((5/3), 0));
#fis <- addmf(fis, 'input', 2, 'Moderate', 'gaussmf', c((5/3), 5));
#fis <- addmf(fis, 'input', 2, 'Severe',   'gaussmf', c((5/3), 10));
# Urgency
# Unneeded, Low, Medium, High, Critical
#fis <- addmf(fis, 'output', 1, 'Unneeded', 'trimf', c(0, 0, 25));
#fis <- addmf(fis, 'output', 1, 'Low',      'trimf', c(0, 25, 50));
#fis <- addmf(fis, 'output', 1, 'Medium',   'trimf', c(25, 50, 75));
#fis <- addmf(fis, 'output', 1, 'High',     'trimf', c(50, 75, 100));
#fis <- addmf(fis, 'output', 1, 'Critical', 'trimf', c(75, 100, 100));
fis <- addmf(fis, 'output', 1, 'Unneeded', 'gaussmf', c((25/3), 0));
fis <- addmf(fis, 'output', 1, 'Low',      'gaussmf', c((25/3), 25));
fis <- addmf(fis, 'output', 1, 'Medium',   'gaussmf', c((25/3), 50));
fis <- addmf(fis, 'output', 1, 'High',     'gaussmf', c((25/3), 75));
fis <- addmf(fis, 'output', 1, 'Critical', 'gaussmf', c((25/3), 100));

# Add the rules
rt1 = c(1,0,4,1,  1)
rt2 = c(2,0,3,1,  1)
rt3 = c(3,0,1,1,  1)
rt4 = c(4,0,3,1,  1)
rt5 = c(5,0,5,1,  1)
rh1 = c(0,1,2,.1,  1)
rh2 = c(0,2,3,.1,  1)
rh3 = c(0,3,4,.1,  1)
rulelist = rbind(rt1, rt2, rt3, rt4, rt5, rh1, rh2, rh3)
fis <- addrule(fis, rulelist)
showrule(fis)

# VISULISATIONS -----------------------------------------------------------------------------------

# This plots the membership functions
par(mfrow=c(3,1))
plotmf(fis,'input',1)
plotmf(fis,'input',2)
plotmf(fis,'output',1)

par(mfrow=c(1,1))
gensurf(fis)

stepSize <- 0.005
# Test that urgency increase as headache increases for "all" temperatures
# print("Testing that urgency increase as headache increases for all temperatures")
# headacheAllAnswers <- c()
# headacheFracAnswers <- c()
# for (temp in seq(28, 40, stepSize)){
#   a = seq(0, 10, stepSize)
#   b = cbind(rep(temp, length(a)), a)
#   x = evalfis(b, fis)
#   z = x == cummax(x)
#   
#   headacheAllAnswers <- rbind(headacheAllAnswers, c(temp, all(z)))
#   headacheFracAnswers <- rbind(headacheFracAnswers, c(temp, (sum(z)/length(z))))
# }
# Test that urgency decreases as low Temp decreases for "all" headaches
# print("Testing that urgency decreases as low Temp decreases for all headaches")
# lowTempAllAnswers <- c()
# lowTempFracAnswers <- c()
# for (headache in seq(0, 10, stepSize)){
#   a = seq(28, 35.75, stepSize)
#   b = cbind(a, rep(headache, length(a)))
#   x = evalfis(b, fis)
#   z = x == cummin(x)
#   
#   lowTempAllAnswers <- rbind(lowTempAllAnswers, c(headache, all(z)))
#   lowTempFracAnswers <- rbind(lowTempFracAnswers, c(headache, (sum(z)/length(z))))
# }
# Test that urgency increases as high Temp increases for "all" headaches
print("Testing that urgency increases as high Temp increases for all headaches")
highTempAllAnswers <- c()
highTempFracAnswers <- c()
for (headache in seq(0, 10, stepSize)){
  a = seq(35.75, 40, stepSize)
  b = cbind(a, rep(headache, length(a)))
  x = evalfis(b, fis)
  z = x == cummax(x)
  
  highTempAllAnswers <- rbind(highTempAllAnswers, c(headache, all(z)))
  highTempFracAnswers <- rbind(highTempFracAnswers, c(headache, (sum(z)/length(z))))
}

#Plot the Answers
# par(mfrow=c(3,2))
# plot(headacheAllAnswers)
# plot(headacheFracAnswers)
# plot(lowTempAllAnswers)
# plot(lowTempFracAnswers)
plot(highTempAllAnswers)
plot(highTempFracAnswers)

#showGUI(fis) can only be called with the console?