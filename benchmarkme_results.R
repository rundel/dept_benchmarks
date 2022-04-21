library(tidyverse)
library(bench)

r = map_dfr(
  fs::dir_ls("benchmarkme/", glob = "*.rds"),
  ~ readRDS(.x) %>%
    mutate(
      system = basename(.x) %>% str_remove_all("benchmarkme_|\\.rds"),
      across(c(min, median, total_time), bench::as_bench_time),
      across(c(mem_alloc), bench::as_bench_bytes)
    )
)

r %>%
  select(expression, system, median) %>%
  mutate(median = as.numeric(median)) %>%
  pivot_wider(expression, names_from = system, values_from = median) %>%
  write_csv("benchmarkme_prelim.csv")


r %>%
  rename(
    expression = system,
    system = expression
  ) %>%
  bench::as_bench_mark() %>%
  plot()

ggsave("benchmarkme_prelim.png", width = 10, height = 6)


r %>%
  group_by(expression) %>%
  mutate(
    min_time = min(unlist(time)),
    time = map2(time, min_time, `/`)
  ) %>%
  select(-min_time) %>%
  ungroup() %>%
  rename(
    expression = system,
    system = expression
  ) %>%
  bench::as_bench_mark() %>%
  plot()

ggsave("benchmarkme_prelim_rel.png", width = 10, height = 6)

