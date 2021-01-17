library(tidyverse)

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

x <- data.frame(
  x1 = 1,
  y2 = 2,
  x3 = 3,
  y1 = "string",
  x2 = 3,
  y3 = TRUE
)
x

x %>% select_if(is.numeric)
x %>% select_if(is.logical)
# x %>% select_if(is.character)
x %>% select_all()

x = data.frame(
  name = paste0("gene", 1:10),
  gene1 = 1:100,
  gene2 = 100:199
)

x

#x %>% tibble::column_to_rownames("name")
x %>% 
  select_if(is.numeric) %>% 
  mutate_all(~ . - mean(.)) -> x2

f <- function(x) {
  x - mean(x) 
}

x %>% 
  select_if(is.numeric) %>% 
  mutate_all(f) -> x3

identical(x2, x3)

head(mtcars)
select_all(mtcars, function(x) paste0(x, "_yes"))
select_all(mtcars, ~paste0(., "_yes"))

# Custom
filter(mtcars, carb > 2)
filter_at(mtcars, vars(gear, carb), all_vars(. == 4))
# Some
# 行满足的条件是：
## 以 d 开头的变量中任意存在一个为 偶数 就返回
filter_at(mtcars, vars(starts_with("d")), any_vars((. %% 2) == 0))
# ALL
filter_all(mtcars, all_vars(. > 0))


mtcars %>% 
  group_by(carb) %>% 
  tidyr::nest() -> z

mtcars %>% 
  group_by(carb) %>% 
  summarize_all(sum) -> z2

z
z$data[[1]]$mpg %>% sum

z2$mpg[[4]]


substr("ABCDE", 2, 4)
substring("ABCDE", 2)

# sub()
# gsub()
# grep()
# grepl()



# Tidyr -------------------------------------------------------------------

x = tibble(a = 1, b = 2)
class(x)

inherits(x, "data.frame")
is.data.frame(x)

tribble(
  ~x, ~y,
  1, 2,
  3, 4
)

x = c(1, 2)
names(x) = c("a", "b")
x
enframe(x)


x = list(
  a = 1,
  b = c(2, 3)
)

x
enframe(x)

data.frame() %>% 
  as_tibble()

df <- data.frame(Month = 1:12, Year = c(2000, rep(NA, 11)))
df
df %>% fill(Year)

df %>% drop_na()
df %>% replace_na(list(Year = 1))

pivot_longer()
pivot_wider()

relig_income %>% glimpse()
relig_income %>%
  pivot_longer(-religion, names_to = "income", values_to = "count") -> data_long

ggplot(data_long, aes(x = religion, y = count, color = income)) +
  geom_point()

?pivot_wider

fish_encounters
fish_encounters %>%
  pivot_wider(names_from = station, values_from = seen, values_fill = list(seen = 100))

expand(mtcars, vs, cyl)
# grid search

df <- data.frame(x = c(NA, "a.b.c", "a.d.c", "b.c.x"))
df
df %>% separate(x, c("A", "B", "C"), sep = "\\.") -> df2

df2 %>% unite(col = "C", A, B, C, sep = ",")

df <- data.frame(
  x = 1:3,
  y = c("a", "d,e,f", "g,h"),
  z = c("1", "2,3,4", "5,6"),
  stringsAsFactors = FALSE
)

df %>% separate_rows(y, z)


# Write -------------------------------------------------------------------

readr::write_csv()
readr::write_tsv()


# data.table --------------------------------------------------------------
library(data.table)

fread()
fwrite()

DF = data.frame(x=rep(c("b","a","c"),each=3), y=c(1,3,6), v=1:9)
DF

DF %>% as.data.table()

mtcars[rep(1:32, 20), ]
mtcars[rep(1:32, 20), ] %>% as.data.table()

# DT[ i,  j,  by ] # + extra arguments
# |   |   |
#   |   |    -------> grouped by what?
#   |    -------> what to do?
#   ---> on which rows?

#setDT()

DT = DF %>% as.data.table()
# data.table
DT[x == "b" & y == 1]
# data.frame
DF[DF$x == "b" & DF$y == 1 , ]
# dplyr
DF %>% filter(x == "b", y == 1)

DT[x == "b", c("y", "v")]
DT[x == "b", list(y, v)]
DT[x == "b", c(2, 3)]
DT[x == "b", c(FALSE, TRUE, TRUE)]

## Update
DT[x == "b", c("y", "v") := 1]
DT[x == "b", `:=`(
  y = 100,
  v = 100
)]
## 上述两个操作效果是一样的，
## 我视频中将 v 写成了 z 所以不一样
DT

setDT(DF)
DF

DF[, list(y_sum = sum(y)), by = x]
DF[, .(y_sum = sum(y)), by = x]

# i, j, by
DF[x %in% c("a", "b"), .(y_sum = sum(y)), by = x]
DF[x %in% c("a", "b"), .(y_sum = sum(y),
                         v_sum = sum(v)), by = x]

DF[x %in% c("a", "b"), .(y_sum = paste(y, collapse = ",")), by = x]


