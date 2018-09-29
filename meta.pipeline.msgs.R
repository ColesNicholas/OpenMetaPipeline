# Throughotu the Shiny script, several messages are shown to the user.
# This code builds all of those messages and stores them in a vector.

#----
# Welcome message
welcome <- HTML("This app is a prototype for what is preliminarily called the 'Open MetaPipeline'
                <br> <br>
                  
                The 'Open MetaPipeline' is an open, crowd-sourced meta-analysis project. 
                Researchers can upload new data to a publicly open Google Sheet. 
                After the accuracy of the information has been confirmed by the application moderator, 
                the information on this website will be automatically updated with the most recent set of results. 
                <br> <br>

                The data displayed here are a ficticious dataset of studies comparing cognitive performance between 
                (a) individuals who received the 'Cher D. Data Smartification' intevention and 
                (b) individuls who served as controls. 
                The app calculates the overall effect size, tests one moderator (type of cognitive task), 
                and performs a variety of publication bias analyses.
                <br> <br>"
)

#----
# Information about hte funnel plot methodology
funnel.info <- "In a funnel plot, observed effect sizes are plotted against their 
corresponding standard errors. In the absence of bias, the resulting 
distribution should resemble a funnel, where studies with more precision 
(i.e., lower standard errors) converge towards the overall effect size estimate, 
and studies with lower precision fan out in both directions. 
If effect sizes that are less consistent with a hypothesized effect 
are omitted from the scientific record (i.e., there is publication bias), 
the funnel plot will typically be asymmetric. 
Consequently, asymmetry in the funnel plot distribution can be suggestive of bias."

#----
# Publication bias results
bias <- paste0("<strong> Trim and fill </strong>
               <br>
               Number of detected missing studies: ", results$bias$trim.miss,
               "<br>
               Bias-corrected overall effect size estimate: <i>d</i> = ", results$bias$trim.es, ",",
               "<i>p</i> = ", results$bias$trim.p, 
               "<br> <br>

               <strong> PET </strong> <br>
               Estimate of bias: B1 = ", results$bias$pet.b1, ",",
               "<i> p </i> =", results$bias$pet.b1.p,
               "<br>
               Bias-corrected overall effect size estimate: <i> d </i> = ", results$bias$pet.int, ",",
               "<i> p </i> =", results$bias$pet.int.p,
               "<br> <br>

               <strong> PEESE </strong> <br>
               Estimate of bias: <i> d </i> =", results$bias$peese.b1, ",",
               "<i> p </i> =", results$bias$peese.b1.p,
               "<br>
               Bias-adjusted overall effect size estimate:  <i> d </i> = ", results$bias$peese.int,
               "<br>") %>%
        HTML()

#----
# Info regarding publication bias methodology
bias.info <- HTML("In the trim-and-fill method, extreme observations that lead to asymmetry in the funnel plot distribution 
                  are removed, and values are imputed to even out the distribution. The bias-corrected overall effect 
                  size is then estimated with this new set of values. 
                  <br> <br>
                  In precision-effects tests (PET and PEESE), the relationship between effect size and variability
                  -which would theoretically be absent when there is no bias-is estimated and controlled for in a 
                  fixed-effect meta-regression model, producing a bias-corrected overall effect size estimate. 
                  <br> <br>
                  PET models the relationship between effect sizes and their corresponding standard errors. 
                  PEESE models the relationship between effect sizes and their corresponding variances.")


#----
# Results from overall meta-analysis
oval <- paste0("<strong> Overall effect size estimate </strong>
               <br>
               k =", results$oval$k,
               "<br>
               <i> d </i> = ", results$oval$es,
               "<br>",
        
               "95% CI [", results$oval$ci.lb.95, ",", results$oval$ci.ub.95, "]
               <br>
        
               <i> p </i> = ", results$oval$pval,
               "<br> <br>
        
        
               <strong> Test of heterogeneity </strong>
               <br>
               Q = ", results$oval$QE,
               "<br>
               <i> p </i> = ", results$oval$QEp,
               "<br> <br>") %>%
               HTML()

#----
# Info regarding overall effect size estimation methodology
oval.info <- HTML("The effect size of interest is the degree to which subjects who participated in the 
                  <i>Cher D. Data Smartification Intervention</i> outperformed control subjects in assessments 
                  of cognitive ability. Because cognitive ability was measured on different scales, standardized 
                  mean difference scores were used as the effect size index 
                  (Cohen's ds; Borenstein, 2009; Cohen, 1988).
                  <br> <br>
                  The overall effect size was estimated using random-effects meta-analysis. This approach is 
                  considered appropriate in instances where it is assumed that the true effect may vary 
                  from study-to-study (Hedges & Vevea, 1998). Using this approach, the overall effect size was calculated 
                  using the weighted average of the observed effect sizes, where weight was a function of the within-study 
                  and between-studies variance. 
                  <br> <br>
                  In summary, overall effect sizes were estimated using random-effects models of the weighted-average 
                  of standardized mean differences.")

#----
# Results from a moderator analysis examining type of cognitive test
mod.test <- paste0("<b>", "Digit-Span test", "</b>", "<br>",
                   "k = ", results$mod$ds_k, "<br>",
                   "<i>", "d", "</i>", "=", results$mod$ds_es, "<br>",
                   "95% CI [", results$mod$ds_ci.lb.95, ",", results$mod$ds_ci.ub.95, "]", "<br>",
                   "<i>", "p", "</i>", "=", results$mod$ds_pval, "<br>", "<br>",
                  
                   "<b>", "N-back test", "</b>", "<br>",
                   "k = ", results$mod$nb_k, "<br>",
                   "<i>", "d", "</i>", "=", results$mod$nb_es, "<br>",
                   "95% CI [", results$mod$nb_ci.lb.95, ",", results$mod$nb_ci.ub.95, "]", "<br>",
                   "<i>", "p", "</i>", "=", results$mod$nb_pval, "<br>", "<br>",
                  
                   "<b>", "Test of moderation", "</b>", "<br>",
                   "B1 = ", results$mod$mod, "<br>",
                   "95% CI [", results$mod$mod_ci.lb.95, ",", results$mod$mod_ci.ub.95, "]", "<br>",
                   "<i>", "p", "</i>", "=", results$mod$mod_pval) %>%
                   HTML()

#----
# Info regarding moderatator analysis methodology
mod.info <- "Overall effect sizes for each level of the moderator were estimated by conducting 
            random-effects meta-analyses. Hypothesis tests for the effects of the moderator were 
            conducted by including the moderator as a factor in a random-effects meta-analysis. 
            The significance test corresponding to the regression coefficient (B1) for this predictor 
            variable can be interpreted as a test of whether the factor is a significant moderator (Borenstein, 2009)"

#----
# Info about app developers
cont.dev <- "This app was developed by Nicholas A. Coles and Daniel Lakens thanks to joint support 
            from the U.S. National Science Foundation and the Netherlands Organisation for Scientific Research."

#----
# Info about users who contributed to the open meta-analytic database
cont.db <- paste0("<p> ", unique(DF$contributor), " </p>") %>%
           HTML()

#----
# Info about the original authors
cont.auth <- paste0("<p> ", unique(DF$study), " </p>") %>%
             HTML()

#----
# store all messages in a list, then delete vestigial
msg <- list(bias = bias, 
            bias.info = bias.info, 
            cont.auth = cont.auth, 
            cont.db = cont.db,
            cont.dev = cont.dev, 
            funnel.info = funnel.info, 
            mod.info = mod.info, 
            mod.test = mod.test,
            oval = oval, 
            oval.info = oval.info, 
            welcome = welcome)

rm(bias, bias.info, cont.auth, cont.db,
   cont.dev, funnel.info, mod.info, mod.test,
   oval, oval.info, welcome)