---
title       : Developing Data Products
subtitle    : Sports Activity Prediction
author      : Leehbi
job         : Data Analyst
framework   : io2012   # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---


## Introduction

### This shiny app takes raw data to predict which activity is being performed by 20 different athletes
### The app cleans the data and performs cross validation of a random forest model to make the prediction
### 
### On the Input tab you'll find settings for parameters to tune the model
![width]("UM.png")


--- .class #id 

## Querying Yelp


```r
y <- yelp.data(category=category, city=city,radius=radius)
y$df
```

```
##        business.names               X1                X2
## 1  Telfords Warehouse        53.193241         -2.898771
## 2    Old Harkers Arms        53.193418         -2.881248
## 3          Albion Inn       53.1884117          -2.88802
## 4       Bear & Billet        53.186744         -2.890165
## 5       Fiesta Havana       53.1898956        -2.8932841
## 6        The Botanist       53.1912196        -2.8902453
## 7    Ye Olde Boot Inn 53.1905138631287 -2.89043889005541
## 8           Barlounge        53.189836         -2.893896
## 9      Kash Tap Rooms        53.196791         -2.883382
## 10    The Brewery Tap        53.186744         -2.890165
```

--- .class #id

## Predicting the optimal route


```r
source('~/Slides/Slides/functions.R')
x <- distance.matrix(y$LatLong)
```

```
## Error in nrow(y$df): object 'y' not found
```

```r
w.route<-tsp.route(x,y$Names)
```

```
## Error in matrix(places, nrow = items, ncol = items, dimnames = list(names, : object 'x' not found
```

```r
w.route
```

```
## Error in eval(expr, envir, enclos): object 'w.route' not found
```

--- .class #id

## Conclusion

The full code book for this model can be found [here](http://rpubs.com/leehbi/tour)

The Shiny App can be found [here](http://leehbi.shinyapps.io/UltimateTour/)

GitHub Repo is [here](https://github.com/leehbi/developingdataproducts)

Thank you.

