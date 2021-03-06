# Integrational Tests
Privatix integrational tests.

## Tests

### Running the tests
Tests are run using the following command:
```
TELEGRAM_BOT_USER=user TELEGRAM_BOT_PASSWORD=password npm run test
```

### Tests report
The result of passing the tests in the file: `xunit.xml`

### Dependencies
1) Agent node
2) Client node
3) Check IP tool on Client ([ExternalIP](https://github.com/Privatix/dapp-exchange/tree/master/tools/externalip))
4) Config file `src/configs/config.json` with right params:
```
{
  "agentWsEndpoint": "ws://localhost:8888/ws",
  "clientWsEndpoint": "ws://localhost:8888/ws",
  "externalClientIpEndpoint": "http://localhost:6060/"
}
```

### Description
All test blocks are combined by the main `integrational tests` block.

There are two general categories:
1) initialization test blocks
2) smoke auto-tests

The structure of all tests and test blocks can be represented in the following tree:
* integrational tests
_used to combine all other tests_ 
  * configuration checks
  _check config file and env.vars for validity_
  * setting up websockets
  _set up agent&client websocket connections_
    * connect to agent ws endpoint
    * connect to client ws endpoint
    * generate and set agent&client passwords
  * smoke auto-tests
  _contains all smoke tests_
    * first login
    * get test ETH and PRIX
    * transfer PRIX: exchange balance → service balance
    * transfer PRIX: service balance → exchange balance
    * popup an offering

***

## Utils
Contains reusable blocks of code.

#### eth.ts
_`getEth`, `skipBlocks` and `getBlockchainTimeouts` functions_
#### ws.ts
_class to communicate with websockets_
### offerings.ts
_`generateOffering` and `generateSomeOfferings` functions_
### test-utils.ts
_`createSmokeTestFactory` and `getItFunc` functions_
### misc.ts
> You can pass optional argument to `npm test`, like:
> `npm test --scope agent`
> it will skip all tests, that require client connection

_`getAllowedScope` function_

***


## Helpers
There are two helpers: you can use to set up environment for tests.

#### setenv.sh 
Setting environmental variables required by some tests.

```
# To run:
. ./helpers/setenv.sh
```

Required by:
- **configuration check** test
- **get test ETH and PRIX** test

#### clear-db.sql 
SQL script that deletes from DB accounts, previously set passwords and created offerings.

> It is desirable to run this script before starting tests, because many tests require clean DB.

```
# To run from bash:
psql -U postgres -d dappctrl -a -f ./helpers/clear-db.sql
```
```
# To run from psql:
\c dappctrl
\i ./helpers/clear-db.sql
```
