library(tidyverse)
library(bench)

r = map_dfr(
  fs::dir_ls("benchmarkme/", glob = "*.rds"),
  ~ readRDS(.x) %>% mutate(system = basename(.x) %>% str_remove_all("benchmarkme_|\\.rds"))
)

r %>%
  rename(
    expression = system,
    system = expression
  ) %>%
  plot()

ggsave("benchmarkme_prelim.png", width = 10, height = 6)

