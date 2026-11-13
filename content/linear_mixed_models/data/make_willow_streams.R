# ==========================================================
# make_willow_streams.R
#
# Builds data/willow_streams_simulated.csv - SIMULATED data,
# not a real study. It has the layout of a real student
# project: 3 streams, each with a reference reach, a reach
# with crack willow, and a reach where willow was removed,
# and 15 benthic samples per reach.
#
# Because we made it, we know the truth:
#   willow lowers insect numbers by 30% (exp(-0.35))
#   removal leaves them 10% below reference (exp(-0.10))
#   streams differ (SD 0.30 on the log scale)
#   reaches differ within a stream (SD 0.20)
#   samples differ within a reach (SD 0.45)
#
# Run from the project root.
# ==========================================================
library(tidyverse)

set.seed(14)

w_df <- expand_grid(stream = c("A", "B", "C"),
                    reach  = c("reference", "willow", "removed"),
                    sample = 1:15)

stream_eff <- rnorm(3, 0, 0.30)
reach_eff  <- rnorm(9, 0, 0.20)
trt_eff    <- c(reference = 0, willow = -0.35, removed = -0.10)

s_i <- as.integer(factor(w_df$stream))
r_i <- as.integer(factor(paste(w_df$stream, w_df$reach)))

w_df$insects <- pmax(1, round(exp(
  3.6 + trt_eff[w_df$reach] + stream_eff[s_i] + reach_eff[r_i] +
    rnorm(nrow(w_df), 0, 0.45))))

write_csv(w_df, "content/linear_mixed_models/data/willow_streams_simulated.csv")
