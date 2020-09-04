library(dplyr)

FL <- read.csv('https://raw.githubusercontent.com/gitcnk/Data/master/ElectionData/Florida_before2016.csv')

FL_edu <- FL %>%
            select(no_hs_diploma, 
                   hs_diploma, 
                   associates_degree, 
                   bachelors_degree, 
                   above_bachelors_degree)


FL_edu_pca <- prcomp(FL_edu, center = T, scale = T)  
summary(FL_edu_pca)
FL_edu_pca


PC1 <- predict(FL_edu_pca)[,1]
FL$edPC1 <- PC1

library(ggplot2)

ggplot( data = FL) +
  geom_point(mapping = aes( x = who_won_2012,
                             y = -edPC1,
                             col = who_won_2012)) +
  coord_flip()


ggplot( data = FL) +
  geom_point(mapping = aes( x = who_won_2012,
                            y = education_index,
                            col = who_won_2012)) +
  coord_flip()
