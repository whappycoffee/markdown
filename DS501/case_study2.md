# Case_Study_2
=============================
In this study, I have collected the movie data from MovieLens, it contains data about users(user id, age, gender, occupation), about the movie(movie title, movie genre, release date),  how the users rated the movie.
Nowadays, countless movies would be produced every year. However, not all of the movies could bring profits to their producers, the taste of people is really hard to guess. Luckily, after decades of development, the movie industrial has accumulated many data about previous movies, by analyzing the data, hopefully, we can find out the particular preference for different group of people.

## Problem 1
* 15 movies have an average rating over 4.5
* 20 movies have an average rating over 4.5 among man, and 22 movies have an average rating over 4.5 among woman
* 59 movies have an median rating over 4.5 among man, and 91 movies have an median rating over 4.5 among woman
* the top 10 most popular movies are: **Star Wars (1977)**, **Return of the Jedi (1983)**, **Empire Strikes Back, The (1980)**, **Fargo (1996)**, **English Patient, The**, **Toy Story**, **Princess Bride, The**, **Independence Day (ID4)**, **Godfather, The**, **Men in Black (1997)**
* Drama movie is the most popular movie genre among all occupations, and students are the most viewers for all genres(maybe their teachers didn't left enough homework)

I have defined several functions to collect the data I want.

#### counting the average rating of each movie
-----------------------------
averagerating <- function(moviename){
  newdata = subset(mlMultiData, movie_title == moviename)
  avrating = sum(newdata$rating)/length(newdata$rating)
  return(avrating)
}

with(droplevels(mlMultiData), list(levels = levels(movie_title), nlevels = nlevels(movie_title)))
movienames = levels(mlMultiData$movie_title)
table(movie_title)
i = 0
rating = c()
while(i < length(movienames)) {
  i = i+1
  rating[i] = averagerating(movienames[i])
}
the rating vector contains the average rating of each movie.


#### counting the average ratings by gender
-------------------------------------------
manrating <- function(moviename) {
  newdata = subset(mlMultiData, movie_title == moviename & gender == "M")
  avrating = sum(newdata$rating)/length(newdata$rating)
  return(avrating)
}

womanrating <- function(moviename) {
  newdata = subset(mlMultiData, movie_title == moviename & gender == "F")
  avrating = sum(newdata$rating)/length(newdata$rating)
  return(avrating)
}
mrating =c()
wrating =c()
i = 0
while(i < length(movienames)) {
  i = i+1
  mrating[i] = manrating(movienames[i])
  wrating[i] = womanrating(movienames[i])
}
the mrating and wrating contains the average rating of each movie by male or female


#### counting the average ratings by gender and age
-------------------------------------------
man30 <- function(moviename) {
  newdata = subset(mlMultiData, movie_title == moviename & gender == "M" & age > 30)
  m = median(newdata$rating)
  return(m)
}

woman30 <- function(moviename) {
  newdata = subset(mlMultiData, movie_title == moviename & gender == "F" & age > 30)
  m = median(newdata$rating)
  return(m)
}
wmedian = c()
mmedian = c()
i = 0
while(i < length(movienames)) {
  i = i + 1
  wmedian[i] = woman30(movienames[i])
  mmedian[i] = man30(movienames[i])
}
the wmedian and mmedian contains the median rating of man or woman over 30years old.

**finally** I have merged these data into one data frame
-------------------------------------------
movierating = data.frame(movienames, rating, wrating, mrating, wmedian, mmedian)
write.csv(movierating,"generalrating.csv")

#### counting movies rated over 4.5 overall
-------------
overall = subset(movierating, rating >= 4.5)
length(overall$movienames)
15

#### man over 4.5
----------
man = subset(movierating, mrating >= 4.5)
length(man$movienames)
20

#### woman over 4.5
--------
woman = subset(movierating, wrating >= 4.5)
length(woman$movienames)
22

#### man over 30
-----------
m30 = subset(movierating, mmedian >= 4.5)
length(m30$movienames)
59

#### woman over 30
----------
w30 = subset(movierating, wmedian >=4.5)
length(w30$movienames)
91

### most popular movies**
----------
movies recieved highest ratings might not be the most popular movie, so I have calculated the rating times each movie recieved, the moveis recieved most rating times must be the most popular movie.

moviereviews = table(mlMultiData$movie_title)
write.csv(moviereviews,"moviereviews.csv")
popular = read.table("moviereviews.csv", header = T , sep = ",")
attach(popular)
sort(Freq)
sort.popular = popular[order(-Freq), ]
sort.popular[1:10, ]

        X                            Var1 Freq
1398 1398                Star Wars (1977) 2915
1234 1234       Return of the Jedi (1983) 2535
457   457 Empire Strikes Back, The (1980) 2202
499   499                    Fargo (1996) 1524
461   461     English Patient, The (1996) 1443
1523 1523                Toy Story (1995) 1356
1178 1178      Princess Bride, The (1987) 1296
744   744   Independence Day (ID4) (1996) 1287
613   613           Godfather, The (1972) 1239
962   962             Men in Black (1997) 1212

### my conjectures
the hollywood action movies with wonderful special effect must be the most popular genre among all groups, and certain genres must be prefered by certain groups of people. So I have calculated the most popular genre in every occupation and for each kind of genre, the largest user group.

first, I have created a data frame about for each genre, how many times every occupation had reviewed.[genreBYoccupation](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/genreBYoccupation.csv)

the codes is shown below:
genre = levels(mlMultiData$genre)
occupation = levels(mlMultiData$occupation)

CountingOccup <- function(moviegen,movieoccup) {
  newdata = subset(mlMultiData, genre == moviegen & occupation == movieoccup)
  counting = length(newdata$movie_title)
  return (counting)
}

i = 0
GbyO = genre
while(i< length(occupation)) {
  oc = c(NULL)
  j = 0
  i = i + 1
  while (j<length(genre)) {
    j = j + 1
    oc[j] = CountingOccup(genre[j],occupation[i])
  }
  GbyO = data.frame(GbyO,oc)
}
colnames(GbyO) = c(" ", occupation)
GbyO[1] = NULL
rownames(GbyO) = genre
write.csv(GbyO, "genreBYoccupation.csv")
mostviewedoccupation <- function(moviegenre) {
  newdata = subset(GbyO, rownames(GbyO) == moviegenre)
  occup = names(newdata)[which(newdata == max(newdata), arr.ind = T)[,"col"]]  ###ref:https://stackoverflow.com/questions/36960010/get-column-name-that-matches-specific-row-value-in-dataframe
  return(occup)
}
mostviewdmovie <- function(viewer) {
  newdata = GbyO[viewer]
  genre = rownames(newdata)[newdata == max(newdata)]
  retuen(genre)
}
#### most viewed occupation by genre
i = 0 
gen = c()
while (i< length(genre)) {
  i = i + 1 
  gen[i] = mostviewedoccupation(genre[i])
}
ocupBYgenre = data.frame(genre,gen)
write.csv(ocupBYgenre,"ocupBYgenre.csv")

[ocupBYgenre.csv](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/ocupBYgenre.csv)

#### favorite genre by occuptaion
i = 0
occup = c()
while (i< length(occupation)) {
  i = i+1
  occup[i] = mostviewdmovie(occupation[i])
} 
genreBYocup = data.frame(occupation, occup)
write.csv(genreBYocup, "genreBYocup.csv")
[genreBYocup.csv](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/genreBYocup.csv)

it turns out that drama is the most popular genre among all groups, and student is the largest reviewer group for all genres.

## Problem 2

**histogram of all ratings of all movies**
library(ggplot2)
stars = c(1,2,3,4,5)
getstartimes = function(star) {
  newdata = subset(mlMultiData, rating == star)
  numbers = length(newdata$movie_title)
  return(numbers)
}
i = 0
startimes = c()
while(i<length(stars)) {
  i = i+1
  startimes[i] = getstartimes(stars[i])
}
RatingOfAll = data.frame(stars,startimes)
ggplot(RatingOfAll, aes(x = stars, y = startimes)) +geom_bar(stat = "identity")

![all movie](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/ratingOFall.png)

**number of ratings each movie recieved**
moviereviews = read.csv("moviereviews.csv", header = T, sep = ",")
ggplot(moviereviews, aes(x=movies,y=times)) + geom_bar(stat="identity") 

![number of ratings](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/number_of_ratings.png)

**average rating of each movie**
general =read.table("generalrating.csv", header = T, sep = ",")
ggplot(general, aes(x = movienames, y = rating)) +geom_bar(stat = "identity")

![ave_all](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/aveofall.png)

**average rating of movie with over 100 ratings**
r100 = subset(general, general$times > 100)
ggplot(r100, aes(x = movienames, y = rating)) +geom_bar(stat = "identity")

![over100 times](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/over100times.png)

the movies rated over 100 times have a higher average rating than all movies.
I would trust the movies rated over 100 times, some ratings might not be so convicing for lacking of enough data, the movies rated over 100 times would show a more steady result.

### my conjectures
**kids**
I have defined kids as under 12 years old, and the rating distribution histogram is shown below:

getstartimes = function(star, age) {
  newdata = subset(mlMultiData, rating == star & age <= 12)
  numbers = length(newdata$movie_title)
  return(numbers)
}

i = 0
startimes = c()
while(i<length(stars)) {
  i = i+1
  startimes[i] = getstartimes(stars[i])
}
RatingOfAll = data.frame(stars,startimes)
ggplot(RatingOfAll, aes(x = stars, y = startimes)) +geom_bar(stat = "identity")

![kids](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/ratingofkids.png)

we can see that, kids would more likely to give a positive feedback, however we can not simply conclude that kids are more easlily to please.


**elders**
people older than 70 are defined as elders:
getstartimes = function(star, age) {
  newdata = subset(mlMultiData, rating == star & age >= 70)
  numbers = length(newdata$movie_title)
  return(numbers)
}

i = 0
startimes = c()
while(i<length(stars)) {
  i = i+1
  startimes[i] = getstartimes(stars[i])
}
RatingOfAll = data.frame(stars,startimes)
ggplot(RatingOfAll, aes(x = stars, y = startimes)) +geom_bar(stat = "identity")

![elders](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/olderthan70.png)

the elders are also more likely to give a positive feedback.

**favourrate**

I have defined a term "fabourrate", it means the percentage of high rates(4 or 5) in the whole dataset.

favourratebyage = function(aging) {
  newdata = subset(mlMultiData, age> (aging-10) & age <=aging)
  newdata_favour = subset(mlMultiData, age> (aging-10) & age <=aging & rating >=4)
  favourrate = length(newdata_favour$rating)/length(newdata$rating)
  return(favourrate)
}
age = c(10,20,30,40,50,60,70,80)
i = 0
favourrate = c()
while (i<length(age)){
  i = i+1
  favourrate[i] = favourratebyage(age[i])
}
favourbyage = data.frame(age, favourrate)
ggplot(favourbyage, aes(x=age,y=favourrate)) + geom_bar(stat = "identity")

![favourrate](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/favourrateBYage.png)

we can see that, the 70-80 people are more easily to please, while the 20-30 people held a more strict criteria fro movies.

## Problem 3

**scatter plot of man versus woman**

ratingBygender = function(sex,name){
  newdata = subset(mlMultiData,gender == sex & movie_title == name)
  averating = sum(newdata$rating)/length(newdata$rating)
  return(averating)
}
i = 0
male = rep("M", length(movienames))
female = rep("F",length(movienames))
sex = c(female,male)
names =c(movienames,movienames)
rating = c()
while (i<length(movienames)*2) {
  i = i+1
  rating[i] = ratingBygender(sex[i],names[i])
  
}
names = data.frame(names,rating,sex)
write.csv(names,"aveBYgender.csv")
ggplot(names,aes(names,rating)) + geom_point(size = 1, aes(colour = factor(sex)))

![MvW](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/aveBYgender.png)

**man versus woman over 200 times**

ratingBygender = function(sex,name){
  newdata = subset(mlMultiData,gender == sex & movie_title == name)
  averating = sum(newdata$rating)/length(newdata$rating)
  return(averating)
}
times = moviereviews$times
times = c(times,times)
i = 0
male = rep("M", length(movienames))
female = rep("F",length(movienames))
sex = c(female,male)
names =c(movienames,movienames)

rating = c()
while (i<length(movienames)*2) {
  i = i+1
  rating[i] = ratingBygender(sex[i],names[i])
  
}
names = data.frame(names,rating,sex,times)
names200 = subset(names,times >= 200)
write.csv(names200,"aveOver200.csv")
ggplot(names200,aes(names,rating)) + geom_point(size = 1, aes(colour = factor(sex)))

![200times](https://raw.githubusercontent.com/whappycoffee/whappycoffee-markdown/master/DS501/over200.png)

### corelation coefficient 
female = general$wrating
male = general$mrating
cor(male, female)
NA
in the data of male rating and female rating, there are lots of empty elements, it means for some movies, only male or only female had watched it. so the cor() function returns a NA. In order to compute the correct corelation coefficient, I only selected movies rated over 200 times.

general200 = subset(general, times >= 200)
newnames = general200$movienames
newnames = as.vector(newnames)

averagingbyGO = function(sex,name) {
  newdata = subset(mlMultiData, gender == sex & movie_title == name)
  ave = sum(newdata$rating)/length(newdata$rating)
  return(ave)
}
i = 0
male = c()
female = c()
while(i<length(newnames)) {
  i = i+1
  male[i] = averagingbyGO("M", newnames[i])
}
i = 0
while(i<length(newnames)) {
  i = i+1
  female[i] = averagingbyGO("F", newnames[i])
}
cor(male,female)
0.8027345

Judging from the corelation coefficient, female ratings and male ratings are pretty similiar, so based on this standard, I would like to find out whether there are two groups of people have a higher corelation coefficient than average.

**conuting by genre(students)**

averagingbyGO = function(sex,ocp,gen) {
  newdata = subset(mlMultiData, gender == sex & occupation == ocp &genre == gen)
  ave = sum(newdata$rating)/length(newdata$rating)
  return(ave)
}
i = 0
male = c()
female = c()
while(i<length(genre)) {
  i = i+1
  male[i] = averagingbyGO("M","student", genre[i])
}
i = 0
while(i<length(genre)) {
  i = i+1
  female[i] = averagingbyGO("F","student", genre[i])
}
cor(male,female) 
0.697675

for students, female and male have a lower corelation coefficient on different genre of movies, it might because the student is really a large gropu of people, they have different background and different preference, so same genre would have pretty different response in students.

**counting by genre**
averagingbyGO = function(sex,gen) {
  newdata = subset(mlMultiData, gender == sex & genre == gen)
  ave = sum(newdata$rating)/length(newdata$rating)
  return(ave)
}
i = 0
male = c()
female = c()
while(i<length(genre)) {
  i = i+1
  male[i] = averagingbyGO("M", genre[i])
}
i = 0
while(i<length(genre)) {
  i = i+1
  female[i] = averagingbyGO("F", genre[i])
}
cor(male,female)
0.8712902

computing by genre, the corelation coefficient is higher than average, hopefully we could say that we can predict the ratings for one genre of one gender by the ratings of another gender.

## Problem 4

in my analysis, I have found many interesting results: 
* drama is really popular in all occupations
* the student is the largest customer group for movie
* the number of overall 4.5 movie is 15 while the male 4.5 movie is 20, the female 4.5 movie is 22, it means male and females have a different taste on movies
* elder people are easily to give a higher rating for movies
* a few movies could gain a rating over 4.5, few movies would gain a rating lower than 2, most movies are between 2-4

this data can tell us which genre of movie is the most popular one, and which group of people is the major customer for movie industrail.

from the data, we can see that drama is the most popular genre for all occupations except "none", and for all genres, students are the most reviewers, so I would suggest my bose to produce more drama, and realse more movies during summer vacation when students don't have to go to school












