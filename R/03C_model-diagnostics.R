#########################################################################

#                     Quadratic model diagnostics                       #

#########################################################################


# Contact: maxime.fraser.franco@hotmail.com
# Département des Sciences Biologiques, UQAM, Montréal, Québec
# -----------------------------------------------------------------------





# =======================================================================
# 1. Set working directory, load libraries, datasets, and models
# =======================================================================

# Librairies
library(data.table)
library(brms)
library(bayesplot)
library(broom.helpers)

# Load dataset
data <- fread("./data/merged-data.csv",
              select = c("mirrors_id", "match_id", 
                         "map_name", "hunting_success", "Zspeed", 
                         "Zprox_mid_guard", "Zspace_covered_rate",
                         "Zsurv_speed", "Zhook_start_time",
                         "Zsurv_space_covered_rate"),
                         stringsAsFactors = TRUE)

# Load models
quadratic_model1 <- readRDS("./outputs/03C_hunting_success_quadratic-model1.rds")
load("./outputs/03C_hunting_success_quadratic-model2.rda")
quadratic_model2 <- quadratic_model
rm(quadratic_model)
#print(object.size(quadratic_model), units = "MB")

# =======================================================================
# =======================================================================





# =======================================================================
# 2. Basic model diagnostics (takes a very long time to compute)
# =======================================================================

# Diagnosis
# -------------------
# Observed y outcomes vs posterior predicted outcomes
dens_overlay1 <- brms::pp_check(quadratic_model1, type = "dens_overlay", nsamples = 100)
dens_overlay2 <- brms::pp_check(quadratic_model2, type = "dens_overlay", nsamples = 100)
#brms::pp_check(base_model, type = 'ecdf_overlay')


# Error scatter for predicted values
error1 <- brms::pp_check(quadratic_model1, type = 'error_scatter_avg', nsamples = 100)
error2 <- brms::pp_check(quadratic_model2, type = 'error_scatter_avg', nsamples = 100)


# Parameter value around posterior distribution
stat1 <- brms::pp_check(quadratic_model1, 
                        type = 'stat', stat = 'mean', nsamples = 100)
stat2 <- brms::pp_check(quadratic_model2, 
                         type = 'stat', stat = 'mean', nsamples = 100)


# residual vs covariate plots
speed <- brms::pp_check(quadratic_model1, x = 'Zspeed^2', 
                         type = 'error_scatter_avg_vs_x', nsamples = 100)
space <- brms::pp_check(quadratic_model1, x = 'Zspace_covered_rate^2', 
                         type = 'error_scatter_avg_vs_x', nsamples = 100)
guard <- brms::pp_check(quadratic_model1, x = 'Zprox_mid_guard^2', 
                         type = 'error_scatter_avg_vs_x', nsamples = 100)
hook <-  brms::pp_check(quadratic_model1, x = 'Zhook_start_time^2',
                         type = 'error_scatter_avg_vs_x', nsamples = 100)
survspeed <- brms::pp_check(quadratic_model2, x = 'Zsurv_speed^2',
                         type = 'error_scatter_avg_vs_x', nsamples = 100)
survspace <- brms::pp_check(quadratic_model2, x = 'Zsurv_space_covered_rate^2',
               type = 'error_scatter_avg_vs_x', nsamples = 100)


# Trace plots and parameter distributions
#plot(quadratic_model)
trace1 <- mcmc_plot(quadratic_model1, type = "trace")
dens1 <- mcmc_plot(quadratic_model1, type = "dens")

trace2 <- mcmc_plot(quadratic_model2, type = "trace")
dens2 <- mcmc_plot(quadratic_model2, type = "dens")

# Investigate overdispersion
#loo_plot <- plot(loo(quadratic_model))


# Rhat
rhat_vals_quad1 <- rhat(quadratic_model1)
rhat_table_quad1 <- as.data.table(mcmc_rhat_data(rhat_vals_quad1))

rhat_vals_quad2 <- rhat(quadratic_model2)
rhat_table_quad2 <- as.data.table(mcmc_rhat_data(rhat_vals_quad2))

# Display tables
rhat_table_quad1
rhat_table_quad2


# Effective sample sizes
neff_vals_quad1 <- neff_ratio(quadratic_model1)
neff_table_quad1 <- as.data.table(mcmc_neff_data(neff_vals_quad1))

neff_vals_quad2 <- neff_ratio(quadratic_model2)
neff_table_quad2 <- as.data.table(mcmc_neff_data(neff_vals_quad2))

# Display tables
neff_table_quad1
neff_table_quad2
# -------------------



# Export plots and tables
# -------------------
#pp_figure1 <- ggarrange(speed1,
#                        space1,
#                        guard1,
#                        hook1,
#                        survspeed1,
#                        survspace1,
#                        ncol = 3, nrow = 2)
#
#ggexport(pp_figure1, filename = "03C_pp_diagnose1.tiff",
#         width = 4500, height = 2500, res = 500) # more res = bigger plot zoom
#
#
#pp_figure2 <- ggarrange(speed2,
#                        space2,
#                        guard2,
#                        hook2,
#                        survspeed2,
#                        survspace2,
#                        ncol = 3, nrow = 2)
#
#ggexport(pp_figure2, filename = "03C_pp_diagnose2.tiff",
#         width = 5500, height = 3500, res = 500) # more res = bigger plot zoom
#
#
#ggexport(trace1, filename = "03C_trace1.tiff", 
#          width = 6500, height = 3500, res = 800)
#ggexport(dens1, filename = "03C_dens1.tiff", 
#          width = 6500, height = 3500, res = 800)
#ggexport(trace2, filename = "03C_trace2.tiff", 
#          width = 6500, height = 3500, res = 800)
#ggexport(dens2, filename = "03C_dens2.tiff", 
#          width = 6500, height = 3500, res = 800)
# -------------------

# =======================================================================
# =======================================================================