#Function that attempts to compute the shortest traveling distance for the Traveling sales person.
#The user specifies a dataset that contains two columns, one for the x coordinate and one for the y coordinate. 

TSP<-function(dataset, seed=150, niter=200000, nswap=2,initial=10,rate=0.00005,...){
	Sys.sleep(1.5)
 	distances<-sqrt(outer(dataset[,1], dataset[,1], FUN="-")^2 +
					outer(dataset[,2], dataset[,2], FUN="-")^2)
	rownames(distances)<-colnames(distances)<-1:nrow(dataset)
	id<-1:nrow(dataset)
	extract<-Vectorize(function(index1, index2){
		distances[index1, index2]
	})
	L<-best<-orig<-sum(extract(1:(id[length(id)]), c(2:(id[length(id)]), id[1])))
	bestRoute<-id; #storage<-numeric(niter)
	matplot(dataset[c(1:length(id), 1),1], dataset[c(1:length(id), 1),2], type="o", pch=18, col="black", xlab="X", ylab="Y")
	tempID<-id
	pbar<-txtProgressBar(min=1, max=niter, style=3)   #Set progress bar
	i<-1
	restart<-F
	if(seed) set.seed(seed)
	while(i<niter & initial > 0){
		swap<-sample(2:nrow(dataset), nswap, replace=FALSE)
		tempID<-id
		tempID[swap]<-id[swap[nswap:1]]
		tempL<-sum(extract(tempID, c(tempID[-1], tempID[1])))
		p<-min(1,exp((-tempL+L)/initial))
		if(runif(1)<p) p<-TRUE else p<-FALSE
		if(p){
			id<-tempID
			L<-tempL
			if(L<best){
				best<-tempL
				bestRoute<-tempID
				Sys.sleep(0.15)
				matplot(dataset[c(bestRoute, 1),bestRoute[1]], dataset[c(bestRoute, bestRoute[1]),2], type="o", pch=18, col="blue", xlab="X", ylab="Y")
				mtext(paste("Number of iterations left: ", niter-i), line=2, adj=0 )
				mtext(paste("Tour distance: ", round(tempL, 6)), line=1, adj=0 )

			}
		}
		initial<-initial-rate	
		if(initial < 0 & restart){
			initial<-10
			i<-0
			restart<-FALSE
		}
		if((i%%7500)==0){
			Sys.sleep(0.15)
			matplot(dataset[c(tempID, tempID[1]),1], dataset[c(tempID, tempID[1]),2], type="o", pch=18, col="blue", xlab="X", ylab="Y")
			mtext(paste("Number of iterations left: ", niter-i), line=2, adj=0 )
			mtext(paste("Tour distance: ", round(tempL, 6)), line=1, adj=0 )
		}
		#setTxtProgressBar(pbar, i)   
		i<-i+1	
		
	}
	matplot(dataset[c(bestRoute, bestRoute[1]),1], dataset[c(bestRoute, bestRoute[1]),2], type="o", pch=18, col="blue", xlab="X", ylab="Y")
			mtext(paste("Iteration: ", i), line=2, adj=0 )
			mtext(paste("Tour distance: ", round(best, 6)), line=1, adj=0 )
	intersect.fnc<-Vectorize(function(x1, x2, x3, x4, y1, y2, y3, y4){
		if(max(x1, x2) < min(x3, x4)){
			FALSE
		} else if((x1-x2)!=0 & (x3-x4)!=0){
			A1<-(y1-y2)/(x1-x2)
			A2<-(y3-y4)/(x3-x4)
			if(A1==A2){
				FALSE
			} else {
				b1<-y1-A1*x1
				b2<-y3-A2*x3
				Xa<-(b2-b1)/(A1-A2)
				if((Xa<max(min(x1,x2), min(x3, x4))) | (Xa>min(max(x1,x2), max(x3, x4))))
					FALSE
				else TRUE
			}
		} else if((x1-x2)==0 | (x3-x4)==0){
			if((x1-x2)==0 & (x3-x4)==0) {
				FALSE
			} else if((x1-x2)==0){
				A2<-(y3-y4)/(x3-x4)
				b2<-y3-A2*x3
				if((A2*x1+b2)<min(y1,y2) | (A2*x1+b2)>max(y1,y2)) FALSE
				else TRUE
			} else if((x3-x4)==0){
				A1<-(y1-y2)/(x1-x2)
				b1<-y1-A1*x1
				if((A1*x3+b1)<min(y3,y4) | (A1*x3+b1)>max(y3,y4)) FALSE
				else TRUE
			}
		}
	})
	i<-1
	check<-0
	while(i <= nrow(dataset)){ 
	
		if(i==1){ 
			tempx<-dataset[bestRoute,1]
			tempy<-dataset[bestRoute,2]
			ID<-bestRoute
		} else{
			tempx<-c(dataset[bestRoute[i:length(id)],1], 
					 dataset[bestRoute[1:(i-1)], 1])
			tempy<-c(dataset[bestRoute[i:length(id)],2], 
					dataset[bestRoute[1:(i-1)], 2])
			ID<-c(bestRoute[i:length(id)], 
				  bestRoute[1:(i-1)])
		}
		intersectTF<-intersect.fnc(tempx[1], tempx[2], 
					  			  tempx[3:(length(id)-1)], tempx[4:length(id)],
					  			  tempy[1], tempy[2], 
								  tempy[3:(length(id)-1)], tempy[4:length(id)])				
		if(sum(intersectTF)>0){
			intersectTF.id<-which(intersectTF)[1]+2
			intersectTF.id<-c(intersectTF.id, intersectTF.id+1) 
			intersectID<-ID[2:(intersectTF.id[1])]
			reverse.id<-intersectID[length(intersectID):1]
			ID[2:(intersectTF.id[1])] <- reverse.id
			if(i == 1)
				tempID<-ID
			else {
				tempID<-c(ID[(nrow(dataset)-i+2):nrow(dataset)], ID[1:(nrow(dataset)-i+1)])
			}
			tempL<-sum(extract(tempID, c(tempID[-1], tempID[1])))
			if(tempL < best){
				bestRoute<-tempID
				best<-tempL
				if(i==1){ 
					tempx<-dataset[bestRoute,1]
					tempy<-dataset[bestRoute,2]
				} else{
					tempx<-c(dataset[bestRoute[i:length(id)],1], 
							 dataset[bestRoute[1:(i-1)], 1])
					tempy<-c(dataset[bestRoute[i:length(id)],2], 
							dataset[bestRoute[1:(i-1)], 2])
				}		
			Sys.sleep(0.15)
			matplot(dataset[c(bestRoute, bestRoute[1]),1], dataset[c(bestRoute, bestRoute[1]),2], type="o", pch=18, col="blue", xlab="X", ylab="Y")
			mtext(paste("Tour distance: ", round(best, 6)), line=1, adj=0 )
			}
		} else {check<-check+1}
		i<-i+1
		if(i==51 & check < 50){
			i<-1
			check<-0
		} 
	}
	Sys.sleep(1)
	

	invisible(list(BestTour=bestRoute, Distance=best, OriginalDistance=orig))
}
