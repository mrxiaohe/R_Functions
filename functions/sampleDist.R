sampleDist <- function( data, plotit=TRUE, seed=501 ) {
    #This function creates plots for the sampling distributions of the mean, median, and 20%
    #trimmed mean and outputs the standard errors of the mean, median, and 20% trimmed mean.
    #It's used to demonstrate effects of distributions on the sample mean, median and trimmed mean.
    
    if(seed)    #set the seed so that we can replicate the result.
      set.seed(seed)  
	  temp  <- sample( data, 50000, replace=TRUE )	#random sampling
	  mat   <- matrix( temp, ncol=100 )

	  means   <- colMeans(mat)
	  medians <- apply( mat, 2, median )
	  tmeans  <- apply( mat, 2, mean, tr=.2 )	
	
	  if(plotit){
		  smeans.dens   <- density( means )			#densities
		  smedians.dens <- density( medians )
		  stmeans.dens  <- density( tmeans )
	
		  xlimits <- range( smeans.dens$x, smedians.dens$x, stmeans.dens$x )
		  ylimits <- range( smeans.dens$y, smedians.dens$y, stmeans.dens$y )
	
		  plot( smeans.dens, 
            xlim = xlimits, 
            ylim = ylimits, 
            col="darkgreen", 
            main="Sampling  Distributions" )
		
      lines( smedians.dens, col="red" )
		  lines( stmeans.dens, col="darkblue" )
	
		  legend( "topleft",
              c("Samp dist. of the mean", "Samp dist. of the median", "Samp dist. of the tmean"), 
              col=c("darkgreen", "red","darkblue"), lty=1, bty="n")
  }
	
	mean.se   <- round( sd(means), 4 )
	median.se <- round( sd(medians), 4 )
	tmean.se  <- round( sd(tmeans), 4 )
	data.frame(SE=c(mean.se, median.se, tmean.se), 
             row.names=c("Mean", "Median", "Tmean"))	                      

}
