library(data.table)
# create a data.table
fruit = data.frame(x=rep(c("apple","banana","orange"),each=2), y=c(1,3,6), z=1:6)
setDT(fruit)
class(fruit)

as.data.table(fruit)

# copy data.table can prevent changing raw data
fruit_cp <- data.table::copy(fruit)

# set names can make it meaningful
setnames(fruit_cp, c("x","y","z"),
         c("name", "number", "money"))
fruit_cp

setcolorder(fruit_cp, c("name", "money","number"))
fruit_cp

# extract infromation what we need
fruit_cp[name == "banana", ]
fruit_cp[name == "banana"]
fruit[fruit$x == "banana",]

# select information from data.table
fruit_cp[money > 3, ]
fruit_cp[name %like% "e",]
fruit_cp[number %between% c(3,7)]
fruit_cp[money %between% c(3,7) & number %between% c(3,7)]
# %between% use to get range 3 to 7
  
# select 2nd colum
fruit_cp[,2]
# delete 2nd colum
fruit_cp[, -2]
fruit_cp[, c("name", "money")]
fruit_cp[, c(name, money)]
x <- c("name", "money")
fruit_cp[, x, with = FALSE]

# calculate content
fruit_cp[, .(x = sum(number))]

# add new columns
fruit_cp[name == "apple", c := 1+2]
fruit_cp
fruit_cp[name == "apple", c := 3+4]
fruit_cp

fruit_cp[, c := ifelse(money <4, "cheap", "expensive")]
fruit_cp

# two methods to add over 1 columns
fruit_cp[, `:=` (C = 1, D = 2)]
fruit_cp
fruit_cp[, c("e", "f") := list(1, rnorm(6))]
fruit_cp

# delete C column
fruit_cp[, C := NULL]
fruit_cp

fruit_cp[, f := as.integer(f)]
fruit_cp

fruit_cp[, name, by = .(number)]
fruit_cp[, f := sum(money), by = number]
fruit_cp
fruit_cp[, .SD[1], by = number]
fruit_cp[, .SD[.N], by = number]

# order columns
setorder(fruit_cp, number, -money)
fruit_cp
setorder(fruit_cp, -money, number)
fruit_cp

# select unique information
uniqueN(fruit_cp, by = c("name"))
unique(fruit_cp, by = c("name"))
base::unique(fruit_cp, by = c("name"))
unique.default(fruit_cp, by = c("name"))

# setkeys can easy to select content
setkey(fruit_cp, name)
haskey(fruit_cp)
key(fruit_cp)
setkey(fruit_cp, NULL)
haskey(fruit_cp)

fruit_cp["banana", ]
setkey(fruit_cp, number)
fruit_cp[1,]
fruit_cp[.(1)]
setkey(fruit_cp, name, number)
fruit_cp[.("banana", 1),]

fruit_cp["apple", sum(number)]

fruit_cp[, sum(number), by = name]

# how to bind data.table
dt_a <- data.table(a = 1:3,
                   b = c("c","a","b")
                   )
dt_a
dt_b <- data.table(x = rev(1:3),
                   y = c("b","c","b"))
dt_b
dt_a[dt_b, on = .(b = y)]

rbind(dt_a, dt_b, use.names = FALSE)

cbind(dt_a, dt_b)

# read data and export data
fwrite(fruit_cp, "fruit_out.tsv", sep = "\t")
fread("fruit_out.tsv", select = c("name", "number"))

x = data.table(chr=c("Chr1", "Chr1", "Chr2", "Chr2", "Chr2"),
               start=c(5,10, 1, 25, 50), end=c(11,20,4,52,60))
y = data.table(chr=c("Chr1", "Chr1", "Chr2"), start=c(1, 15,1),
               end=c(4, 18, 55), geneid=letters[1:3])
x
y

# find region which overlap between two data.table
setkey(y, chr, start, end)
foverlaps(x, y ,type = "any")
foverlaps(x, y ,type = "any", which = TRUE)
foverlaps(x, y ,type = "any", nomatch = NULL)

# reshape data.table 
reshape_dt <- data.table(kinds = c(rep("peach", 2), rep("grape", each = 2)), 
                         price = c("3","8","4","6"),
                         price2 = c("4","9","5","7"),
                         level = c("h","l","h","l"))
reshape_dt
reshape_dt_new <- melt(reshape_dt, id.vars = c("kinds", "level"), 
                       measure.vars = c("price", "price2"),
                       variable.name = "2price",
                       value.name = "money")
reshape_dt_new

dcast(reshape_dt_new, kinds + level ~ `2price`, value.var = "money")



