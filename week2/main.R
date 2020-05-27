
# Read and save data in base R --------------------------------------------

read.csv()
read.table()

write.csv()
write.table()

mtcars

data2 = 1:10

save(mtcars, data2,  file = "week2/data.RData")
saveRDS(mtcars, file = "week2/mtcars.rds")

d <- readRDS(file = "week2/mtcars.rds")
d

rm(list = ls())
ls()

load(file = "week2/data.RData")
ls()


# readr & readxl -------------------------------------------------------------------

readr::read_csv()
readr::read_tsv()
readr::read_delim()
readxl::read_excel()
  readxl::read_xls()
  readxl::read_xlsx()

readr::read_csv_chunked()

data <- mtcars


# dplyr -------------------------------------------------------------------

# %>% CTRL(CMD) + SHIFT + M
# label CTRL(CMD) + SHIFT + R
# ESC cancel input
library(dplyr)

heights <- c(1.7, 1.8, 1.6, NA)
heights %>% mean()
heights %>% mean(na.rm = TRUE)

# heights %>% mean(na.rm = TRUE) => mean(heights, na.rm = TRUE)
a1 <- heights %>% 
  lag() %>% 
  mean(na.rm = TRUE)

a <- lag(heights)
b <- mean(a, na.rm = TRUE)

a1
b
# like shell | symbol
#cat xx.txt | grep "hello" | uniq |

## Filter

mtcars %>% 
  filter(carb == 4, am == 1)  # A and B and ...
mtcars %>% 
  filter(carb == 4, am == 1)  # A or B or ..
mtcars %>% 
  filter(carb == 4 | am == 1)

(mtcars$carb == 4 & mtcars$am == 1) %>% sum()
mtcars %>% 
  filter(mtcars$carb == 4 & mtcars$am == 1)

nrow(mtcars)
mtcars %>% 
  filter(1:32 %% 2 == 0)

mtcars[1:3, ]
mtcars %>% slice(1:3)

mtcars %>% sample_n(5)

mtcars %>% top_n(3, hp)

df <- data.frame(x = c(10, 4, 1, 6, 3, 1, 1))
df %>% top_n(2, x)


mtcars %>% mutate(index = row_number()) -> x
distinct(x, carb, .keep_all = TRUE)

## Select
colnames(mtcars)
mtcars %>% select(mpg, hp, wt)

x <- data.frame(
  x1 = 1,
  y2 = 2,
  x3 = 3,
  y1 = 2,
  x2 = 3,
  y3 = 4
)
x

x %>% select(starts_with("x"))
x %>% select(starts_with("y"))
x %>% select(ends_with("x"))
x %>% select(ends_with("1"))
x %>% select(c(num_range("x", range = 2:3), num_range("y", range = 2:3)))

x %>% select(x1, x2, x3, y1, y2, y3)
x %>% select(c(paste0("x", 1:3), paste0("y", 1:3)))


mtcars %>% arrange(gear)
mtcars %>% arrange(desc(gear))

## Mutate
x$y1 <- NULL
x

x %>% 
  mutate(z = x2 + y2)

x %>% 
  mutate(z = x2 + 1:2)

x %>% 
  transmute(z = x2 + y2)

x %>% 
  mutate(z = x2 + y2,
         z2 = x1 + y3)

x %>% 
  rename(
    width = x1,
    length = x3
  )

tibble::rownames_to_column()
tibble::column_to_rownames()

mtcars
mtcars %>% rownames()

mtcars %>% 
  tibble::rownames_to_column("car_name") %>% 
  tibble::column_to_rownames("car_name")

1:10 %>% lag()
1:10 %>% lead()

1:10 %>% sum()
1:10 %>% cumsum()

1:10 %>% cume_dist
1:20 %>% cume_dist

mtcars %>% 
  mutate(
    new = case_when(
      gear == 4 & carb == 4 ~ "Good",
      gear <=2 | carb <= 2 ~ "Bad",
      TRUE ~ "Not bad"
    )
  )

# ifelse(
#   gear == 4 & carb == 4, "Good",
#   ifelse(
#     gear <=2 | carb <= 2, "Bad",
#     "Not bad"
#   )
# )




# Summarize ---------------------------------------------------------------

mtcars %>% count(carb)
mtcars %>% count(carb, gear)

mtcars %>% 
  group_by(carb) %>% 
  summarise(mean_mpg = mean(mpg))

mtcars %>% 
  group_by(carb, gear) -> z1

mtcars %>% 
  group_by(carb, gear) %>% 
  summarise(mean_mpg = mean(mpg)) -> z2

groups(z1)
groups(z2)

z2 %>% 
  ungroup() %>% 
  groups()

z1 %>% 
  summarise(wt_plus = list(wt + 1)) -> z3

z3$wt_plus %>% length()

# data.frame cannot 
tibble(
  a = 1:3,
  b = 1,
  c = list(a = 1:2, b = 3, c = 11)
)

z1 %>% 
  summarise(count = sum(hp > 100))

z1$hp > 100
sum(c(TRUE, FALSE, TRUE))
mean(c(TRUE, FALSE, TRUE))



# Bind data ---------------------------------------------------------------

bind_rows(
  tibble(
    a = 1, b = 2
  ),
  tibble(
    a = 3, b = 4
  )
)

bind_cols(
  tibble(
    a = 1:2
  ),
  tibble(
    b = 3:4
  )
)

cbind(
  tibble(
    a = 1:2
  ),
  tibble(
    b = 3:4
  )
)

a = tibble(
  math = 91:100,
  id = 1:10
)

a

b = tibble(
  english = 90:99,
  id = 2:11
)

b

full_join(a, b, by = "id")
left_join(a, b, by = "id")
right_join(a, b, by = "id")
anti_join(a, b, by = "id")
anti_join(b, a, by = "id")
# Remove rows in a but not in b
semi_join(a, b, by = "id")

union(
  c("a", "b"),
  c("b", "c")
)

setdiff(
  c("a", "b"),
  c("b", "c")
)

intersect(
  c("a", "b"),
  c("b", "c")
)

