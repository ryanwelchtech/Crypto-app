## Inspiration
Recently, there has been a lot of talk about a virtual currency called Etherum. When I first heard of it, I thought that it was something related to chemistry. So, I decided to educate myself, and others, on different cryptocurrencies such as Etherum and Bitcoin.
## What it does
Crypto is capable of monitoring the price of various crypto currencies such as Bitcoin, Etherum, and Ripple. You simply pull down on the table view to refresh the value of the currencies. This is your handy crypto currency "library" that gets updated.
## How I built it
I coded the app in Xcode 8.3.3 using Swift 3.0. To gather the data for the crypto currencies, I used the API from <a href="https://api.coinmarketcap.com/v1/ticker/">CoinMarketCap</a> to display the top 100 crypto currencies. I then parsed the JSON data to the tableViewController. The parsed data ended up being the rank,symbol, name, and price of the virtual currency. 
## Challenges I ran into
I ran into a few problems such as not being able to refresh the data when I pull down on the table view and experiencing runtime errors that I never heard of before.
## Accomplishments that I'm proud of
I am most proud of having. finished product. This was my first hackathon where I actually completed an app.
## What I learned?
I learned that there is more than one type of cryptocurrency, and each is very unique valuable in its own sense. Before, I only knew of Bitcoin. The last 2-3 weeks, I heard of Etherum. Now, I heard of 100 crypto currencies. 
## What's next for Crypto-app?
Most importantly, UI/UX changes will be made to make the overall experience more appealing. I need to update the refresh control for the table view so that the values update on demand, rather than on establishing a connection to the internet. I will also consider the option of enabling peer-to-peer transactions through one's crypto wallet and my app Crypto.
