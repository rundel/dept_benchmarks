library(tidyverse)

d = readr::read_csv(
  fs::dir_ls("stat_comp_benchmarks/", glob = "*.csv"),
  id = "machine",
  col_names = c("model", "time")
) %>%
  mutate(
    machine = machine %>%
      str_remove("stat_comp_benchmarks/performance_") %>%
      str_remove("\\.csv"),
    model = model %>%
      str_remove("stat_comp_benchmarks/benchmarks/")
  ) %>%
  pivot_wider(
    id_cols = model,
    names_from = machine,
    values_from = time
  ) %>%
  filter(model != "performance.compilation")

d %>%
  mutate(across(where(is.numeric), ~round(.x, 3))) %>%
  write_csv(file = "stat_comp_benchmarks.csv")


g = d %>%
  filter(model != "low_dim_corr_gauss/low_dim_corr_gauss.stan") %>%
  pivot_longer(-model, names_to = "machine", values_to = "time") %>%
  group_by(model) %>%
  mutate(time = time / min(time)) %>%
  ggplot(aes(x=time, y=model, fill = machine)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(title = "Relative performance for various stan models")


ggsave("stat_comp_benchmarks_rel.png", plot = g)



d %>%
  filter(model != "low_dim_corr_gauss/low_dim_corr_gauss.stan") %>%
  pivot_longer(-model, names_to = "machine", values_to = "time") %>%
  group_by(model) %>%
  mutate(time = time / time[3]) %>%
  ggplot(aes(y = time, x = machine)) +
  geom_violin() +
  geom_jitter()


## Benchmarkme

d = tibble(
  files = fs::dir_ls("benchmarkme/", glob = "*.csv"),
  machine = str_remove_all(files, "benchmarkme/|\\.csv"),
  data = map(files, ~ {read_csv(.x) %>% select(-1)})
) %>%
  unnest(data) %>%
  group_by(test_group, test, machine) %>%
  summarise(time = mean(elapsed))

d %>%
  ungroup() %>%
  mutate(test = paste(test_group, test, sep = " - ")) %>%
  select(-test_group) %>%
  pivot_wider(
    id_cols = test,
    names_from = machine,
    values_from = time
  ) %>%
  mutate(across(where(is.numeric), ~round(.x, 3))) %>%
  write_csv(file = "benchmarkme.csv")

g = d %>%
  group_by(test) %>%
  mutate(time = time / min(time)) %>%
  ggplot(aes(x=time, y=test, fill = machine)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(title = "Relative performance for various stan models")

d %>%
  group_by(test) %>%
  mutate(time = time / time[2]) %>%
  ggplot(aes(y = time, x = machine)) +
    geom_violin() +
    geom_jitter()


ggsave("benchmarkme_rel.png", plot = g)
