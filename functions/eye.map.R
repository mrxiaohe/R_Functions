eye.map <- function(image.source, data, xvar, yvar, y0top=TRUE, xlab=NULL, ylab=NULL, title=NULL, geom="polygon"){
	require(ggplot2)
	require(png)
	require(grid)
	image <- readPNG(image.source, info=TRUE)
	lim <- attr(image, "info")$dim
	if( y0top ){
		revpoint <- lim[2]/2
		data[[yvar]] <- ifelse(data[[yvar]] > revpoint, revpoint - (data[[yvar]] - revpoint), 
					ifelse( data[[yvar]] < revpoint, lim[2] - data[[yvar]], revpoint))
	}
	m <- ggplot(data, aes_string(x=xvar, y=yvar), height=lim[2], width=lim[1]) + 
		 coord_cartesian(xlim=c(0, lim[1]), ylim=c(0, lim[2])) + 
		 annotation_raster(image, xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf) 
	m <- m + stat_density2d(aes(alpha=..level..), geom = geom) +
		 theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank()) + 
		 theme(panel.background = element_rect(fill="transparent", colour="black")) +
		 xlab(xlab) + ylab(ylab) + labs(title=title)
	m

}
