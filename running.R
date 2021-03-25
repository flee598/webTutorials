
library(nzffdr)
library(dplyr)
dat <- nzffdr::nzffd_import(starts = 1999, ends = 2010)
dat <- nzffd_clean(dat)
dat <- nzffd_fill(dat, alt = F, maps = F)
dat <- nzffd_add(dat)


rec <- read.csv("https://www.dropbox.com/s/zqn9f9ctb4hv74q/rec2010.csv?dl=1")

dat <- dat[,1:30]


intersect(dat$nzreach, rec$nzreach)
setdiff(dat$nzreach, rec$nzreach)


?print
?min
min(rec$DISTSEA, na.rm = T)

?join

datBoth <- inner_join(dat, rec, by = "nzreach")


datBoth <- datBoth %>%
  filter(y < 2011) %>%
  select(nzreach, y, east, north, altitude, effort, number:common_name, threat_class:native, 
         ORDER, DISTSEA) %>%
  mutate(distsea_km = DISTSEA/1000,
         ORDER = as.factor(ORDER))



wtbt <- c("Koaro", "Inanga", "Shortjaw kokopu", "Banded kokopu", "Giant kokopu")

datWtbt <- datBoth %>%
  filter(common_name %in% wtbt) %>%
  select(common_name, y, east, north, distsea_km)

# basic plot
datWtbt$common_name <- factor(datWtbt$common_name, 
                              levels = c("Koaro", "Shortjaw kokopu", "Inanga", 
                                         "Banded kokopu", "Giant kokopu"))
  
  
ggplot(datWtbt, aes(x = common_name, y = distsea_km, colour = common_name)) +
  geom_jitter(alpha = 0.5) +
  scale_colour_brewer(palette = "Dark2") +
  coord_flip() +
  xlab("Species") +
  ylab("Distance to sea (km)") +
  theme_bw() +
  theme(legend.position = "bottom")

# amp


nz <- nzffdr::nzffd_nzmap
nz <- filter(nz, island != "Chatham Island")
class(nz)




ggplot() +
  geom_sf(data = nz) +
  geom_point(data = datWtbt, aes(x = east, y = north, colour = common_name), size = 1.5) +
  scale_x_continuous(breaks = c(2e6, 25e5, 3e6)) +
  scale_y_continuous(breaks = c(54e5, 61e5, 68e5)) +
  coord_sf(datum = sf::st_crs(27200)) +
  theme_light()









