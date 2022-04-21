library(cmdstanr)

m = cmdstan_model(stan_file = here::here("other/logistic_stan/logistic.stan"))

m_par = cmdstan_model(stan_file = here::here("other/logistic_stan/logistic_parallel.stan"),
                      cpp_options = list(stan_threads = TRUE))

inv_logit = function(x) 1 / (1+exp(-x))

N = 5000
x = runif(N, -2, 2)
eta = inv_logit( -1 + x )
y = rbinom(N, 1, eta)


d = list(
  x = x,
  y = y,
  N = N
)

res = m$sample(
  data=d, iter_warmup=5000, iter_sampling=5000,
  chains=1, parallel_chains=2,#threads_per_chain = 4,
  refresh=500
)

res = m_par$sample(
  data=d, iter_warmup=5000, iter_sampling=5000,
  chains=1, parallel_chains=2, threads_per_chain = 8,
  refresh=500
)
