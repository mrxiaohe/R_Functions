#Plots continuous interaction between iv1 and iv2. A scatter plot of dv and iv1 is plotted with regression lines showing
#how the relationship between dv and iv1 changes as a function iv2. users can specify different iv2 values (iv2.values)
#at which regression lines are plotted or specify the different quantiles of iv2 that regression lines are plotted. By
#default, `iv2.quantiles` is used.

cinterplot<-function(data.frame, dv, iv1, iv2, iv2.values=NULL, iv2.quantiles=c(.25, .5, .75), 
					lty=NULL, xlab=NULL, ylab=NULL,
                   col.line="black", col.pch="black",...){
	if(!is.null(iv2.values) && !is.null(iv2.quantiles))
		warning("`iv2.values` and `iv2.quantiles` cannot both be specified; `iv2.values` is used")
	y 	<- data.frame[[dv]]
	x1	<- data.frame[[iv1]]
	x2 	<- data.frame[[iv2]]
	if(!is.null(iv2.values)){
		val <- iv2.values
	} else {
		if(any(iv2.quantiles<0 | iv2.quantiles>1))
			stop("`iv2.quantiles` cannot be below 0 or above 1")
		else 
			val <- quantile(x2, probs = iv2.quantiles)
	}
	if(is.null(lty)) 
		lty	<- 1:length(val)
	
	ivmat <- cbind(1, x1, x2, x1*x2)
	coef <- lm.fit(ivmat, y)$coef
	
	if(is.null(xlab))	
		xlab <- iv1
	if(is.null(ylab))	
		ylab <- dv
	plot(x1, y, xlab=xlab, ylab=ylab, col=col.pch,...)
	
	b0 <- coef[1] + coef[3]*val
	b1 <- coef[2] + coef[4]*val
	coef.new<-t(cbind(b0,b1))
	invisible(mapply(function(x, lty, col) abline(coef=x, lty=lty, col=col,...), x=data.frame(coef.new), lty=lty, col=col.line))
}