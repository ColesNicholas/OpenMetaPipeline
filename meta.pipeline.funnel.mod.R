# This script builds a funnel plot in ggplot2.
DF$color <- NA

for (i in 1:nrow(DF)) {
  if (DF$test[i] == "digit_span"){
    DF$color[i] <- "red"
  }
  if (DF$test[i] == "n-back"){
    DF$color[i] <- "blue" 
  }
}
rm(i)


#-----
# Prep information for creating 95% and 99% CI regions in plot

# Create a sequence that spans from 0 to max std. error in dataframe
se.seq <- seq(0, max(DF$se), 0.001)

# Create dataframe of values for 99% CI polygon
  # Create 99% CI sequences
  lb.99.seq <- results$oval$es - (3.29 * se.seq)
  ub.99.seq <- results$oval$es + (3.29 * se.seq)

  # Use information to build a data.frame of information necessary for creating polygon
  ci.99.DF <- data.frame(x = c(results$oval$es, min(lb.99.seq), max(ub.99.seq)),
                        y = c(0, max(DF$se), max(DF$se))
    )

# Create 95% CI sequences
lb.95.seq <- results$oval$es - (1.96 * se.seq)
ub.95.seq <- results$oval$es + (1.96 * se.seq)

  # Use information to build a data.frame of information necessary for creating polygon
  ci.95.DF <- data.frame(x = c(results$oval$es, min(lb.95.seq), max(ub.95.seq)),
                         y = c(0, max(DF$se), max(DF$se))
)

#----
# Create funnel plot in ggplot2
fun.plot.mod <- ggplot(aes(x = yi, y = se, group = DF$test, colour = DF$test),
                   data = DF) +
  
  # create 99% CI polygon
  geom_polygon(data = ci.99.DF, 
               mapping = aes(x = x, y = y, group = NA, colour = NA),
               colour = "black",
               fill = "white") +
  
  # create dotted 95% CI polygon
  geom_polygon(data = ci.95.DF, 
               mapping = aes(x = x, y = y, group = NA, colour = NA),
               colour = "black",
               linetype = "dashed",
               fill = "transparent") +
  
  # Add datapoints to the scatterplot
  geom_point(shape = 16) +
  
  # Add x- and y-axis labels
  xlab("Cohen's d") + ylab("Standard Error") + 
  
  # Reverse the x-axis ordering and bounds
  scale_y_reverse() +
  
  # Add overall effect line
  geom_segment(aes(x = results$oval$es, xend = results$oval$es, 
                   y = 0, yend = max(DF$se)), 
               colour = "black") +
  
  # Adjust theme
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = c(.88, .88))

#----
# Delete vestigial output
rm(se.seq, lb.99.seq, ub.99.seq, ub.95.seq, lb.95.seq, ci.99.DF, ci.95.DF)