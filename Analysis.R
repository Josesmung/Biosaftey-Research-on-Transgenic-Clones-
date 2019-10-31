library(TOSTER)
# Reading in Data, observations converted from Excel to CSV file
data <- read.csv("data/plant-obs.csv", stringsAsFactors = F)

# Data organized as vectors, first vector is always control type (WT) and
# second vector organized as test type (T3)

                # for wild tipe    # for clone3
# 20 C
week1_results <- c(data[3, c(3:5)], data[3, c(6:8)])
week1_avgs <- c(data[3, "X.10"], data[3, "X.20"])
week1_sds <- c(data[3, "X.11"], data[3, "X.21"])

# 15 C
week2_avgs <- c(data[4, "X.10"], data[4, "X.20"])
week2_sds <- c(data[4, "X.11"], data[4, "X.21"])

# 10 C
week3_avgs <- c(data[5, "X.10"], data[5, "X.20"])
week3_sds <- c(data[5, "X.11"], data[5, "X.21"])

# 5 C
week4_avgs <- c(data[6, "X.10"], data[6, "X.20"])
week4_sds <- c(data[6, "X.11"], data[6, "X.21"])

# 2 C
week5_avgs <- c(data[7, "X.10"], data[7, "X.20"])
week5_sds <- c(data[7, "X.11"], data[7, "X.21"])

# 0 C
week6_avgs <- c(data[8, "X.10"], data[8, "X.20"])
week6_sds <- c(data[8, "X.11"], data[8, "X.21"])

# -2 C
week7_avgs <- c(data[9, "X.10"], data[9, "X.20"])
week7_sds <- c(data[9, "X.11"], data[9, "X.21"])

# -5 C
week8_avgs <- c(data[10, "X.10"], data[10, "X.20"])
week8_sds <- c(data[10, "X.11"], data[10, "X.21"])

weeks_data <- c(
  week1_avgs, week1_sds, week2_avgs, week2_sds,
  week3_avgs, week3_sds, week4_avgs, week4_sds,
  week5_avgs, week5_sds, week6_avgs, week6_sds,
  week7_avgs, week7_sds, week8_avgs, week8_sds
)
# TOST Test

# used to include all graphs
par(mfrow=c(2, 3)) 


# TOST Function for any week
effect_size <- log(x = 1.25)

TOSTfunc <- function(week_number) {
  if (week_number < 9 & week_number > 0)
  data_num <- week_number + 2
  week_avgs <- c(data[data_num, "X.10"], data[data_num, "X.20"])
  week_sds <- c(data[data_num, "X.11"], data[data_num, "X.21"])
  TOSTtwo(
    m1 = as.double(week_avgs[1]),
    m2 = as.double(week_avgs[2]),
    sd1 = as.double(week_sds[1]), 
    sd2 = as.double(week_sds[2]),
    n1 = 3, n2 = 3,
    low_eqbound_d = -effect_size,
    high_eqbound_d = effect_size,
    alpha = 0.05,
    var.equal = TRUE,
    plot = TRUE
  )
  
}



# If the weekly TOST's show equivelence, no need for the accomodation of the repeeate measures


