library(tidyverse)
library(dplyr)
library(readr)
library(readxl)
library(ggplot2)

setwd("~/Desktop")
Data <- read_excel("Log.xlsx")

Data <- Data %>% group_by(PID, Week) %>%
  mutate(group_id = cur_group_id())

Data <- Data[!is.na(Data$PHQ9),]
Data <- Data[!Data$PHQ9=="N/A",] 
Data$PHQ9 <- as.numeric(Data$PHQ9)
WeeklyPHQ9 <- aggregate(Data$PHQ9, list(Data$group_id), FUN=mean)
WeeklyPHQ9$group_id <- WeeklyPHQ9$Group.1


Merged <- left_join(Data, WeeklyPHQ9, by = "group_id")


Single <- Merged[!duplicated(Merged$group_id),]

g <- ggplot(Single, aes(Week, x)) +
  geom_point() +
  facet_wrap(~PID)

g

