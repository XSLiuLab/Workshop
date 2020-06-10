library(ggplot2)

?mtcars
# mpg	Miles/(US) gallon
# Weight (1000 lbs)
# Number of forward gears

p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
coef(lm(mpg ~ wt, data = mtcars))
p + geom_abline(intercept = 37, slope = -5)
p + facet_grid(rows = vars(gear), scales = "free") + geom_smooth(method = "lm", se = FALSE)

# Construct mpg ~ wt for each gear ---------------------------------------
library(dplyr)
library(tidyr)
library(purrr)

mtcars %>% 
  group_by(gear)

mtcars %>% 
  group_by(gear) %>% 
  nest() 

mtcars %>% 
  group_by(gear) %>% 
  nest() %>% 
  mutate(model = map(data, function(x) {
    lm(mpg ~ wt, data = x)
  }))
  
model_df <- mtcars %>% 
  group_by(gear) %>% 
  nest() %>% 
  mutate(model = map(data, function(x) {
    lm(mpg ~ wt, data = x)
  }))

model_df$data[[1]]
model_df$model[[1]]

model_df2 <- model_df %>% 
  mutate(gg = map2(data, model, function(x, y) {
    # x represents data subset
    # y represents a model based on the data subset
    coefs = coef(y)
    ggplot(x, aes(wt, mpg)) + geom_point() +
      geom_abline(intercept = coefs[1], slope = coefs[2])
  }))

model_df2$gg[[1]]
# Comparison
ggplot(subset(mtcars, gear == 4), aes(wt, mpg)) + geom_point() +
  geom_smooth(method = "lm", se = FALSE)

## Plot a list of ggplot2 objects
cowplot::plot_grid(plotlist = model_df2$gg)


## This can also be implemented by for loop
gglist = list()
for (i in unique(mtcars$gear)) {
  df_subset <- subset(mtcars, gear == i)
  coefs = coef(lm(mpg ~ wt, data = df_subset))
  gglist[[as.character(i)]] <- ggplot(df_subset, aes(wt, mpg)) + geom_point() +
    geom_abline(intercept = coefs[1], slope = coefs[2])
}
gglist$`3`
cowplot::plot_grid(plotlist = gglist)


## What if mpg, wt and gear are cheanged?
## Could you implement a function to do this?