myplot <-function(name, colour){
  pdf(paste0(name, ".pdf"))
  a = seq(0,1,0.1)
  c = a * (a^2)
  plot(a, c, col=colour, pch="*")
  dev.off()
}