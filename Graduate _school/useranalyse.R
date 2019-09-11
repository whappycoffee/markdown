## info ##
consumer_key = "xkl8yIrrxRB5KFGT7LUivGWxx"
consumer_secret = "NNWvccDOT08LGDxSekDnsqSULkRlHl9dbymzsLjxl7wAzz0aKn"
accessToken = "747245736161468416-LTcwPM1XNoyMhpHNNQeCM498eoXjS6k"
accessTokenSecret ="y9UsGmd5QMLYD72urGsPVuE1G6ZjG47mQ2WfnhZbQwwg7"

setwd("C:/Users/wuyib/Desktop/program")
library(twitteR)
library(stringr)
setup_twitter_oauth(consumer_key, consumer_secret, accessToken, accessTokenSecret)
## get user
Hadley = getUser("hadleywickham")

## get friends and followers
HadleyFriends = Hadley$getFriends()
HadleyFollowers = Hadley$getFollowers()
friendDF = twListToDF(HadleyFriends)
followerDF = twListToDF(HadleyFollowers)
write.csv(friendDF, file ="friends.csv")
write.csv(followerDF, file = "followers.csv")
## get common elements
friendID = friendDF$id
followerID = followerDF$id
commonID = intersect(friendID,followerID)
commonSN = intersect(friendDF$screenName,followerDF$screenName)
commonList = data.frame(commonID, commonSN)
write.csv(commonList, file = "commomtable.csv")
