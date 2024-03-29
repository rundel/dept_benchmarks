library(tidyverse)
library(bench)

matrix_calcs = list(
  bm_matrix_cal_manip = function(min_iter=10) {
    invisible(gc())
    bench::mark(
      `Creation, transp., deformation of a 5,000 x 5,000 matrix` = {
        a = matrix(rnorm(2500 * 2500) / 10, ncol = 2500, nrow = 2500)
        b = t(a)
        dim(b) = c(1250, 5000)
        a = t(b)
      },
      min_iterations = min_iter
    )
  },

  bm_matrix_cal_power = function(min_iter=10) {
    a = abs(matrix(rnorm(2500 * 2500) / 2, ncol = 2500, nrow = 2500))
    invisible(gc())
    bench::mark(
      `2,500 x 2,500 normal distributed random matrix^1,000` = a^1000,
      min_iterations = min_iter
    )
  },

  bm_matrix_cal_sort = function(min_iter=10) {
    a = rnorm(7000000)
    invisible(gc())

    bench::mark(
      `Sorting of 7,000,000 random values` = sort(a, method = "quick"),
      min_iterations = min_iter
    )
  },

  bm_matrix_cal_cross_product = function(min_iter=10) {
    a = rnorm(2500 * 2500)
    dim(a) = c(2500, 2500)
    invisible(gc())

    bench::mark(
      `2,500 x 2,500 cross-product matrix (b = a' * a)` = crossprod(a),
      min_iterations = min_iter
    )
  },

  bm_matrix_cal_lm = function(min_iter=10) {
    b = as.double(1:5000)

    a = matrix(rnorm(5000 * 500), 5000, 500)
    invisible(gc())

    bench::mark(
      `Linear regr. over a 5,000 x 500 matrix (c = a \\ b')` = solve(crossprod(a), crossprod(a, b)),
      min_iterations = min_iter
    )
  }
)




matrix_funcs = list(
  bm_matrix_fun_fft = function(min_iter = 10) {
    b = 0

    a = rnorm(2500000)
    invisible(gc())
    bench::mark(
      `FFT over 2,500,000 random values` = {fft(a)},
      min_iterations = min_iter
    )
  },

  bm_matrix_fun_eigen = function(min_iter=10) {
    a = array(rnorm(600 * 600), dim = c(600, 600))
    invisible(gc())

    bench::mark(
      `Eigenvalues of a 640 x 640 random matrix` = eigen(a, symmetric = FALSE, only.values = TRUE)$Value,
      min_iterations = min_iter
    )
  },

  bm_matrix_fun_determinant = function(min_iter=10) {

    a = rnorm(2500 * 2500)
    dim(a) = c(2500, 2500)
    invisible(gc())

    bench::mark(
      `Determinant of a 2,500 x 2,500 random matrix` = det(a),
      min_iterations = min_iter
    )
  },

  bm_matrix_fun_cholesky = function(min_iter=10) {

    x = matrix(rnorm(3000 * 3000), 3000, 3000)
    a = crossprod(x)
    invisible(gc())

    bench::mark(
      `Cholesky decomposition of a 3,000 x 3,000 matrix` = chol(a),
      min_iterations = min_iter
    )
  },

  bm_matrix_fun_inverse = function(min_iter=10) {
    a = matrix(rnorm(1600 * 1600), 1600, 1600)
    invisible(gc())

    bench::mark(
      `Inverse of a 1,600 x 1,600 random matrix` = solve(a),
      min_iterations = min_iter
    )
  }
)

prog_funcs = list(
  bm_prog_fib = function(min_iter=10) {
    phi = 1.6180339887498949
    a = floor(runif(3500000) * 1000)
    invisible(gc())

    bench::mark(
      `3,500,000 Fibonacci numbers calculation (vector calc)` = (phi^a - (-phi) ^ (-a)) / sqrt(5),
      min_iterations = min_iter
    )
  },

  bm_prog_hilbert = function(min_iter=10) {
    a = 3500;
    invisible(gc())

    bench::mark(
      `Creation of a 3,500 x 3,500 Hilbert matrix (matrix calc)` = {
        b <- rep(1:a, a); dim(b) <- c(a, a);
        b <- 1 / (t(b) + 0:(a - 1))
      }
    )
  },

  bm_prog_gcd = function(min_iter=10) {

    gcd2 = function(x, y) {
      if (sum(y > 1.0E-4) == 0) {
        x
      } else {
        y[y == 0] <- x[y == 0]; Recall(y, x %% y)
      }
    }

    a = ceiling(runif(1000000) * 1000)
    b = ceiling(runif(1000000) * 1000)
    invisible(gc())

    bench::mark(
      `Grand common divisors of 1,000,000 pairs (recursion)` = gcd2(a, b),
      min_iterations = min_iter
    )
  },

  bm_prog_toeplitz = function(min_iter=10) {
    N = 3000
    ans = rep(0, N * N)
    dim(ans) = c(N, N)
    invisible(gc())

    bench::mark(
      `Creation of a 3,000 x 3,000 Toeplitz matrix (loops)` = {
        for (j in 1:N) {
          for (k in 1:N) {
            ans[k, j] = abs(j - k) + 1
          }
        }
      },
      min_iterations = min_iter
    )
  },

  bm_prog_escoufier = function(min_iter=10) {
    p <- 0; vt <- 0; vr <- 0; vrt <- 0; rvt <- 0; RV <- 0; j <- 0; k <- 0; #nolint
    x2 <- 0; R <- 0; r_xx <- 0; r_yy <- 0; r_xy <- 0; r_yx <- 0; r_vmax <- 0    #nolint
    # Calculate the trace of a matrix (sum of its diagonal elements)
    tr = function(y) {
      sum(c(y)[1 + 0:(min(dim(y)) - 1) * (dim(y)[1] + 1)], na.rm = FALSE)
    }

    x = abs(rnorm(60 * 60))
    dim(x) = c(60, 60)
    invisible(gc())

    bench::mark(
      `Escoufier's method on a 60 x 60 matrix (mixed)` = {
        # Calculation of Escoufier's equivalent vectors
        p <- ncol(x)
        vt <- 1:p                                  # Variables to test
        vr <- NULL                                 # Result: ordered variables
        RV <- 1:p                                  # Result: correlations #nolint
        vrt <- NULL
        # loop on the variable number
        for (j in 1:p) {
          r_vmax <- 0
          # loop on the variables
          for (k in 1:(p - j + 1)) {
            x2 <- cbind(x, x[, vr], x[, vt[k]])
            R <- cor(x2)                           # Correlations table #nolint
            r_yy <- R[1:p, 1:p]
            r_xx <- R[(p + 1):(p + j), (p + 1):(p + j)]
            r_xy <- R[(p + 1):(p + j), 1:p]
            r_yx <- t(r_xy)
            rvt <- tr(r_yx %*% r_xy) / sqrt(tr(r_yy %*% r_yy) * tr(r_xx %*% r_xx)) # RV calculation
            if (rvt > r_vmax) {
              r_vmax <- rvt                         # test of RV
              vrt <- vt[k]                         # temporary held variable
            }
          }
          vr[j] <- vrt                             # Result: variable
          RV[j] <- r_vmax                           # Result: correlation
          vt <- vt[vt != vr[j]]                      # reidentify variables to test
        }
      },
      min_iterations = min_iter
    )
  }
)


run_benchmarks = function(benchmarks = c(prog_funcs, matrix_calcs, matrix_funcs), min_iter = 10) {
  purrr::map_dfr(
    benchmarks,
    ~ .x(min_iter=min_iter) %>%
      mutate(
        expression = attr(expression, "description"),
        result = list(NULL)
      )
  )
}

RhpcBLASctl::omp_set_num_threads(4)
z = run_benchmarks(min_iter = 10)


system = Sys.info()["nodename"] %>% str_remove("\\.local")

saveRDS(
  z,
  file = file.path(
    "benchmarkme",
    paste0("benchmarkme_", system, ".rds")
  )
)

