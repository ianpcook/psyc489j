<script type="text/javascript"
       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/x-mathjax-config">
 MathJax.Hub.Config({
   tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
 });
</script>

Visualization
========================================================
author: Jeffrey Chrabaszcz
date: 3 January 2014
width: 1024
height: 768




Outline
========================================================

- **Graphic examples**
- Grammar of graphics
- Constructing ggplot2 graphics

========================================================

<center>![snow plot](http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2013/3/14/1363276044871/John-Snows-cholera-map-of-009.jpg)</center>

Anscombe's quartet (1973)
========================================================
left: 50%


```
1 2 3 4 
9 9 9 9 
```

```
  1   2   3   4 
7.5 7.5 7.5 7.5 
```

```
  1   2   3   4 
3.3 3.3 3.3 3.3 
```

```
1 2 3 4 
2 2 2 2 
```

```
   1    2    3    4 
0.82 0.82 0.82 0.82 
```


***

<img src="Lecture02-figure/anscombe_plot.png" title="plot of chunk anscombe_plot" alt="plot of chunk anscombe_plot" style="display: block; margin: auto;" />


Three ways to plot a relationship
========================================================

<img src="Lecture02-figure/bees.png" title="plot of chunk bees" alt="plot of chunk bees" style="display: block; margin: auto;" />


Better to keep them on the same axes
========================================================

<img src="Lecture02-figure/bees_better.png" title="plot of chunk bees_better" alt="plot of chunk bees_better" style="display: block; margin: auto;" />


Maybe transform data
========================================================

<img src="Lecture02-figure/bees_better2.png" title="plot of chunk bees_better2" alt="plot of chunk bees_better2" style="display: block; margin: auto;" />


Final destination (McCandless, 2009)
========================================================

<center>
  <img src="http://s3files.core77.com/blog/images/final_destinations.jpg" height="600px" width="800px" />
</center>

Outline break
========================================================

- Graphic examples
- **Grammar of graphics**
- Constructing ggplot2 graphics

========================================================

<img src="Lecture02-figure/gog.png" title="plot of chunk gog" alt="plot of chunk gog" style="display: block; margin: auto;" />


========================================================

<img src="Lecture02-figure/gog_2.png" title="plot of chunk gog_2" alt="plot of chunk gog_2" style="display: block; margin: auto;" />


========================================================

<img src="Lecture02-figure/gog_3.png" title="plot of chunk gog_3" alt="plot of chunk gog_3" style="display: block; margin: auto;" />


========================================================

<img src="Lecture02-figure/gog_4.png" title="plot of chunk gog_4" alt="plot of chunk gog_4" style="display: block; margin: auto;" />


========================================================

<img src="Lecture02-figure/gog_5.png" title="plot of chunk gog_5" alt="plot of chunk gog_5" style="display: block; margin: auto;" />


========================================================

<img src="Lecture02-figure/gog_6.png" title="plot of chunk gog_6" alt="plot of chunk gog_6" style="display: block; margin: auto;" />


Fully-specified plot
========================================================


```r
p <- ggplot(diamonds, aes(x = carat))
p <- p + layer(
  geom = "bar",
  geom_params = list(fill = "steelblue"),
  stat = "bin",
  stat_params = list(binwidth = .01)
)
```


<img src="Lecture02-figure/full_spec_viz.png" title="plot of chunk full_spec_viz" alt="plot of chunk full_spec_viz" style="display: block; margin: auto;" />


========================================================

<img src="Lecture02-figure/full_spec_full.png" title="plot of chunk full_spec_full" alt="plot of chunk full_spec_full" style="display: block; margin: auto;" />


Outline break
========================================================

- Graphic examples
- Grammar of graphics
- **Constructing ggplot2 graphics**

Measles plots (categorical)
========================================================





```r
p <- ggplot(a, aes(center, RT))
p + geom_boxplot(outlier.size = 0) + geom_jitter(color = "firebrick", alpha = .05) +
  theme_bw(base_size = 28) + facet_wrap(~gain) + xlab("center (digits)") + ylab("rt (ms)") + ylim(c(0,6000))
```

<img src="Lecture02-figure/measles.png" title="plot of chunk measles" alt="plot of chunk measles" style="display: block; margin: auto;" />


Recast as continuous
========================================================
left: 50%


```r
p <- ggplot(a[a$Gain == 1,], aes(Center, RT))
p <- p + geom_jitter(alpha = .05) + geom_smooth(formula = y ~ log(x), method = "lm", se = FALSE, aes(group = Subj), color = alpha("blue", .3)) + ylim(c(0, 6000)) + geom_smooth(formula = y ~ log(x), method = "lm", color = "firebrick", se = FALSE, size = 1.2) + theme_bw(base_size = 24)
```


***

<img src="Lecture02-figure/print_cont.png" title="plot of chunk print_cont" alt="plot of chunk print_cont" style="display: block; margin: auto;" />

