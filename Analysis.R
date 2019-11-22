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
#par(mfrow=c(2, 3)) 


# TOST Function for any week

# the effect size 
theta <- log(x = 1.25)

# IGNORE
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
    n1 = 10, n2 = 10,
    low_eqbound_d = -theta,
    high_eqbound_d = theta,
    alpha = 0.05,
    var.equal = TRUE,
    plot = TRUE
  )
}

# TOST function after Consulting Session
TOSTtestfunc <- function(week_number, theta) {
  if (week_number < 9 & week_number > 0)
    data_num <- week_number + 2
  week_avgs <- c(data[data_num, "X.10"], data[data_num, "X.20"])
  WTLeafs <- as.integer(data[data_num, "WT.boxes"]) + 
    as.integer(data[data_num, "X.2"]) +
    as.integer(data[data_num, "X.3"])
  ClonesLeafs <- as.integer(data[data_num, "Clone.3.boxes"]) +
    as.integer(data[data_num, "X.12"]) +
    as.integer(data[data_num, "X.13"])
  TOSTtwo.prop(
    prop1 = as.double(week_avgs[1]), 
    prop2 = as.double(week_avgs[2]), 
    n1 = WTLeafs,
    n2 = ClonesLeafs, 
    low_eqbound = -theta, 
    high_eqbound = theta, 
    alpha = .05,
    plot = TRUE, 
    verbose = TRUE)
}


#TOST test function raw inputs
TOSTrawcalulations <- function(week_number, theta) {
  alpha <- .05
  if (week_number < 9 & week_number > 0)
    data_num <- week_number + 2
  week_avgs <- c(data[data_num, "X.10"], data[data_num, "X.20"])
  WTLeafs <- as.integer(data[data_num, "WT.boxes"]) + 
    as.integer(data[data_num, "X.2"]) +
    as.integer(data[data_num, "X.3"])
  ClonesLeafs <- as.integer(data[data_num, "Clone.3.boxes"]) +
    as.integer(data[data_num, "X.12"]) +
    as.integer(data[data_num, "X.13"])
  
  #calculatiing initial values
  WTprop <- as.double(week_avgs[1])
  CLONEprop = as.double(week_avgs[2])
  prop_dif <- WTprop - CLONEprop
  prop_se <- sqrt((WTprop*(1-WTprop))/WTLeafs + (CLONEprop*(1-CLONEprop))/ClonesLeafs)
  
  print(prop_se)
  print(prop_se / sqrt(WTLeafs + ClonesLeafs))
  
  #calculating z-statistic
                    #lower bound
  z1 <- (prop_dif - theta)/prop_se
                    #upper bound
  z2 <- (prop_dif - theta)/prop_se
  z  <- prop_dif / prop_se
  ztest <- 1 - pnorm(abs(z))
  
  #calculating p-value for both one-sided tests
  p1 <- 1 - pnorm(z1)
  p2 <- pnorm(z2)
  ptost <- max(p1,p2) #Get highest p-value for summary TOST result
  print(paste("p value = ",ptost))
  # ztost <- ifelse(abs(z1) < abs(z2), z1, z2) #Get lowest z-value for summary TOST result
  TOSToutcome <- if(ptost<alpha) {
    TOSToutcome <- "significant or not equivelent (H0)"
  } else {
    TOSToutcome <- "non-significant or equivelent (Ha)"
  }  
  print(TOSToutcome)
  #testoutcome <- ifelse(ztest<(alpha/2), "significant","non-significant")
  
  #Confidence Bounds (97.5)

}

# If the weekly TOST's show equivelence, no need for the accomodation of the repeeate measures


