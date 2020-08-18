# Black Market 2

**BlackMarket 2** is a mod for [Factorio](https://factorio.com/) economics.

## Description
Sell and buy items/fluids/energy on the universal black market using trading chests/tanks/accumulators, choosing the frequency of exchanges and related fees. You can now sell your overproduction and buy things that you don't want to craft by yourself. You can also use these trading units as a paying shipment system.

![](https://raw.githubusercontent.com/djmango/BlackMarket2/master/thumbnail.png "Icon")

## Download
* [Latest](https://github.com/djmango/BlackMarket2/archive/master.zip)
* [Factorio Mod Page](https://mods.factorio.com/mod/BlackMarket2)

## Notes 
* For selling and buying periods, the day is reset at noon, not at midnight. So if you sell once a day (24h period), sales will always occur around 12:00.
* You can choose to sell or buy immediatly, but the tax is high : 25%
* Note that selling and buying frequencies are per chest. But you can also set them all at once from the main menu.
* You can choose to automatize each chest independantly. Bu you can also set them all automatic from the main menu (or disable them). In the main menu, you can also use the "pause" checkbox to momentary pause the automatic transactions.
* Near the top main button, you can read your current credit in Ucoins.
* When you first install the mod, your credit is 0, so obviously you have to sell a few items before buying some... :*D
* It's also obvious, but if you do not have enough credits, buying chests cannot realize their purchase orders.
* When holding any item in your hand, the upper credit line shows the price of the item instead of your total credit.
* You can browse through the list of prices using the Show button.
* Prices of each item is determined using recipes, prices of ingredients, amortization of technology, cost of energy and a commercial margin. Basic resources value is 100u. There is a button to export a list of prices to the scrip*output directory, in a CSV spreadsheet format.
* Remember that the price of an item is always greater than the sum of the prices of its ingredients. That's why you can do profit. You are selling your transformation work as an added value.
* There is an initial prices list construction lauched in background when you installed the mod or when you change other mods configuration, to detect new objects or non existing objects.
* Prices are dynamic : they evolve using a simplified law of supply and demand. The more players sell one object, the more its price decreases ; the more players buy one object, the more its price increases. This dynamic pricing is for the whole map, not only one force. When untouched, an object price return slowly to its original price.
* You can withdraw some cash from your account by buying Ucoins items : there is no fee on such a purchase, and you will get Ucoins items in return in the chest. You can use these Ucoins items to give money to a player from another force (using TradingChests mod for example). You can also deposit some cash on your account, selling Ucoins items with no fee.
* Hover your mouse on buttons and labels to see tooltips.
* To display the hour of the day, and be aware of transaction times, I recommand installing my [url=https://mods.factorio.com/mods/binbinhfr/TimeTools]TimeTools[/url] mod that provides a clock in the top bar.

## Contributors
* [Contributors graph](https://github.com/djmango/BlackMarket2/graphs/contributors)
* [@BinbinHfr](https://mods.factorio.com/user/binbinhfr), original mod creator
* [@totobest](https://github.com/totobest/), previous mod maintainer
* [@djmango](https://github.com/djmango/), current mod maintainer

## Third party libraries
* [Core/Class : npo6ka from FNEI mod (MIT)](https://github.com/npo6ka/FNEI)
* [Factorio*Stdlib: Afforess](https://github.com/Afforess/Factorio*Stdlib/blob/master/LICENSE)

## License 
* see [LICENSE](https://github.com/djmango/BlackMarket2/blob/master/LICENSE) file

## Contact
* Homepage: [GitHub](https://github.com/djmango), [Modpage](https://mods.factorio.com/mod/BlackMarket2)
* email: skghori03@gmail.com

[![Flattr this git repo](http://api.flattr.com/button/flattr*badge*large.png)](https://flattr.com/submit/auto?user_id=djmango&url=https://github.com/djmango/BlackMarket2&title=BlackMarket2&language=&tags=github&category=software) 

