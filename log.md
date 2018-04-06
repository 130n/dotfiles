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


Tue Mar 27 14:49:26 CEST 2018
- bug in replay: can relay unscratched tickets - disable button for status P = in progress. Switch badge to btn to get disable behavior.
- meeting with poc-boys, how to move forward with rebel nd birds design stuff

Tue Apr  3 19:11:22 CEST 2018
- chaotic day:
- joined linda for a telephone meeting with nyx, we will look into using Channel when creating recurring deposits to distinguish which are user initiated and which are subscriptions
- andreas questioned me about sitevision deployment stuff. answered questions instead of lunch.
- skrapyra not working in dev - looked into it with jens and linda. need to fix it in database and add possibility to edit the period table from pokus/skrapyra admin
- looked at release schedule with iulia.
- ludmila couldn't deploy the scratch subscription service in acc due to incorrect password. Need to get the correct one from either daniel, jacob or uffe. Sent them a mail, is hopefully solved once i get here tomorrow


Tue Apr  3 19:17:25 CEST 2018
- created two pullrequests for bugs in frontend. Small fixes but took some time to do it RIGHT (tests, remove unfixed lint errors etc)
- merged hargnes storybook PR after fiddling with the eslint config to add storybook stuff to the "allowed to use devDependencies" list

Wed Apr  4 19:57:45 CEST 2018
- continued chaos
- gave the failing transaction history tests in gatekeeper another go but rn into same trouble with wiremocked queryparams
- Got access to hiera/puppet, forked and PRd in new password for scratchsubscription in ACC
- Guesstimated hours worked on OLG in march for oliver
- Started to track down issues with microservices to be released: POSTGRES migration, Pact tests, int/unit tests. Got it working in acc (dev only runs postgres now)

Thu Apr  5 09:42:59 CEST 2018
- todays plan: get help for transactionhistory test and hopefully fix it, create release branches for microservices, create releasebranches for frontend

Thu Apr  5 19:59:27 CEST 2018
- no fix for queryparam but found a workaround instead.
- fixing tests and builds of the microservices to be released. Merged a couple of PRs into dev.
- created release branches for backend, want to get two PRs into frontend before releasebranching.
- fixing code review comments deteriorated into JS and eslint fest
- count eslint errors by file : npm run eslint -- -f compact | grep $(pwd) | sed -E  's/(.*):(.*)/\1/' | uniq -c | sort -k2nr | awk '{printf("%s %s \n",$2,$1)}END{print}'

Thu Apr  5 20:10:06 CEST 2018
- not working fully: npm run eslint -- -f compact | grep $(pwd) | sed -E 's?(.*):(.*)?\1?' | uniq -c | sort -k2nr | awk '{printf("%s %s \n",$2,$1)}END{print}'

Fri Apr  6 18:06:44 CEST 2018
- released frontend, started looking into seleniumtests which i realized have been failing for the last month or so
