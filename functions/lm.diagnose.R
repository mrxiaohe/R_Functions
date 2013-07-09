
lm.diagnose <- function(lm.object, plotit=TRUE){
  require("psych") 
	require("nortest") 
	if( class(lm.object) != "lm" ) 
		stop("A fitted lm model is required.") 
	model.res  <- residuals(lm.object)
	model.pred <- predict(lm.object)
	if(plotit){
    	#Scatter plot of residuals against predicted values along with a lowess
		par(mfrow=c(2,2))
		plot(lm.object, which=c(1, 5))

		dens.y = hist(model.res, plot=F)$density
		#Histogram and normal curve
		hist(model.res, 
			 freq = FALSE, 
			 ylim = range(dens.y, dnorm(mean(model.res), mean=mean(model.res), sd=sd(model.res))),
			 main = "Histogram of Residuals and Normal Fit", 
			 cex.main = 1,
			 xlab = "Residuals",
			 ylab = "Density"
		)		 
		curve(dnorm(x, mean=mean(model.res), sd=sd(model.res)), add=TRUE)
		#Boxplot
		boxplot(model.res, main="Boxplot of Residuals", cex.main=1)
	}		
	cat("\n")
	print(lm.object$call)

	#Descriptives and normality tests
	describe.stats <- apply(t(describe(model.res)[,c(3,5,4,13,8:9,11:12)]), 2, round, 3)
	colnames(describe.stats) = " "
	#rownames(describe.stats)=" "

	normtests <- list(shapiro.test(model.res), 
	 				 lillie.test(model.res), 
	 				 ad.test(model.res),
	 				 cvm.test(model.res))
	norm.stats <- unlist(lapply(normtests, "[[", "statistic"))
	norm.ps <- unlist(lapply(normtests, "[[", "p.value"))

	cat("\nDESCRIPTIVES OF RESIDUALS")
	describe.output <- data.frame(describe.stats, 
	                              row.names=rownames(describe.stats))
	colnames(describe.output) = " "
 	print(describe.output)
	norm.rownames <- c("Shapiro-Wilk","Kolmogorov-Smirnov","Anderson-Darling","Cramer-von Mises")
	norm.results <- data.frame(statistic=norm.stats, 
						       p=norm.ps,
						       row.names=norm.rownames
						      )
	norm.output <- data.frame(statistic=round(norm.stats, 4),
							  p=format.pval(round(norm.ps, 4), 4),
							  ifelse(norm.ps < 0.0001, "***",
							 	     ifelse(norm.ps < 0.001, "**",
								     ifelse(norm.ps < 0.01, "**",
								     ifelse(norm.ps < 0.05, "*",
								     ifelse(norm.ps < 0.1, ".", " "))))),
							  row.names=norm.rownames)
	colnames(norm.output)[3] = c(" ")
	cat("\nTESTS FOR NORMALITY\n")
	print(norm.output)
	cat("---\n.0001 '***' .001 '**' .01 '*' .05 '.' .1\n\n")
	if( ncol(model.frame(lm.object)) > 2 ){
		multcollin.output <- multcollin( model.frame(lm.object)[,-1])
		output <- list(Descriptives = describe.stats, 
				   NormalityTests = norm.results,
				   MultcollinearityTests = multcollin.output)
	} else {
		output <- list(Descriptives = describe.stats, 
					    NormalityTests = norm.results)
	}
	invisible(output)
}
