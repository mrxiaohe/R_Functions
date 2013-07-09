sampleDist <- function( FUN, sam_size=200, niter=2000, seed=501, plotit=TRUE,...) {
    #This function creates plots for the sampling distributions of the mean, median, and 20%
    #trimmed mean and outputs the standard errors of the mean, median, and 20% trimmed mean.
    #It can be used to demonstrate the effect of non-normality on different location estimators. 

    	if(seed)
		set.seed(501)		#set the seed so that we can replicate the result.

	mat  <- matrix( FUN( sam_size*niter, ...), ncol=niter )
	means   <- apply( mat, 2, mean )				#creating sampling distributions
	medians <- apply( mat, 2, median )
	tmeans  <- apply( mat, 2, mean, tr=.2 )	
	
	if(plotit){
		smeans.dens   <- density( means )			#densities
		smedians.dens <- density( medians )
		stmeans.dens  <- density( tmeans )
	
		xlimits <- range( smeans.dens$x, smedians.dens$x, stmeans.dens$x )
		ylimits <- range( smeans.dens$y, smedians.dens$y, stmeans.dens$y )
	
		plot( smeans.dens, xlim=xlimits, ylim=ylimits, col="darkgreen", 
			  main="Sampling Distributions" )
		lines( smedians.dens, col="red")
		lines( stmeans.dens, col="darkblue")
	
		legend( "topright", 
			bty ="n",
			c("Samp means", "Samp medians", "Samp tr. means"), 
			col=c("darkgreen", "red","darkblue"), 
			lty=1)
	}
	
	mean.se   <- round( sd(means), 4 )
	median.se <- round( sd(medians), 4 )
	tmean.se  <- round( sd(tmeans), 4 )
	data.frame(SE=c(mean.se, median.se, tmean.se), row.names=c("Mean", "Median", "Tmean"))	                      
}
