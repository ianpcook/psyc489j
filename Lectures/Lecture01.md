<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

R Programming Basics
========================================================
author: Jeffrey Chrabaszcz
date: 2 January 2014
transition: none
width: 1024
height: 768




Outline
========================================================

1. Why use R?
2. RStudio
3. Data structures
4. Indexing
5. Functions
6. Data interrogation
7. Loops (or not)
8. Custom functions
9. Writing/reading data
10. Plots

Why use R?
========================================================
type: prompt

*"Excel hides your calculations and shows you the result. R does the opposite."*

Why use R?
========================================================

- You can do *anything*
- Free and Open Source
- DRY
- Graphics
- Principle of equivalent difficulty
- User community

RStudio
========================================================

- **I**ntegrated **D**evelopment **E**nvironment for R
- looks like the MATLAB interface
- keeps a lot of information on-screen, avoiding some typing
- saves your graphs!

Console
========================================================

The console is like a sandbox - it's where you can interact with R directly and a good place to troubleshoot code.
Nothing that you write here is saved, though, so you should do most of your coding in the editor and run it from there.

Console commands
========================================================

**dir** tells you what files are in your current directory.


```r
dir("~")
```

```
 [1] "Applications" "Desktop"      "Documents"    "Downloads"   
 [5] "Dropbox"      "figure"       "gemmR"        "Google Drive"
 [9] "Library"      "Movies"       "Music"        "Pictures"    
[13] "Public"       "R-dev"        "stan"         "test-figure" 
[17] "texmf"       
```


Console commands
========================================================

**getwd** tells you your current working directory.
If you're using RStudio, this is the file path to the right of the console label.


```r

getwd()
```

```
[1] "/Users/jchrszcz/Dropbox/Statistics"
```


Console commands
========================================================

**setwd** will changes the working directory.
This can make it easier to work with a bunch of files in a given location.
Windows users must switch backslashes to forward slashes


```r
current.wd <- getwd()
setwd(current.wd)
getwd()
```

```
[1] "/Users/jchrszcz/Dropbox/Statistics"
```


Console commands
========================================================

**ls** tells you the variables currently in the R workspace.


```r
ls()
```

```
[1] "current.wd"
```


Packaging
========================================================

**R** uses a variety of add-on functions found in *packages*.
These differ from R scripts in that they're relatively immutable.
Installed packages must be separately updated to change the functions in them.

**install.packages** is self-explanatory.
You only need to install packages once, even though you'll have to load them for each session of R.


```r
install.packages("ggplot2")
```


**library** will load installed packages.
This must be done for each R session.


```r
library(ggplot2)
```


Data structures
========================================================

- vector
- matrix
- data.frame

Vector
========================================================


```r
my.vector <- c(1, 2, 2, 3, 3, 3, 4, 4, 5)
my.vector
```

```
[1] 1 2 2 3 3 3 4 4 5
```

```r

mixed.vec <- c(1, 2, "apple", "banana", 6)
mixed.vec
```

```
[1] "1"      "2"      "apple"  "banana" "6"     
```


An aside for modes
========================================================

- numeric
- character
- logical
- **factor**

Matrix
========================================================

Matrices are 2-dimensional, they have rows and columns, and all elements of a matrix must be of the same type, (numbers or strings, for example). Matrices are created with the **matrix** function. The first argument is the set of entries for the matrix. Two possible arguments are *nrow* and *ncol*, which specify the number of rows or columns.


```r
my.matrix <- matrix(c(1:9), ncol = 3)
my.matrix
```

```
     [,1] [,2] [,3]
[1,]    1    4    7
[2,]    2    5    8
[3,]    3    6    9
```


Data Frame
========================================================


```r
bacon <- rep(c(0,1), times = 2, each = 2)
pancakes <- rep(c("blueberry","chocolate chip"), each = 4)
breakfast <- data.frame(bacon, pancakes, quality = 1:8)
breakfast
```

```
  bacon       pancakes quality
1     0      blueberry       1
2     0      blueberry       2
3     1      blueberry       3
4     1      blueberry       4
5     0 chocolate chip       5
6     0 chocolate chip       6
7     1 chocolate chip       7
8     1 chocolate chip       8
```


Indexing
========================================================

- square braces, []
- dollar sign, $
- at symbol, @
  - we won't really use @ very much, if at all

vectors
========================================================


```r
my.vector[4]
```

```
[1] 3
```



```r
my.vector[1:4]
```

```
[1] 1 2 2 3
```


matrices
========================================================


```r
my.matrix[2]
```

```
[1] 2
```



```r
my.matrix[2,2]
```

```
[1] 5
```


more matrices
========================================================


```r
my.matrix[,2]
```

```
[1] 4 5 6
```


data.frames
========================================================


```r
breakfast$bacon
```

```
[1] 0 0 1 1 0 0 1 1
```



```r
breakfast$bacon[1]
```

```
[1] 0
```


data.frames
========================================================


```r
breakfast[1]
```

```
  bacon
1     0
2     0
3     1
4     1
5     0
6     0
7     1
8     1
```



```r
breakfast[,1]
```

```
[1] 0 0 1 1 0 0 1 1
```


data.frames
========================================================


```r
breakfast[-2]
```

```
  bacon quality
1     0       1
2     0       2
3     1       3
4     1       4
5     0       5
6     0       6
7     1       7
8     1       8
```



```r
breakfast[2,3]
```

```
[1] 2
```


Functions
========================================================

take some input, produce an output


```r
1 + 2
```

```
[1] 3
```

```r
3 + 4 * 2
```

```
[1] 11
```

```r
1:5
```

```
[1] 1 2 3 4 5
```


two kinds of functions
========================================================

- positions are all the same
- positions correspond to named arguments

first kind 
========================================================


```r
sum(1, 2, 3)
```

```
[1] 6
```

```r
c(1,2,3,4,5)
```

```
[1] 1 2 3 4 5
```


second (more common) kind
========================================================


```r
a <- 1:5
mean(a)
```

```
[1] 3
```

```r
mean(1,2,3,4,5)
```

```
[1] 1
```



Data interrogation
========================================================

- many ways to *see* data
- usually you don't want all of it at once
- sometimes you want some kind of summary or description


discovering structure
========================================================


```r
mode(breakfast)
```

```
[1] "list"
```

```r
class(breakfast)
```

```
[1] "data.frame"
```


discovering structure
========================================================


```r
str(breakfast)
```

```
'data.frame':	8 obs. of  3 variables:
 $ bacon   : num  0 0 1 1 0 0 1 1
 $ pancakes: Factor w/ 2 levels "blueberry","chocolate chip": 1 1 1 1 2 2 2 2
 $ quality : int  1 2 3 4 5 6 7 8
```


discovering structure
========================================================


```r
summary(breakfast)
```

```
     bacon               pancakes    quality    
 Min.   :0.0   blueberry     :4   Min.   :1.00  
 1st Qu.:0.0   chocolate chip:4   1st Qu.:2.75  
 Median :0.5                      Median :4.50  
 Mean   :0.5                      Mean   :4.50  
 3rd Qu.:1.0                      3rd Qu.:6.25  
 Max.   :1.0                      Max.   :8.00  
```


seeing raw data
========================================================


```r
head(breakfast)
```

```
  bacon       pancakes quality
1     0      blueberry       1
2     0      blueberry       2
3     1      blueberry       3
4     1      blueberry       4
5     0 chocolate chip       5
6     0 chocolate chip       6
```


**tail(breakfast)** also works, with predictable results

Loops (or not)
========================================================

Loops are the reason that programming is powerful. Any time you need to perform the same calculation a number of times, loops make your life easier.

R has a lot of implicit loops, for example:


```r
a <- 1:10
a
```

```
 [1]  1  2  3  4  5  6  7  8  9 10
```

```r
a ^ 2
```

```
 [1]   1   4   9  16  25  36  49  64  81 100
```


Components of a for loop
========================================================

1. Define output
2. Count variable
3. Range of values
4. Action to be performed

```
for (COUNT VARIBLE in RANGE OF VALUES) {
  ACTION TO BE PERFORMED
}
```

Define an output
========================================================

We need some variable to write to. In most cases, you can just say:


```r
output <- c()
```


Count variable
========================================================

When you specify a loop, you need an iterator. Sometimes you'll use this as an index or an input, other times it's just there, (like defining a default argument).

```
for (i in RANGE OF VALUES) {
  ACTION TO BE PERFORMED
}
```

Range of values
========================================================

Now we need to specify what values i is going to take on. In this example, we want to multiply each value of a by itself, (in effect, squaring it). That means our COUNT VARIABLE should take on a range of values from 1 to the number of values in a, or 1:10

```
for (i in 1:10) {
  ACTION TO BE PERFORMED
}
```

Action to be performed
========================================================

You'll usually see me write it like this:


```r
for (i in 1:10) {
  output[i] <- a[i] * a[i]
}
output
```

```
 [1]   1   4   9  16  25  36  49  64  81 100
```

```r
(1:10)^2
```

```
 [1]   1   4   9  16  25  36  49  64  81 100
```


Custom functions
========================================================

We could pretty easily build a function to calculate standard deviation.
Recall the formula for standard deviation:

$$
\sigma = \sqrt{\frac{1}{N-1}\sum{(X_i - \bar{X})^2}}
$$


```r
set.seed(42)
sample.data <- rnorm(100)
sd(sample.data)
```

```
[1] 1.04
```


Defining a function
========================================================


```r
my.sd <- function(sample.data) {
  N <- length(sample.data)
  sample.mean <- 0
  for (i in 1:N) {
    sample.mean <- sample.mean + sample.data[i]/N
  }
  sq.res <- 0
  for (i in 1:N) {
    sq.res <- sq.res + (sample.data[i] - sample.mean)^2
  }
  variance <- sq.res/(N-1)
  return(sqrt(variance))
}
```


This should produce the same output as sd
========================================================


```r
my.sd(sample.data)
```

```
[1] 1.04
```

```r
sd(sample.data)
```

```
[1] 1.04
```



Writing data
========================================================

Saving in *.csv*


```r
write.csv(breakfast, file = "sample_data.csv")
```


Saving in *.RData*


```r
save(list = "breakfast", file = "sample_data.RData")
```


Reading data
========================================================


```r
read.breakfast <- read.csv("sample_data.csv")

load("sample_data.RData")
```


I won't demonstrate them here, but it's worth noting that both .xls files (Excel) and .sav files (SPSS) can easily be read into R.
`read.spss` is in the **foreign** package, and `read.xls` is from **gdata**.

Plots
========================================================


```r
x <- rnorm(100)
y <- x + rnorm(100)
qplot(x, y, geom = c("point", "smooth"))
```

<img src="Lecture01-figure/unnamed-chunk-37.png" title="plot of chunk unnamed-chunk-37" alt="plot of chunk unnamed-chunk-37" style="display: block; margin: auto;" />

