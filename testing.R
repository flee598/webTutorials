
library(dplyr)


# Handy base functions for inspecting data 
head(iris, n = 5)
str(iris)
unique(iris$Species)
table(iris$Species)

# 1 Joining datasets together
a common challenge is joining multiple datasets together e.g. water quality and biological dat for a range of sites, joining datasets can be achieved via the *_join() functions from `dplyr`, for a *_join() there needs to be a column that is common between the two datasets to be joined e.g.

Look at the two band datasets:
band_member
band_instruments

# includes all rows that occur in both datasets
band_members %>% inner_join(band_instruments)

# includes all rows that occur in band_members
band_members %>% left_join(band_instruments)

# includes all rows that occur in band_instruments
band_members %>% right_join(band_instruments)

# includes all rows that occur in either dataset
band_members %>% full_join(band_instruments)

###########################
# 2 Dealing with columns  #
###########################

#2.1.  selecting/dropping columns - `dplyr::select()`

# individual columns
iris %>%
  select(Petal.Width, Species) %>%
  head(n = 3)

# multiple columns
iris %>%
  select(Sepal.Length:Petal.Length, Species)%>%
  head(n = 3)

# prefix character matching 
iris %>%
  select(starts_with("S")) %>%
  head(n = 3)

# multiple character patterns
iris %>% 
  select(starts_with(c("Petal", "Sepal"))) %>%
  head(n = 3)

# character patterns anywhere in the column name
iris %>% 
  select(contains("al")) %>%
  head(n = 3)

# drop columns
iris %>%
  select(-Petal.Width, -Species) %>%
  head(n = 3)

iris %>%
  select(!starts_with("S")) %>%
  head(n = 3)


#2.1. renaming columns

# all
rename_with(iris, toupper) %>%
  head(n = 3)

# by name
rename(iris, petal_length = Petal.Length) %>%
  head(n = 3)

# only certain columns 
rename_with(iris, toupper, starts_with("Petal")) %>%
  head(n = 3)

#######################
# 3 Dealing with rows #
#######################

# 3.1. filtering 

# by name
iris %>%
  filter(Species == "setosa") %>%
  head(n = 3)

# by value
iris %>%
  filter(Sepal.Length > 5.0) %>%
  head(n = 3)

# by function
iris %>% 
  filter(Sepal.Length  > mean(Sepal.Length, na.rm = TRUE)) %>%
  head(n = 3)

# by multiple conditions 
iris %>%
  filter(Species == "setosa" & Sepal.Length > 5.0) %>%
  head(n = 3)

iris %>%
  filter(Species == "setosa" | Sepal.Length > 5.0) %>%
  head(n = 3)

# between
iris %>%
  filter(!between(Sepal.Length, 4, 5)) %>%
  head(n = 3)

# anti-filter
iris %>%
  filter(!between(Sepal.Length, 4, 5)) %>%
  head(n = 3)

############################
# 4 Creating new variables #
############################

# 4.1. dplyr::mutate()

# create new columns
iris %>%
  mutate(Petal.size = Petal.Length + Petal.Width) %>%
  head(n = 3)

# modify an existing column
iris %>%
  mutate(Species= as.character(Species)) %>%
  head(n = 3)

# multiple columns at once 
iris %>%
  mutate(across(!Species, ~. + 100)) %>%
  head(n = 3)

# stack functions (min_rank(desc()))
iris %>%
  mutate(rank = min_rank(desc(Sepal.Length))) %>%
  head(n = 3)

# combining with ifelse
iris %>%
  mutate(Size.Class = ifelse(Sepal.Length < 5, "small", "large")) %>% 
  head(n = 5)

# mutate and drop unused columns (Sepal.Length, Sepal.Width, Species)
iris %>%
  mutate(Petal.size = Petal.Length + Petal.Width, .keep = "used") %>%
  head(n = 3)

# mutate and drop used columns (Petal.Length, Petal.Width)
iris %>%
  mutate(Petal.size = Petal.Length + Petal.Width, .keep = "unused") %>%
  head(n = 3)

# 4.2. adding a grouping variable - dplyr::group_by()
# group_by() more typically used with dplyr::summarise() than mutate() 
iris %>%
  group_by(Species) %>%
  mutate(N = n(),
         Mn.Sep.Len = mean(Sepal.Length)) %>%
  head(n = 3)


####################
# 5 summarise data #
####################

# 5.1 dplyr::summarise()
iris %>%
  group_by(Species) %>%
  mutate(N = n(),
         Mn.Sep.Len = mean(Sepal.Length)) %>%
  head(n = 3)

#####################
# other little bits #
#####################

# getting rid of NA data 
# if there are NAs in Sepal.Length
iris %>%
  filter(!is.na(Sepal.Length)) %>%
  head(n = 3)

# if there are NAs anywhere 
iris %>%
  na.omit() %>%
  head(n = 3)


# recode variables 


# arrange()

# subsetting rows 
iris %>%
  group_by(Species) %>%
  slice(1:3) 


iris %>%
  group_by(Species) %>%
  slice_min(Petal.Width, n = 5) 


# tallying records 
iris %>%
  count(Sepal.Length, name = "n_obs", sort = TRUE)


# and by sub groups 
iris %>%
  count(Species, Sepal.Length, name = "n_obs", sort = TRUE)




