
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
