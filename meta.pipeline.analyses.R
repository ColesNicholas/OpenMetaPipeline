# This script loads, preps, and analyzes the data. It then organizes the output into a list.

#-----
# Load data from Googlesheet
# Note: because this Google Sheet is openly published, it will not request authentication
DF <- gs_read(ss = gs_url(x = "https://docs.google.com/spreadsheets/d/1bdFWlMgK9me4LFYxS14cf8MQjVUayG2Iw_HjEQPRxhk/edit#gid=4371574",
                          lookup = FALSE,
                          visibility = "public")
              )

# limit to cases that have confirmed accuracy by moderator 
# then delete unnecessary columns
DF <- subset(DF, confirmed == "yes")
DF$confirmed <- NULL
DF$report_issue <- NULL

# calculate effect size, variance, and std err (Cohen's d) using escalc function
DF <- escalc(measure = "SMD",
             n1i = n_controls, n2i = n_patients,
             m1i= mean_controls, m2i = mean_patients,
             sd1i = sd_controls, sd2i = sd_patients,
             data = DF)
DF$se <- sqrt(DF$vi)

# round effect size, variance, and std err (will make later displays cleaner)
DF$yi <- round(x = DF$yi, digits = 2)
DF$vi <- round(x = DF$vi, digits = 2)
DF$se <- round(x = DF$se, digits = 2)

# convert categorical moderator to factor
DF$test <- as.factor(DF$test)

#----
# Run random-effects meta-analysis.
rma.oval <- rma(yi = yi,
                vi = vi,
                data = DF,
                method = "REML")

# Put important output in a list
oval <- list(es = as.numeric(rma.oval$beta),
             ci.lb.95 = rma.oval$ci.lb,
             ci.ub.95 = rma.oval$ci.ub,
             pval = rma.oval$pval,
             k = rma.oval$k,
             QE = rma.oval$QE,
             QEp = rma.oval$QEp)

#----
# Perform subgroup and moderation tests for 'test' moderator
# digit_span subgroup analysis
rma.ds <- rma(yi = yi,
              vi = vi,
              data = DF,
              subset = test == "digit_span",
              method = "REML")

# n-back subgroup analysis
rma.nb <- rma(yi = yi,
              vi = vi,
              data = DF,
              subset = test == "n-back",
              method = "REML")

# test of moderation  
rma.mod <- rma(yi = yi,
               vi = vi,
               mods = ~ test,
               data = DF,
               method = "REML")

# Put important output in a list
mod <- list(ds_es = as.numeric(rma.ds$beta),
            ds_ci.lb.95 = rma.ds$ci.lb,
            ds_ci.ub.95 = rma.ds$ci.ub,
            ds_pval = rma.ds$pval,
            ds_k = rma.ds$k,
            nb_es = as.numeric(rma.nb$beta),
            nb_ci.lb.95 = rma.nb$ci.lb,
            nb_ci.ub.95 = rma.nb$ci.ub,
            nb_pval = rma.nb$pval,
            nb_k = rma.nb$k,
            mod = as.numeric(rma.mod$beta[2,1]),
            mod_ci.lb.95 = rma.mod$ci.lb[2],
            mod_ci.ub.95 = rma.mod$ci.ub[2],
            mod_pval = rma.mod$pval[2])

# Delete vestigial output
rm(rma.ds, rma.nb, rma.mod)

#----
# Examine publication bias
# Duval and Tweedie trim and fill
trim <- trimfill(x = rma.oval)

# PET-PEESE
pet <-   lm(DF$yi ~ DF$se, 
            weights = 1 / DF$vi)
peese <- lm(DF$yi ~ DF$vi, 
            weights = 1 / DF$vi)

# Put important output in a list
bias <- list(trim.miss = trim$k0,
             trim.es = as.numeric(trim$beta[1,1]),
             trim.p = trim$pval,
             pet.int = summary(pet)$coefficients[1,1],
             pet.int.p = summary(pet)$coefficients[1,4],
             pet.b1 = summary(pet)$coefficients[2,1],
             pet.b1.p = summary(pet)$coefficients[2,4],
             peese.int = summary(peese)$coefficients[1,1],
             peese.int.p = summary(peese)$coefficients[1,4],
             peese.b1 = summary(peese)$coefficients[2,1],
             peese.b1.p = summary(peese)$coefficients[2,4])

# Delete vestigial output
rm(rma.oval, trim, pet, peese)

#----
# Nest the lists into a single list
results <- list(oval = oval, 
                mod = mod, 
                bias = bias)

# round all the values in the list (will make later displays cleaner)
results$oval <- lapply(results$oval, round, 2)
results$mod <- lapply(results$mod, round, 2)
results$bias <- lapply(results$bias, round, 2)

# [tmp fix] hard code the below p-value, which was rounded to 0
results$oval$QEp <- .001

# Delete vestigial output
rm(oval, mod, bias)