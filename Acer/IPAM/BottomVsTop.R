getwd()

# Get all libraries and sources required to run the script


library(ggplot2)

# Import your data: 
Acer.growth<-read.csv("Data/Growth/GrowthLong2017-05-26.csv")

# DIFFERENCES BW POSITION IN THE FRAGMENTS???

## Plot Differences bw positions?

YII_trea <- ggplot(Acer.position, aes (Treatment, YII, colour=factor(Position)))
YII_trea + stat_summary(fun.data = "mean_cl_boot",geom = "errorbar", width = 0.2)+
  stat_summary(fun.y=mean, geom="point", size =3, alpha=0.5) +
  geom_jitter()+
  facet_wrap(~Position)

YII_trea + stat_summary(fun.data = "mean_cl_boot",geom = "errorbar", width = 0.2)+
  stat_summary(fun.y=mean, geom="point", size =3, alpha=0.5)


# Stats
ANOVA_Y <- aov(YII~Position, Acer.position)
summary(ANOVA_Y)
# plot(ANOVA_Y)

TukeyHSD (aov(YII~Position, Acer.position))

# There was not difference bw bottom an center, so drop center data

Center.data<-Acer.Tall[(Acer.Tall$Position=="Center"),]
Acer.Tall<-droplevels(Acer.Tall[!rownames(Acer.Tall) %in% rownames(Center.data),])
```
