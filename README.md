R_Functions
===========

###1. `trimdata()` 

    trimdata(dataset, dv, factors = NULL, tr = 3, rm = FALSE, min.val = NULL, max.val = NULL)

This function trims numerical data based on different factors. 

* `dataset`: the name of the dataset, in the form of data frame, in which data are stored.
  
* `dv`: the name of the variable to be trimmed.
  
* `factors`: the factors on which trimming is based. For example, if a user specifies two 2-level factors, there will be a total of 4 conditions. The mean and the standard deviation of each condition will be computed to calculate trimming criteria. When `factors=NULL`, trimming is done to the entire dataset at once.
  
* `tr`: number of standard deviations used to set the trimming criteria - that is, data points that are `+/- tr*SD` away from the mean are considered outliers. By default, `3SD` is used; in other words, data points that are 3 standard deviations away from the mean of a condition (or of the entire data set if `factors=NULL`) are declared as outliers.
* `rm`: whether outliers are removed or replaced. By default, `rm=FALSE` - that is, if a data point is declared as an outlier, it will be replaced by `mean + tr*SD` or `mean - tr*SD` - dependent on whether the outlier lies outside the upper bound or lower bound. If the argument is set to TRUE, outliers will be replaced by `NA`.
* `min.val`|`max.val`: whether any extreme values are to be removed before applying the standard deviation based trimming procedure. Inflation of standard deviation can be reduced this way. By default, both arguments are set to `NULL`. Any extreme values to be removed will be replaced by `NA`.

The function will return an invisible vector of values of the same length as the original variable, which can be saved into an R object or appended to the original data frame.
  
####Example: 

    data(ChickWeight)
    (trimdata(ChickWeight, dv=weight, factors=c(Time, Diet), tr=2, rm=TRUE))
    #24 data points (4.15%) have been removed.
    #output
    # [1]  42  51  59  64  76  93 106 125 149 171 199 205  40  49  58  72  84 103 122 138 162 187 209 215  43)
    # [26]  39  55  67  84  99 115 138 163 187 198 202  42  49  56  67  74  87 102 108 136 154 160 157  41  42
    # [51]  NA  60  79 106 141 164 197 199 220 223  41  49  59  74  97 124 141 148 155 160 160 157  41  49  57
    # [76]  71  89 112 146 174 218 250  NA  NA  42  50  61  71  84  93 110 116 126 134 125  42  51  59  68  85
    #[101]  96  90  92  93 100 100  98  41  44  52  63  74  81  89  96 101 112 120 124  43  51  63  NA  NA  NA
    #[126] 168 177 182 184 181 175  41  49  56  62  72  88 119 135 162 185 195 205  41  48  53  60  65  67  71
    #[151]  70  71  81  91  96  41  49  62  79 101 128 164 192 227 248 259 266  41  49  56  64  68  68  67  68
    #[176]  41  45  49  NA  57  51  54  42  51  61  72  83  89  98 103 113 123 133 142  NA  NA  43  48  55  62
    #[201]  65  71  82  88 106 120 144 157  41  47  54  58  65  73  77  89  98 107 115 117  40  50  62  NA  NA
    #[226]  NA  NA  NA  NA 307 318 331  41  55  64  77  90  95 108 111 131 148 164 167  43  52  61  73  90 103
    #[251] 127 135 145 163 170 175  42  52  58  74  66  68  70  71  72  72  76  74  40  49  62  78 102 124 146
    #[276] 164 197 231 259 265  42  48  57  74  93 114 136 147 169 205 236 251  39  46  58  73  87 100 115 123
    #[301] 144 163 185 192  39  46  58  73  92 114 145 156 184 207 212 233  39  48  59  74  87 106 134 150 187
    #[326] 230 279 309  42  48  59  72  85  98 115 122 143 151 157 150  42  53  62  73  85 102 123 138 170 204
    #[351] 235 256  41  49  65  82 107 129 159 179 221 263 291 305  39  50  63  77  96 111 137 144 151 146 156
    #[376] 147  41  49  63  85 107 134 164 186 235 294 327 341  41  53  64  87 123  NA  NA  NA  NA 332 361 373
    #[401]  39  48  61  76  98 116 145 166 198 227 225 220  41  48  NA  68  80  83 103 112 135 157 169 178  41
    #[426]  49  61  74  98 109 128 154 192 232 280 290  42  50  61  78  89 109 130 146 170 214 250 272  41  55
    #[451]  66  79 101 120 154 182 215 262 295 321  42  51  66  85 103 124 155 153 175 184 199 204  42  49  63
    #[476]  84 103 126 160 174 204 234 269 281  42  55  69  NA  NA  NA  NA 188 197 198 199 200  42  51  65  86
    #[501] 103 118 127 138 145 146  41  50  61  78  98 117 135 141 147 174 197 196  40  52  62  82 101 120 144
    #[526] 156 173 210 231 238  41  53  66  79 100 123 148 157 168 185 210 205  39  50  62  80 104 125 154 170
    #[551] 222 261 303 322  40  53  64  85 108 128 152 166 184 203 233 237  41  54  67  84 105 122 155 175 205
    #[576] 234 264 264



###2. `tsplot()`

    tsplot(dv, ts, factors=NULL, dataset, errbar=TRUE, whisker=.015, cex.pch=1, pch.col=NULL, conf.level=.95, 
           args.errbar=NULL, xlab=NULL, ylab=NULL, cex.lab=NULL, main=NULL, cex.main=NULL,text=NULL, cex.axis=NULL, 
           type="b", lty=1, col="black",pch=20, legend=TRUE, args.legend=NULL, axes=TRUE, ylim, bg.col=NULL, 
           grid.col=NULL, args.grid=NULL, mar=NULL, box.col=NULL, box.lwd=0.8, xaxp=NULL, args.xlab=NULL, 
           args.ylab=NULL, args.xaxis=NULL, args.yaxis=NULL,...)

This function can be used to plot a variety of data. It was originally intended to plot time series data. The x-axis represents different time points, and the y-axis represents the outcome variables. One convenient feature of the function is that it averages the outcome variable across different conditions and across time. In addition, it can plot error bars if needed.

* `dv`: the outcome variable to be plotted.
* `ts`: the time variable; can be other types of variables, such as a categorical variable with multiple levels.
* `factors`: grouping factors; e.g., if a user specifies a 3-level variable for `factors`, then the resulting plot will have 3 separate lines. When `factors=NULL`, one line will be plotted.
* `dataset`: the dataset, in data frame format, in which data are stored.
* `errbar`: whether error bars are plot. Error bars can be plotted only if there are multiple observations per `factors * ts` combination. It can be further customized by setting the argument `args.errbar`.
* `whisker`: the width of errbar whiskers.
* `cex.pch`: point size.
* `pch.col`: fill color of points.
* `conf.level`: confidence level for the error bars.
* `xlab`|`ylab`: x- and y- axis labels.
* `cex.lab`: label size.
* `main`: main title.
* `cex.main`: main title size.
* `text`: annotations for the x-axis.
* `cex.axis`: size of annotations (for both x-axis and y-axis)
* `type`: plot type.
* `lty`: line type.
* `col`: line/point outline color.
* `pch`: point type.
* `legend`: whether a legend is plotted. It can be customized by setting `args.legend`.
* `axes`: whether the x- and y- axes are plotted.
* `ylim`: y limits.
* `bg.col`: background color of the plot area.
* `grid.col`: color of horizontal grid. It can be customized by setting `args.grid`.
* `mar`: plot margins.
* `box.col`: color of plot border.
* `box.lwd`: width of plot border.
* `xaxp`: a vector of the form `c(x1, x2, n)` giving the coordinates of the extreme tick marks and the number of intervals between tick-marks.
* `args.xlab`|`args.ylab`|`args.xaxis`|`args.yaxis`: additional arguments for x- and y- axis labels and x- and y- axes.
* `...`: additional arguments.

####Example 1:

In this example, we will use the `ChickWeight` dataset. We will plot the effect of diet type on chick weights across time. Each diet type will have its own line. The x-axis represents time, and the y-axis represents weight (in grams)

    data(ChickWeight)
    head(ChickWeight)
    #Grouped Data: weight ~ Time | Chick
    #  weight Time Chick Diet
    #1     42    0     1    1
    #2     51    2     1    1
    #3     59    4     1    1
    #4     64    6     1    1
    #5     76    8     1    1
    #6     93   10     1    1
    #...

    tsplot(weight, Time, Diet, ChickWeight,
           errbar=FALSE,
           text=paste("T", 1:12, sep=""),
           col=2:5,
           args.legend=list(x="bottomright", legend=paste("Diet", 1:4), bty="n"),
           ylab="Weight (g)",
           main="Effect of Diet Type on Chick Weight across Time"
    )
![plot](http://imageshack.us/a/img94/9724/rplot2.png)


####Example 2:

We will reuse the `ChickWeight` dataset. In this example, let's plot the mean `weight` across different time points ignoring the factor `Diet`.

    tsplot(dv=weight, ts=Time, factors=NULL, dataset=ChickWeight,
            errbar=TRUE,   #we will plot error bars
            args.errbar=list(lwd=0.7),
            whisker=0.008,
            text=paste("T", 1:12, sep=""),
            col=2, 
            pch=23, 
            pch.col="blue", 
            cex.pch=0.7,
            legend=FALSE,
            ylab="Weight (g)",
            main="Chick Weight across Time"
    )

![plot](http://img812.imageshack.us/img812/9443/screenshot20130602at908.png)


###3. `bar()`

This is a function wrapper for `barplot()` and includes some added features that may be convenient for many people.

    bar(dv, factors, dataframe, percentage=FALSE, errbar=!percentage, half.errbar=TRUE, conf.level=0.95, 
        xlab=NULL, ylab=NULL, main=NULL, names.arg=NULL, bar.col="black", whisker=0.015, args.errbar=NULL, 
        legend=TRUE, legend.text=NULL, args.legend=NULL, legend.border=FALSE, box=TRUE, args.yaxis=NULL, 
        mar=c(5, 4, 3, 2), ...) 

* `dv`: numerical values to be plotted.
* `factors`: grouping factors; a maximum of two factors can be specified.
* `dataframe`: a data frame object in which data are stored.
* `percentage`: whether the plot will be on the percentage scale. This option works only if the `dv` contains 0's and 1's.
* `errbar`: whether error bars are plotted. Error bars are NOT plotted when `percentage=TRUE`.
* `half.errbar`: whether half error bars or full error bars are plotted. 
* `conf.level`: confidence level used for constructing error bars.
* `legend`: whether a legend is plotted.
* `legend.text`: a string vector containing texts for the legend.
* `args.legend`: further customization for the legend.
* `legend.border`: whether or not the border of the legend is plotted.
* `box`: whether the plot has a border.
* `args.xaxis`: additional customization for the y-axis.
* `mar`: margin widths.
* `...`: additional optional arguments.

####Example:

We will use the dataset `WeightLoss` from the package `car` for this example. First, we will transform the dataset from the wide form to the long form using `melt()` from the `reshape` package.

    #install.packages("reshape")    #install `reshape` if you don't have it.
    library(reshape)
    data(WeightLoss)
    WL<-melt(WeightLoss[,1:4], id.vars="group", variable_name="week")
    head(WL)
        group week value
    1 Control  wl1     4
    2 Control  wl1     4
    3 Control  wl1     4
    4 Control  wl1     3
    5 Control  wl1     5
    6 Control  wl1     6
    ...

The first column of `WL` contains group information: Control group, Diet only group, and Diet + Exercise group. The second column contains time information - `wl1`, `wl2`, and `wl3` are for Month 1, Month 2, and Month 3, respectively. The third column contains weight loss in lbs.

    bar(value, c(week, group), WL,
        main="Weight Loss across Time in 3 Experimental Groups", 
        xlab="Experimental group", 
        ylab="Weight loss (lbs)",
        legend.text=c("Week 1", "Week 2", "Week 3"), 
        args.legend=list(x="topleft"), 
        names.arg=c("Control", "Diet only", "Diet + exercise"), 
        col=gray(c(0.1,0.5,0.9))
    )

![plot](http://img17.imageshack.us/img17/5827/screenshot20130602at439.png)



###4. `indirect()` 

This function tests indirect effects by using the percentile bootstrap method and the Sobel's method (based on Andrew Hayes' SPSS macro). A histogram of indirect effects computed from bootstrap samples will be created by default.

    indirect(iv, m, dv, data, nboot=5000, alpha=0.05, stand=TRUE, seed=1)
    
####Example:

We will create a mock dataset:

    set.seed(1)
    mock <- data.frame(iv = sort(rnorm(20)),
                       m  = sort(rlnorm(20)),
                       dv = sort(rlnorm(20), TRUE)
                       )
    indirect("iv", "m", "dv", mock, nboot=5000, cex.main=0.9)
     
    #OUTPUT 
    #Tests for Indirect Effects

    #Dependent:   Y  =  dv 
    #Independent: X  =  iv 
    #Mediator:    M  =  m 
    #SAMPLE SIZE:  20 
    #BOOTSTRAP SAMPLES:  5000 

    #DIRECT AND TOTAL EFFECTS
    #         Estimate Std. Error t value   Pr(>|t|)
    #b(Y~X)   -1.60368    0.17690 -9.0656 3.9527e-08
    #b(M~X)    0.94814    0.12315  7.6992 4.2118e-07
    #b(Y~M.X) -2.52693    0.27728 -9.1133 5.9302e-08
    #b(Y~X.M)  0.97374    0.25613  3.8018  0.0014254

    #INDIRECT EFFECT AND SIGNIFICANCE USING NORMAL DISTRIBUTION
    #           Value Std. Error      z    cilo   cihi Pr(>|z|)
    #Sobel:   0.92325     0.4088 2.2584 0.12201 1.7245  0.02392

    #BOOTSTRAP RESULTS FOR INDIRECT EFFECT
    #         Estimate Std. Error     cilo   cihi       p
    #Effect:    0.7558    0.32578 0.013211 1.2368 0.04520
    
![plot](http://img829.imageshack.us/img829/2264/mt9.png)
    
    
This function has an option of calling a C++ code to run the bootstrap portion of the function. To do so, follow the steps below:
    
(1) Download the shared object `indirectboot.so` (only works for 64-bit R on Mac OS. A Windows version will be uploaded soon.)
(2) Install the R package `RcppArmadillo`.
(3) Use `dyn.load()` to load the downloaded object.
(4) When running `indirect()`, add the `cpp=TRUE`. This argument is set to `FALSE` by default.

Calling the C++ code offers a substantial increase in speed (see benchmark results below) and allows for running more bootstrap samples.

                                                                            test replications
    2 indirect("iv", "m", "dv", mock, nboot = 50000, cex.main = 0.7, cpp = TRUE)            1
    1 indirect("iv", "m", "dv", mock, nboot = 50000, cex.main = 0.7)                        1
      elapsed relative user.self sys.self user.child sys.child
    2   0.417     1.00     0.401    0.009          0         0
    1   9.199    22.06     9.089    0.111          0         0

When `cpp=TRUE`, running 50000 bootstrap samples took only 0.42 seconds. The R native implementation (`cpp=FALSE`) took 9 seconds.




###5. `cinterplot()` 

This function plots continuous interactions for linear models with two continuous predictors. The relationship of dv and iv1 is evaluated at different values of iv2. This is adapted from Nick Jackson's [STATA program] (https://github.com/nicholasjjackson/StataAddons)

    cinterplot (data.frame, dv, iv1, iv2, iv2.values = NULL, iv2.quantiles = c(0.25, 
                0.5, 0.75), lty = NULL, xlab = NULL, ylab = NULL, col.line = "black", 
                col.pch = "black", ...) 
    
####Example
    
    #We will use the dataset `hsbdemo`.
    
    #install.packages("foreign")     #install the package `foreign` in order to import STATA datasets
    require("foreign")
    hsbdemo <- read.dta("http://www.ats.ucla.edu/stat/data/hsbdemo.dta")
    
    head(hsbdemo)    
    #   id female    ses schtyp     prog read write math science socst       honors awards cid
    #1  45 female    low public vocation   34    35   41      29    26 not enrolled      0   1
    #2 108   male middle public  general   34    33   41      36    36 not enrolled      0   1
    #3  15   male   high public vocation   39    39   44      26    42 not enrolled      0   1
    #4  67   male    low public vocation   37    37   42      33    32 not enrolled      0   1
    #5 153   male middle public vocation   39    31   40      39    51 not enrolled      0   1
    #6  51 female   high public  general   42    36   42      31    39 not enrolled      0   1

    #We will visualize the interaction between `math` and `socst` with `read` being the outcome variable.
    #Specifically, the relationship between `read` and `math` will be evaluated at different values of
    #`socst`.
    
    cinterplot(data.frame = m1, 
               dv = "read", 
               iv1 = "math", 
               iv2 = "socst", 
               iv2.value = seq(30, 75, 10), 
               pch="+", 
               col.line="red")
    
![plot](http://img16.imageshack.us/img16/6011/8up.png)


