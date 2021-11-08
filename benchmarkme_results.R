library(tidyverse)

r = map_dfr(
  dir("benchmarkme/", full.names = TRUE),
  ~ readRDS(.x) %>% mutate(system = basename(.x) %>% str_remove_all("benchmarkme_|\\.rds"))
)

r %>%
  rename(
    expression = system,
    system = expression
  ) %>%
  plot()

