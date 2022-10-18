library(biwavelet)
library(aTSA)
library(TTR)

setwd('C:/Users/Nick/Downloads/CFDATA')


# Import Data (2002-2018 ES & CL continuous data)
data = read.csv("ES_CL.csv", header = TRUE)
attach(data)


#### Time Series ####
dt = seq(0, length(ES)-2, by=1) # Time-step array

ES_stationary = diff(log(ES), lag = 1) # 1st-Ord log diff
CL_stationary = diff(log(CL), lag = 1) # 1st-Ord log diff

# Augmented Dickey–Fuller Test
adf_ES = adf.test(ES_stationary) # Test Stationarity
adf_CL = adf.test(CL_stationary) # Test Stationarity

t1 = cbind(dt, ES_stationary) # Merge Time-step with Stationary ES
t2 = cbind(dt, CL_stationary) # Merge Time-step with Stationary CL


#### Volatility ####
vol_ES = volatility(ES, calc = 'close', N = 252) # Volatility of ES
vol_CL = volatility(CL, calc = 'close', N = 252) # Volatility of CL
vol_ES = na.omit(vol_ES) # Remove NA vals
vol_CL = na.omit(vol_CL) # Remove NA vals

dt2 = seq(0, length(vol_ES)-1, by=1) # Time-step array for Vol
t3 = cbind(dt2, vol_ES) # Merge Time-step with Vol_ES
t4 = cbind(dt2, vol_CL) # Merge Time-step with Vol_CL


#### Wavelet Coherence ####

nrands = 10 # Number of iterations
wtc.AB = wtc(t1, t2, nrands = nrands) # Wavelet Coherence 


# Plot graph
par(oma = c(0, 0, 0, 1), mar = c(5, 4, 5, 5) + 0.1)
plot(wtc.AB, plot.phase = TRUE, lty.coi = 1, col.coi = "grey", lwd.coi = 2, 
     lwd.sig = 2, arrow.lwd = 0.03, arrow.len = 0.12, ylab = "Period", xlab = "Time (Days)", 
     plot.cb = TRUE, main = "Wavelet Coherence: ES vs CL (Volatility)")

n = length(t1[, 1])
abline(v = seq(252, n, 252), h = 1:16, col = "brown", lty = 1, lwd = 1)
axis(side = 3, at = c(seq(0, n, 252)), labels = c(seq(2002, 2018, 1)))


#### Wavelet Coherence (Volatility) ####

wtc.CD = wtc(t3, t4, nrands = nrands) # Wavelet Coherence (Volatility)

# Plot graph
par(oma = c(0, 0, 0, 1), mar = c(5, 4, 5, 5) + 0.1)
plot(wtc.CD, plot.phase = TRUE, lty.coi = 1, col.coi = "grey", lwd.coi = 2, 
     lwd.sig = 2, arrow.lwd = 0.03, arrow.len = 0.12, ylab = "Period", xlab = "Time (Days)", 
     plot.cb = TRUE, main = "Wavelet Coherence: ES vs CL (Volatility)")

n = length(t1[, 1])
abline(v = seq(252, n, 252), h = 1:16, col = "brown", lty = 1, lwd = 1)
axis(side = 3, at = c(seq(0, n, 252)), labels = c(seq(2002, 2018, 1)))
