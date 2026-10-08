library(tidyverse)

df <- read_csv("mass_island_characteristics.csv")


df %>%  
  ggplot(aes(x=sampling_site, y = weight_animal))+
  geom_boxplot()+
  coord_flip()

df %>% 
  group_by(sampling_site) %>% 
  summarize(n = sum(!is.na(weight_animal)))

sub_df <- df %>% 
  filter(sampling_site %in% c("Vancouver",  "Vancouver Island" , "Sidney Island"))


sub_df %>% 
  ggplot(aes(x=sampling_site, y = weight_animal))+
    geom_boxplot()+ 
  geom_point(position = position_dodge2(width = 0.3))


write_csv(sub_df,
  file = "mice_weights.csv"
)
