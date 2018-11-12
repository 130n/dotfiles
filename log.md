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

Mon Apr  9 11:02:45 CEST 2018
- backlog review: planning release and what must be done before scratch subscription goes out
- need to verify that all stories deployed to acceptance have been tagged and are in correct state
- focus on missing links from scratch subscription and possible problems with release branches

Mon Apr  9 11:14:34 CEST 2018
- getting a bit pissed at a bunch of stories which have been merged, but without stories being tagged with fix version, transitioned to correct state and without any release-notes.
- RETRO need to go back and define our definition of done and make sure EVERYONE follows it

Tue Apr 10 12:30:44 CEST 2018
- all over the place:
- fixing replay table, colspan
- adding skrapjackpot to acceptance, sitevision stuff
- fix promise handling in scratch subscription, hargne crap


Wed Apr 11 10:17:29 CEST 2018
- Fixed hardcoded link from ticketpackage deilvery to game page.
- Todays todos: transactionhistory is not working for scratchsubscription, bingo jackpots looks whack, fix the last missing links like redirect and hiding mina sidor icon


Wed Apr 11 18:51:25 CEST 2018
- a version of ternary expression i wished existed in JS
const ternary = (valueExpression, successOperation, defaultValue) => {
  const value = valueExpression();
   if (!value) return defaultValue;
   return successOperation(value);
}

Mon Apr 16 11:13:43 CEST 2018
- todo fråga gustav om wiki -> atlassian kopplling
- dokumentera var SPLGames object används

Mon Apr 16 16:37:24 CEST 2018
- performed release - lots of release notes for frontend. Backend failed a couple of times due to memory problems on prod machines. After release SPL had some problems that turned out to be unreleated to the deploy.
- transaction history looks empty for me - too many NOTE transactions - report as bug.

Tue Apr 17 11:21:24 CEST 2018
- meeting with andreas about how he's done stuff in norwegian project. Cool thing nodeIteratorUtil has a toList method which makes it possible to iterate like normal over nodeIterator instead of useing while hasNext

Tue Apr 17 16:50:40 CEST 2018
- lotteri för kunden möte halva eftermiddagen. Roligare än väntat men tveksam om det genererade någon vettig output.

Thu May  3 13:22:05 CEST 2018
Det var ett tag sen jag loggade - börjar kännas rörigt i skallen med mycket contextswitchande så jag ger det ett försök till.
Efter stress och prodsatt premievalskampanj är det tillbaka i gröten. Scratch subscription sakerna har legat till sig och är inte i särskilt bra skick.
Sitevision upgraderingen i acc har gjort så att elementet inte längre syns - var tvungen att exportera det från dev igen. Passade på att göra om urlar från textsträngar till sidnods-val.
Mycket redirectande etc. Mina sidor länken behöver fixas - det visade sig att knappsidan är en egen komponent och inte en helt generisk lösning för båda mina sidor tabbarna.

Thu May  3 17:51:34 CEST 2018
Drama med www. domäner. Vi stödjer båda vilket leder till att vissa skickas mellan www och utan vid diverse redirects - vilket ger intrycket att man är utloggad.
Efter flera omgångar av störning och kontextswitching så skrev jag ihop en menlös kodrad som kan användas för att krasha sitevision:
    var sfcc = String["fromCharCode'CodeCharfrom".split("'")[0]], kill, asd=1 && eval('fuck'.split('').map((a, v) => (v%2) ? v-1 ? sfcc(116) : sfcc((''+v)+20) : v ? sfcc(1+v*52) : ''+(''+kill).split('d')[1][0]).join('')+('('+')'));


Fri May  4 09:42:36 CEST 2018
- todays todos: fixa scratch subscription komponenten så att url till mina sidor kommer in som en parameter. Lägg till resterande texter.

Wed May 16 17:14:08 CEST 2018
Reading through code for winner-service, price-aggregation-service, draw-service and SPL to find the wherabouts of data for weblight upgrade of "Rätta lott"
Winning categories in draw-service https://service.dev.postkodlotteriet.se/draw/category/all?status=ACTIVE


Fri May 18 16:16:58 CEST 2018
working on correct ticket data for presentation of last weeks winnings. Outstanding issues/questions:
- getting current publishing playing round from general plan. previous round will also be necessary but can in all cases except january be solved by taking playinground -1 (201805-1 for example). Does this work for end of year? Do i need to submit both 201712 and 201713 to be sure?
- should the draw-schedule be based on current time or only on days?

Mon May 21 10:07:21 CEST 2018
- CorrectTicket: will need to save data on customers checked tickets and last time they did so.

Tue May 22 15:20:18 CEST 2018
- Problem: draws repeat every week but wins seem tied to draw instead of publication - as such a win in weekly draw at end of previous week can't be distinguished from same draw in current week (eg it's tuesday and we get last 7 days with Veckovinst for Wed+Thurs last week)
- Realized that the connection between draw and publishDate wasn't available from draw-service API. After bringing this up to WL team I realized that it was preferrable to always get the results for an actual calendar week instead of the last 7 days.

Mon May 28 15:55:47 CEST 2018
Save gulptasks for testing the release/deploy:
    gulp.task('create-release', done => runSequence('bundle-sitevision-files', 'zip', done));
    gulp.task('fake-deploy-release', done => runSequence('init-config', 'init-version', 'extract-version', 'deploy-version', done));

Tue Jun  5 16:56:07 CEST 2018
Work on Check tickets has been going slow due to constant interruptions and new problems out of left field.
After getting a bit stuck on some SPL integration tests and also worrying over if it even belonged to SPL in the first place I decided that a new microservice would be the better option.
Stuff that have been done:
- get rickard to create github repo, because I dod not have permissions to
- request DB from uffe
- update hiera fork and start adding node conf for DEV environment (awaiting db password before PR)
- Add JsonBind annotation to use in jdbi and recreate Dao

Thu Jun  7 11:15:07 CEST 2018
- Needed for MS: encrypt passwords and add to dev, at, stage and prod configs in Puppet/hiera. Add TC jobs. Add what is needed to zdeploy.

Fri Jun  8 14:09:53 CEST 2018
- used eyaml to encryp cacs_db passwords. pkcs7 doesn't seem to generate same encryption every time - fishy. Investigate closer when deploying to dev (if it fails).
- created TC job based on premievalet, add to zdeploy config for dev and created PR for hiera conf

Thu Sep  6 16:04:34 CEST 2018
- been a while - lots of things to do so I need to keep track of them in my head
- rätta lott didn't save the checked tickets correctly. After fixing this the GET request still doesn't mark results as checked. Check if problem is with logic or in DTOs
- churn flow needs to be completed - post of churn reason from gatekeeper and test of resource. investigate if next grannyra is readily available from general-plan.

Thu Sep  6 18:22:39 CEST 2018
- tomorrow: get help to run gatekeeper locally against ACC to debug correct ticket

Fri Sep 14 11:32:44 CEST 2018
- fixing last  parts of rätta lott. add product, code and if it has been paid out.

Fri Oct 19 14:26:35 CEST 2018
had interview with guy. started looking at webapps but got dragged into robinson list bug.
