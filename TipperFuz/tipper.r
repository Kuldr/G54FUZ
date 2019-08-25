#install.packages("FuzzyR")
#install.packages("shiny")
library(shiny)
library(FuzzyR)

# Creates a fis object.
fis <- newfis('tipper')
# Adds an input or output variable to a fis object.
fis <- addvar(fis, 'input', 'service', c(0, 10))
fis <- addvar(fis, 'input', 'food', c(0, 10))
fis <- addvar(fis, 'output', 'tip', c(0, 30))
# Adds a membership function input 1 : service
fis <- addmf(fis, 'input', 1, 'poor', 'gaussmf', c(1.5, 0))
fis <- addmf(fis, 'input', 1, 'good', 'gaussmf', c(1.5, 5))
fis <- addmf(fis, 'input', 1, 'excellent', 'gaussmf', c(1.5, 10))
# Adds a membership function input 2 : food
fis <- addmf(fis, 'input', 2, 'rancid', 'trapmf', c(0, 0, 1, 3))
fis <- addmf(fis, 'input', 2, 'delicious', 'trapmf', c(7, 9, 10, 10))
# Adds a membership function output 1 : tip
fis <- addmf(fis, 'output', 1, 'cheap', 'trimf', c(0, 5, 10))
fis <- addmf(fis, 'output', 1, 'average', 'trimf', c(10, 15, 20))
fis <- addmf(fis, 'output', 1, 'generous', 'trimf', c(20, 25, 30))
# Adds a rule to a fis object.
rl <- rbind(c(1,1,1,1,2), c(2,0,2,1,1), c(3,2,3,1,2))
fis <- addrule(fis, rl)
showrule(fis)

plotmf(fis,"input",1)

inputs= rbind(c(3,7),c(2,7))
outputs = evalfis(inputs,fis)
print(outputs)


gensurf(fis)

# Show a GUI to display MFs plots for input and output, rules and evaluate the fis.
showGUI(fis)