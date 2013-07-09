
tree <- function(SampleSize, print=TRUE, seed=1){
  nodes<-1:SampleSize                      #Create a vector to store the most recent descendents 	
	if(seed) set.seed(seed)                  #set seed for replication
	time<-mapply(rexp,  n=1, rate=(SampleSize-(1:(SampleSize-1))+1)*(SampleSize-(1:(SampleSize-1)))/2)
	descendents<-numeric((length(1:(2*SampleSize-1))-SampleSize)*2)
	#------------------------ loop for coalescence ------------------------------------------------
    #The number of times the loop runs is equal to sample size - 1
	for(i in 0:(SampleSize-2)){
		pairs<-rep(nodes, each=2)[-c(1, 2*length(nodes))]
		descendents[(2*i+1):(2*i+2)]<-pairs[rep(1:(length(nodes)-1), each=2)==sample(rep(1:(length(nodes)-1), each=2),1)]
		nodes<-c(nodes[(1:length(nodes))<(which(nodes==descendents[2*i+1]))],
				 max(nodes)+1, 
				 nodes[(1:length(nodes))>(which(nodes==descendents[2*i+2]))])
	}
	#------------------------ end of loop for coalescence -----------------------------------------
	output<-cbind(Node=1:length(1:(2*SampleSize-1)),                                         #When the coalescence process is completed, the output
	           LeftDescendent=c(rep(0, SampleSize), descendents[2*(1:(SampleSize-1)-1)+1]),  #will be saved in a data frame, containing node indices
	           RightDescendent=c(rep(0, SampleSize), descendents[2*(1:(SampleSize-1)-1)+2]), #Each node's left and right descendents, coalescence
	           Time=c(rep(0, SampleSize), time),                        #time for each node if applicable, 
	           Cumtime=c(rep(0, SampleSize), cumsum(time)))             #and cumulative time.
	totalTime <- sum(output[,"Time"])                                   #Compute the tree height.
	totalCumTime<-sum(output[,"Cumtime"])*2                             #Compute the sum of branch lengths.
	externalTime<-output[,"Cumtime"]*(output[,2:3]%in%1:SampleSize)     #Compute external length: if a node has one external branch
                                                                        #the length for this branch is the coalescence time for
	                                                                    #this node; if a node has two external brahnches, the length
	                                                                    #of the external branches will be the coalescence time for
	                                                                    #this node times 2.
	#------------------ Determine the number of left and right descendents ------------------------	                                                                    
	#Left descendents are determined by (i) first checking the left descendent immediately below mt-Eve; (ii) then looking for
	#right descendents below this descedent. Once a right descendent is determined to be one of the most recent descendents,
	#the checking process stops. This right descendent, and anything to its left are left descendents. Every descendent to its
	#right is a right descendent.
	#Take the tree below for example: I first determine the left descendent right below mt-Eve - i.e., 8, and then I look for
	#the right descendent of 8, which is 4. 4 turns out to be one of the most recent descendents (i.e., 1, 2, 3, 4, and 5), so
	#I stop the checking process. So 4 and every node to its left are left descendents - i.e., 1, 2, 3, and 4; and 5, which is
	#is a right descendent
	# 
	#           mt-Eve
	#            / \
	#           8   \
	#          / \   \
	#         7   \   \
	#        / \   \   \
	#       /   6   \   \
	#      /   / \   \   \
	#     1   2   3   4   5
	#	
	Nodes<-output[,1]                                 #Store all the nodes in a new vector
	rightDescendents<-output[,3]                      #Store all the right descendents in a new vector 
	descendent<-output[SampleSize+SampleSize-1,2]     #Store the left descendent immediately below mt-Eve.
	
	found<-FALSE                                      #Boolean; whether a right descendent belonging to the most recent descendents 
	                                                  #is found; initalized to be FALSE
	if(sum(descendent==1:SampleSize)==1) found<-TRUE  #If the left descendent immediately below mt-Eve is a most recent descendent,
	                                                  #found is set to TRUE
	while(!found){                                    #While-loop to find left descendents
		node.index<-which(Nodes==descendent)          #Extract the node index of a descendent
		descendent<-rightDescendents[node.index]      #Check the right descendent of this descendent
		if(sum(descendent==1:SampleSize)==1) break	  #If this right descendent is one of the most recent descendent, terminate the 
	}                                                 #while-loop

	LeftDescendents<-Nodes[1:descendent]              #Store all the left descendents in a vector
	RightDescendents<-Nodes[(descendent+1):SampleSize]#Store all the right descendents in a vector
	numLeftDescendents<-length(LeftDescendents)       #Calculate the total number of left descendents
	numRightDescendents<-length(RightDescendents)     #Calculate the total number of right descendents
	#--------------- End of determining the number of left and right descendents ------------------	                                                                    
	
	#------------------------------------ Print results -------------------------------------------	                                                                    
	if(print){                                        #If-statement; print results only if print=TRUE
		cat("\n\t\t           Descendant\n")                                #Header of the result table
		cat("\t\t Node", "    Left", "    Right", "      Time\n", sep="")   #Header of the result table
		cat("\t\t ", rep("-", 31), sep="", "\n")                            #Divider between results and the header
		for(i in 1:dim(output)[1]){                   #For-loop to print results
			cat("\t\t", formatC(output[i,1], width=4),#Print the node indices 
				formatC(output[i,2], width=7),        #Print the left descendent
				formatC(output[i,3], width=8), 	      #Print the right descendent
				if(output[i,4]==0) formatC("       0", width=9) #print the time of coalescence
				else formatC(output[i,4], width=9, digits=6, format="f", zero.print=F), 
    		   "\n")
		}
		cat("\t\t ", rep("-", 31), sep="", "\n")                                           #Divider
		cat(formatC("Total time:", width=31),                                              #Print total time of coalescence
		    formatC(round(totalTime, 6), width=8, format="f", zero.print=F),"\n")
        cat(formatC("Sum of external branches:", width=31), 							   #print sum of external branch lengths
            formatC(round(sum(externalTime), 6), width=8, format="f", zero.print=F),"\n")
		cat(formatC("# of left descendants:", width=31),  		   		   		   		   #print the number of left descendents
		    formatC(numLeftDescendents, width=9, format="d", zero.print=F), sep="","\n")
		cat(formatC("# of right descendants:", width=31),    		   		   		   	   #print the number of right descendents
		    formatC(numRightDescendents, width=9, format="d", zero.print=F), sep="","\n")	
    }
	invisible(list(totalTime=totalTime,                   #output a list of results in invisible mode.
	 			   totalExternalTime=sum(externalTime), 
	 			   output=output,
	 			   LeftDescendents=LeftDescendents,
	 			   RightDescendents=RightDescendents,
	 			   numLeftDescendents=numLeftDescendents,
	 			   numRightDescendents=numRightDescendents,
	 			   totalCumTime=totalCumTime))
}


tree.plot<-function(SampleSize, seed=1){
	temp<-tree(SampleSize, seed=seed)                  #Calls the function tree()
	numLeftDescendents<-temp$numLeftDescendents        #Extract the number of left descendents
	numRightDescendents<-temp$numRightDescendents      #Extract the number of right descendents
	output<-as.data.frame(temp[[3]])                   #Extract the result table
	xlimits <-c(1,SampleSize)                          #Specify x limits
	par(mar=c(3,4.5,3,2), xpd=TRUE)                    #Specify margin widths
	#Open a blank plot with the pre-specified margins and x limits
	plot(1,type="n", axes=F, xlim=xlimits, ylim=c(0, tail(output$Cumtime,1)), xlab=" ", ylab="Time",
		 main=paste("Number of Most Recent Offsprings =", SampleSize), xpd=TRUE, cex.lab=1.1) 
	
	axis(2, las=1, cex.axis=0.9,lwd=0.8)               #Draw a y axis
	#Specify the colors of most recent descendents on the plot. Left descendents are blue, right descendents green.
	colorOfDescendents<-c(rep("blue", numLeftDescendents), 
	                      rep("darkgreen", numRightDescendents))
	#Plot the most recent descendents with the custom color scheme.
	mapply(text, x=1:SampleSize, y=0, 
	       labels=paste(1:SampleSize), 
	       adj=0.5, cex=0.7, 
	       col=colorOfDescendents, 
	       font=2)
	
	next.x<-c(1:SampleSize, rep(NA, SampleSize-1))     #a vector used to store the x-coordinates of mother nodes in
	for(i in 1:(SampleSize-1)){                        #the for-loop below.
		#Calculate the x-coordinate of a mother node: (x-coord of left descendent + x-coord of right descendent)/2
		next.x[SampleSize+i]<-(next.x[which(output$Node==output[SampleSize+i,2])]+
				   			   next.x[which(output$Node==output[SampleSize+i,3])])/2
		next.y<-output[SampleSize+i, "Cumtime"]                               #Extract the y-coordinates of mother 
		left.x<-next.x[which(output$Node==output[SampleSize+i,2])]            #save the left descendent's x-coord
		left.y<-output[which(output$Node==output[SampleSize+i,2]),"Cumtime"]  #save the left descendent's y-coord
		if(sum(output[SampleSize+i,2]==1:SampleSize)>0)                       #Determine the color of branch: 
			col="red" else col="black"                                        #external branch: red; otherwise, black
		
		lines(x=c(left.x, next.x[SampleSize+i]), y=c(left.y,next.y),          #Plot the left branch
			  type="b", pch=c(" ", " "), lwd=0.5, col=col)
		
		if(i==(SampleSize-1)) {                                #Set node color, alignment, and label. The top node
			label<-paste(SampleSize+i, "\n(mt-Eve)")           #will get a numeric label and "mt-Eve". Other nodes
			font<-2                                            #only get numeric labels.
			adj<-c(0.5, 0)
		} else {
			label<-SampleSize+i
			font<-1
			adj<-c(0.5,0.5)
		}
		
		#plot node labels
		text(x=next.x[SampleSize+i], y=next.y, 
		     labels=label, adj=adj, cex=0.7, font=font)
		right.x<-next.x[which(output$Node==output[SampleSize+i,3])]           #save the right descendent's x-coord
		right.y<-output[which(output$Node==output[SampleSize+i,3]),"Cumtime"] #save the right descendent's x-coord
		if(sum(output[SampleSize+i,3]==1:SampleSize)>0)        #Determine the color of branch: 
			col="red" else col="black"                         #external branch: red; otherwise, black.
		lines(x=c(right.x, next.x[SampleSize+i]), y=c(right.y,next.y),        #Plot the left branch
 			  type="b", pch=c(" ", " "), lwd=0.7, col=col)
	}
	#This section will plot shaded areas for left descendents and right descendents. Left descendents will be in a
	#blue shaded rectangular area, whereas right descendents will be in a green shaded rectangular area.
	usr<-par()$usr                           #Determine the plot area coordinates. 
	left.x1<-(1+usr[1])/2                    #lower x-limit of the left shaded area
	left.x2<-max(temp$LeftDescendents)+0.2   #upper x-limit of the left shaded area
	
	right.x2<-usr[2]                         #lower x-limit of the right shaded area
	right.x1<-min(temp$RightDescendents)-0.2 #upper x-limit of the right shaded area
	
	y1<-usr[3]                               #lower y limit
	y2<-grconvertY(0, from="user", to="nfc") #upper y limit
	
	rect(right.x1, y1, right.x2, -y1, border=hcl(h=130, alpha=0.6), col=hcl(h=130, alpha=0.3))  #Left shaded area
	rect(left.x1, y1, left.x2, -y1, border=hcl(h=270, alpha=0.6), col=hcl(h=270, alpha=0.3))    #Right shaded area
	
	#Plot a label for the right descendents
	at<-ifelse(length(temp$RightDescendents)==1, max(temp$RightDescendents), (min(temp$RightDescendents)+max(temp$RightDescendents))/2)
	axis(1, at=at, lty=NULL, tick=FALSE, labels="Right\nDescendants",col.axis="darkgreen", cex.axis=0.8)

    #Plot a label for the right descendents
	at<-ifelse(length(temp$LeftDescendents)==1, min(temp$LeftDescendents), (min(temp$LeftDescendents)+max(temp$LeftDescendents))/2)
	axis(1, at=at, lty=NULL, tick=FALSE, labels="Left\nDescendants", col.axis="blue", cex.axis=0.8)

    #legend, noting that the red branches are external branches
	legend("topright", "External branch", lty=1, col="red", bty="n", cex=0.7)
	
}
