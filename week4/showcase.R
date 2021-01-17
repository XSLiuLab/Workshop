grep("at", x = c("cat", "at", "df"))
grepl("at", x = c("cat", "at", "df"))


grep("^at", x = c("cat", "at", "df"))
grep("at$", x = c("cat", "at", "df", "caty"))
grep("at.", x = c("cat", "at", "df", "caty"))
grep("at.*", x = c("cat", "at", "df", "caty"))
grep("at.+", x = c("cat", "at", "df", "caty"))
# ? 0 or 1
# * >= 0
# + >= 1
grep("(at){2}", x = c("at", "atat", "atatat"))
# () used to group
# {}
grep("(at){1,2}", x = c("at", "atat", "atatat"))
## how to exclude three times?
grep("(at){1,2}", x = c("at", "atat", "atatat"))

grep("^at", x = c("cat", "at", "df"), value = TRUE)

sub(pattern = "ab", "", "abababc")
gsub(pattern = "ab", "", "abababc")

sub(pattern = "abab", "", "abababc")
sub(pattern = "abab(.+)", "\\1", x = c("abababc", "abababd"))

emals <- c("a@xx.com", "b@yy.com", "c@shanghaitech", "zzzz@yahoo.com")
# \\.
sub("(.+)@.+", "\\1", emals)

sub(".com", "", emals, fixed = TRUE) %>% 
sub("^([^@]+)@(.+)$", "\\1-\\2", .)

#sub("(.+)@([^(\\.com)]+)(\\.com)?", "\\1-\\2", emals, fixed = TRUE)


lm(mpg ~ wt + cyl, data = mtcars)
## y = a0 + a1*x1 + a2*x2
lm(mpg ~ wt + cyl - 1, data = mtcars)
lm(mpg ~ wt:cyl, data = mtcars)
lm(mpg ~ wt*cyl, data = mtcars)
# wt*cyl => wt + cyl + wt:cyl

fit <- lm(mpg ~ wt + cyl, data = mtcars)
summary(fit)
coefficients(fit)
predict(fit, newdata = head(mtcars))

wt
a = mpg ~ wt + cyl
b = "mpg ~ wt + cyl"

typeof(a)
class(a)
as.list(a)

as.formula("mpg ~ wt + cyl")
x = c("mpg", "wt", "cyl")
paste0(x[1], "~", paste0(x[2:3], collapse = "+"))
as.formula(paste0(x[1], "~", paste0(x[2:3], collapse = "+")))



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
  nest() -> data

class(data$data)
sapply(data$data, class)

#lapply
#map

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

model_df2

model_df2$gg[[1]]
# Comparison
ggplot(subset(mtcars, gear == 4), aes(wt, mpg)) + geom_point() +
  geom_smooth(method = "lm", se = FALSE)

## Plot a list of ggplot2 objects
cowplot::plot_grid(plotlist = model_df2$gg)

glist = model_df2$gg
glist = lapply(glist, function(x) {
  x + cowplot::theme_cowplot()
})

glist[[1]]

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


data.frame(
  g = c(rep("a", 2), rep("b", 2)),
  v = c(1, 1, 1, 2)
) %>% 
  group_by(g) %>% 
  summarise(v_unique = list(unique(v)))

data.frame(
  g = c(rep("a", 2), rep("b", 2)),
  v = c(1, 1, 1, 2)
) %>% 
  group_by(g) %>% 
  summarise(v_unique = list(unique(v))) %>% 
  unnest("v_unique")

## What if mpg, wt and gear are cheanged?
## Could you implement a function to do this?

colnames(mtcars)

plotGroupLM <- function(g, p, r) {
  gglist = list()
  for (i in unique(mtcars[[g]])) {
    df_subset <- subset(mtcars, mtcars[[g]] == i)
    coefs = coef(lm(as.formula(
      paste0(r, "~", p)
    ), data = df_subset))
    print(coefs)
    gglist[[as.character(i)]] <- ggplot(df_subset, aes_string(p, r)) + 
      geom_point() +
      geom_abline(intercept = coefs[1], slope = coefs[2])
  }
  cowplot::plot_grid(plotlist = gglist)
}

plotGroupLM("vs", "wt", "mpg")

mtcars %>% 
  group_by(gear) %>% 
  nest() %>% 
  mutate(model = map(data, function(x) {
    lm(mpg ~ wt, data = x)
  })) %>% mutate(gg = map2(data, model, function(x, y) {
    # x represents data subset
    # y represents a model based on the data subset
    coefs = coef(y)
    ggplot(x, aes(wt, mpg)) + geom_point() +
      geom_abline(intercept = coefs[1], slope = coefs[2])
  })) %>% 
  pull(gg) %>% 
  cowplot::plot_grid(plotlist = .)

