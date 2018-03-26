Mon Mar 12 11:20:01 CET 2018
- Started logging. Added alias log to open this file

Mon Mar 12 13:32:05 CET 2018
- Added sitevision user for Erik in ACC and prod. Go to User, click Directory
icon and navigate to cloud dir for postkodlotteriet.se. Rightclick to add new
user with username = email and some password. Then go to Properties and then
Permissions, add new Role For person with CloudAdmin access level

Mon Mar 12 14:54:38 CET 2018
- Tabmeny stopped working in acc, added better condition if (!rootid || rootid === '' || rootid === 'undefined') {
- Add newline before input in log and .md instead of .txt instead of .txt

Mon Mar 12 17:21:50 CET 2018
- Fixed conditional comparisons after proptypes were changed (which killed olgwinners component)
- Get access to olg space on wiki, fix tests. Change scratch url component


Tue Mar 13 10:42:45 CET 2018
- realized why curl scripts were failing on Continue 100 https://gms.tf/when-curl-sends-100-continue.html

Tue Mar 13 16:38:20 CET 2018
- meeting with sitevision, begin on first draft of moving to restapps.
- Bug with localstorage in safari private browsing mode - use cookie as fallback
- User is logged out in develop environment - still an issue with newly created OLG customers

Wed Mar 14 13:21:00 CET 2018
- invalidate session in SV on user logout - branch name longer than commit contents


Tue Mar 20 10:34:50 CET 2018
- meeting regarding norwegian sitevision
- main problems with previous solution: two repos, flat structure in sv repo, 
- fix tests for replay, linda discovered that replay feature doesn't work as intended for scratch

Wed Mar 21 09:25:59 CET 2018
- work on getting wifi on mobile device to test chrome bug
- show linda where helptexts can be configured. Make sure to check that a new helptext is used for olg flow.


Wed Mar 21 12:50:25 CET 2018
- installing weinre based on instructions here https://stackoverflow.com/a/22047495. 
npm install -g weinre
weinre --boundHost -all-
uname -a - get hostname(or local ip)
Surf to port 8080, save scripttag for use in mobiledevice
- only supports https - follow https://www.undefinednull.com/2015/03/17/remote-debugging-localhost-with-weinre/ for https
npm install -g  ngrok
ngrok did not work as advertised - probably need to be on wifi to get local ip address

Fri Mar 23 17:30:25 CET 2018
- Working on scratch subscription backend - filtering transactions

Mon Mar 26 12:33:10 CEST 2018
- had backlog review to plan the coming weeks - this short week before easter and the next one where ludmila, ricard and yecid will be away
- after pull request review from ludmila I needed to fix filtering of scratchsubscription transactions and add tests

