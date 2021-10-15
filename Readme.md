# BitCoin Price Now

## Description 

Python APP Flask Based that:
1. Presents the Current Bitcoin Price in USD.
2. Presents the Average Price for the last 10 minutes.

Using: 
* docker
* coinmarketcap api

In addition create the image and push it to the dockerhub using jenkins.

# Installation and Usage
## prerequisites:
1. Docker
2. Accout in the coinmarketcap (https://coinmarketcap.com/api/).
3. API key
    
## Run the App:
    $ docker build -t bitcoin .
    $ docker run -it -d -p 5000:5000 bitcoin

## Image in dockerhub
     mohamadd3/dp-v1


