#Tests for mediation effect based on Andrew Hayes' SPSS macro

indirect <- function(iv, m, dv, data, nboot=5000, alpha=.05, stand=F, seed=5, cpp=FALSE, plotit=TRUE, plotfun=hist,...){
  if(seed)
      set.seed(seed)    
    x   <- data[, c(iv, m, dv)]
    if(stand) 
        x   <- apply(x, 2, scale) #z-score center variables
    X   <- x[,iv]
    M   <- x[,m]
    Y   <- x[,dv]
    n   <- nrow(x)


    #Bootstrapping
    sam <- sample(n, nboot*n, T)    
    if(cpp){
      require("RcppArmadillo")
      indirects   <- .Call("ab_C", X=as.vector(X), M=as.vector(M), Y=as.vector(Y), IND=sam-1)
    }else{
        bcoef <- function(x, y){
          t(solve(t(cbind(1,x))%*%cbind(1,x))%*%(t(cbind(1,x))%*%y))[,2]
      }
      indirects   <- mapply(function(id) 
                            {ind=sam[(id*n+1):((1+id)*n)]
                            bcoef(X[ind], M[ind])[1]*bcoef(cbind(M[ind], X[ind]), Y[ind])}, 
                            id=0:(nboot-1)
                            )
    } 

    confind     <- c(round(alpha*nboot/2), nboot - round(alpha*nboot/2) + 1) 
    bootest     <- mean(indirects<-sort(indirects, partial=confind))
    confint     <- indirects[confind]
    bootse      <- sd(indirects)
    bootpval    <- 2*min(mean(indirects<0) + 0.5*mean(indirects==0), 
                         1 - mean(indirects<0) + 0.5*mean(indirects==0))
    boot.table  <- data.frame(bootest, bootse, confint[1], confint[2], bootpval, row.names="Effect: ")
    colnames(boot.table) <- c("Estimate", "Std. Error", "cilo", "cihi", "p")
    boot.print  <- boot.table
    boot.print[,-5] <- apply(boot.print[,-5], 2, format, digits=5)
    boot.print[,5] <- format.pval(boot.print[,5], digits=5, nsmall=5)
    
    #Total and direct effects
    fit         <- as.data.frame(rbind(summary(lm(Y~X))$coef[-1,], 
                                       summary(lm(M~X))$coef[-1,], 
                                       summary(lm(Y~M+X))$coef[-1,]))
    rownames(fit) <- c("b(Y~X)", "b(M~X)", "b(Y~M.X)", "b(Y~X.M)")
    fit.print       <- fit
    fit.print[,-4]  <- apply(fit[,-4], 2, format, digits=5)
    fit.print[,4]   <- format.pval(fit[,4], digits=5, nsmall=5)

    #Sobel's test
    estimate    <- fit[2,1]*fit[3,1]
    sobel.se    <- sqrt(fit[3,1]^2*fit[2, 2]^2 + 
                        fit[2,1]^2*fit[3, 2]^2 +
                        fit[2,2]^2*fit[3,2]^2)
    sobel       <- data.frame(estimate, 
                              sobel.se, 
                              estimate/sobel.se, 
                              estimate - qnorm(1 - alpha/2)*sobel.se,
                              estimate + qnorm(1 - alpha/2)*sobel.se,
                              2*(1-pnorm(abs(estimate/sobel.se))), 
                              row.names = "Sobel:  ")
    colnames(sobel) <- c("Value", "Std. Error", "z", "cilo", "cihi", "Pr(>|z|)")
    sobel.print       <- sobel
    sobel.print[,-6]  <- apply(sobel[,-6], 2, format, digits=5)
    sobel.print[,6]   <- format.pval(sobel[,6], digits=5, nsmall=5)

    #Plot
    if(plotit){
      args.list <- list(...)
      args.list <- modifyList(list(main="Distribution of Indirect Effects Based on Bootstrap Samples", 
                              xlab="Indirect effect", ylab="Frequency"), args.list)
      do.call(hist, c(list(indirects),args.list))
    }

    #Print to screen
    cat("Tests for Indirect Effects\n\n")
    cat("Dependent:   Y  = ", dv, "\n")
    cat("Independent: X  = ", iv, "\n")
    cat("Mediator:    M  = ", m, "\n")
    cat("SAMPLE SIZE: ", n, "\n")
    cat("BOOTSTRAP SAMPLES: ", nboot, "\n\n")
  
    cat("DIRECT AND TOTAL EFFECTS\n")
    print(fit.print)    

    cat("\nINDIRECT EFFECT AND SIGNIFICANCE USING NORMAL DISTRIBUTION\n")
    print(sobel.print)

    cat("\nBOOTSTRAP RESULTS FOR INDIRECT EFFECT\n")
    print(boot.print)
    
    #output
    output <- list(Fit=fit, `Sobel test` =sobel, `Bootstrap results` = boot.table, `Indirect effect`=indirects)
    invisible(output)
   }
