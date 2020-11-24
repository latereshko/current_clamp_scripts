library(tidyverse)
library(IgorR)
library(magrittr)

filename <- file.choose()
directory <- dirname(filename)
file_list <- list.files(path = directory, pattern = "^Cell")

getSpikeCount <- function(data,threshold) {
  data <- data %>% mutate(
    OverI = case_when(
      RecordI > threshold ~ 1,
      TRUE ~ 0)
  )
  runs <- rle(data$OverI)
  spikes <- sum(runs$values)
  return(spikes)
}

get_all_spikes <- function(x) {
  data <- IgorR::read.ibw(file.path(directory,x)) %>% 
    as.numeric() %>% data.frame(RecordI = .)
  getSpikeCount(data,threshold = -10)
}

get_all_waves <- function(x) {
  data <- IgorR::read.ibw(file.path(directory,x))
}

num_spikes <- sapply(file_list, FUN = get_all_spikes)
waves<- sapply(file_list, FUN = get_all_waves)

#PLOT ALL WAVES
 lapply(colnames(waves),function(x){
   plot.ts(waves[,x],main=x,type="l", col=rainbow(ncol(waves)))
 })


maxes <- apply((waves[1:2500,]), 2, max)
mins <- apply((waves[1:2500,]), 2, min)
Rin_estimate <- (mins-maxes)/0.025
FR <- FR <- num_spikes/20


alldata <- data.frame(cell_name = file_list, Spikes = num_spikes, Minimum = mins, 
                      Maximum =maxes, Rin = Rin_estimate, FR = FR)

write_csv(alldata, path = file.path(dirname(directory),"10_thresh_spikes.csv"))

avg <-separate(alldata, cell_name, into = c("cell", "recording"), sep = "_00")
AVGFR <- avg %>% group_by(cell) %>% summarize(AVGFR=mean(FR))

write_csv(AVGFR, path = file.path(dirname(directory),"10_threshAVGFR.csv"))

