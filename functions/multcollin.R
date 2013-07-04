multcollin <- function(data, printit=TRUE){
  data <- as.matrix(data)
	ind <- 1:ncol(data)
	if(length(ind)==1) 
		stop("two or more variables are needed to test collinearity.")
	R2  <- function(x, y){
		fitted <- lm.fit(cbind(1, x), y)$fitted
		sum((fitted-mean(fitted))^2)/sum((y-mean(y))^2)
	}
	Rsq <- mapply(function(id){x <- data[,-id]
				   y <- data[, id]
				   R2(x, y)}, 
				   id = ind)
	tol <- 1 - Rsq
	vif <- 1/tol
	test1 <- data.frame(Rsq = Rsq, 
	                    Tol = tol, 
	                    VIF = vif,
			    row.names = colnames(data))
	Kappa <- kappa(data)
	if(printit){
		    cat("\n\tTests for Multicollinearity\n\n")
		    print(as.data.frame(format(test1, digits=4)))
		    cat("\nCondition number:  ", round(Kappa, 3))
	}
	invisible(list(test1 = test1, `condition number` = Kappa))	
}
