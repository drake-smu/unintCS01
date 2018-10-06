##################################### Analysis of the Raw Data #################################################
library(dplyr) # so we can use %>% pipes!
############################################ Beer O' Clock #####################################################
rawBeer <- read.csv(file = "data/raw/Beers.csv",header=TRUE, sep=",",stringsAsFactors=FALSE)
######################################## Breweries ###################################################
rawBrew <- read.csv(file= "data/raw/Breweries.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
############################### Examine the structures, esp colnames ############################
str(rawBeer)
str(rawBrew)

# we see that beer has beer name, beer id, abv, ibu, brewery id, and style, 
# while breweries have brew id, name, city state

# we are going to change the brew id column name so it is the same, as well as make new datasets. It is 
# named Beer1 and Brew1 because they are the first iteration of the beer and brewery sets
Beer1 <- rawBeer %>% rename(Brewery_ID=Brewery_id)
Brew1 <- rawBrew %>% rename(Brewery_ID=Brew_ID)

# Now we reorder the data in Beer1, just so things make more sense, and it is a good practice for merging, so you can make sure things are going well
Beer1 <- Beer1 %>% select(Name,Beer_ID,ABV,IBU,Style,Ounces,Brewery_ID)
BeerBrew <- merge(Beer1,Brew1, by='Brewery_ID')
# Now we need to tidy up our names, we should have done this before merging
BeerBrew <- BeerBrew %>% rename(BeerName = Name.x) %>% rename(BreweryName = Name.y)
head(BeerBrew)
tail(BeerBrew)
# Now we can count the amount of NAs, also look at all those parentheses!
na_count <- data.frame(sapply(BeerBrew, function(y) sum(length(which(is.na(y))))))
# Human readable names!
na_count<- na_count%>%rename(na_count=sapply.BeerBrew..function.y..sum.length.which.is.na.y.....)
# Now let's figure out whats going on in each state, number of breweries in each one
# Lets discuss barplots, I am great at ggplot2 but there are so many ways to present this
# Here we make a data frame which has summary statistics for each state
StateSummary <- as.data.frame(BeerBrew %>% group_by(State) %>% summarise(medianABV = median(ABV, na.rm=TRUE),medianIBU = median(IBU, na.rm=TRUE),NumBreweries = n_distinct(Brewery_ID)))
# Now we are going to find the state that has the strongest and most bitter beer, as well as the name of that beer, because obviously we would want to know that
MaxABV <- BeerBrew %>% select(State, BeerName, ABV) %>% filter(!is.na(ABV)) %>% arrange(desc(ABV)) %>% slice(1)
MaxIBU <- BeerBrew %>% select(State, BeerName, IBU) %>% filter(!is.na(IBU)) %>% arrange(desc(IBU)) %>% slice(1)
# Once we decide on summary statistics we can easily make that, now all that is left is data viz
StateSummary
na_count
MaxABV
MaxIBU