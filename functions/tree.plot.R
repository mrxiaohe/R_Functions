#plot coalescent tree. thre function tree() must be loaded

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
