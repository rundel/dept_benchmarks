#remotes::install_github("stan-dev/cmdstanr")
#cmdstanr::install_cmdstan()

library(cmdstanr)

data(mcycle, package="MASS")

m = cmdstan_model(stan_file = here::here("other/gpstan/gp.stan"))

d = list(
  x = mcycle$times,
  y = mcycle$accel,
  N=length(mcycle$times)
)

res = m$sample(
  data=d, iter_warmup=100, iter_sampling=100,
  chains=2, parallel_chains=2, threads_per_chain = 4,
  refresh=10
)
