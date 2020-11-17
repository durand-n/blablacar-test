# BlaBlaCar iOS Technical Test

The goal of this test is to kickoff a carpool search application using our API services. The outcome should be returned in a limited amount of time.
We’ll use it as a support for on-site debrief and technical interview.
- As we require this to be done in a limited amount of time, we do not expect something in a finished state. Focus on  architecture and scalability first. UI is secondary.
- External library usage is allowed.
- Be honest on the time you spent on it.

You will need a Github account in order to share your results:

1. Fork this project in a **private repository**
1. Push your work on a separate branch
1. Make a pull request targetting the `master` branch
1. Share it with `bbc-ios-devs` Github account

## Get an API access token

In order to use the BlaBlaCar API you need to request and store an API token. 
See the [documentation](./DOCUMENTATION.md) for more detail, here are the credentials:

POST https://edge.blablacar.com/token

| Key | Value |
| --- | --- |
| client_id | `ios-technical-tests` |
| client_secret | `rVSUYoebg6zbZxYNxGOGAxv09oSi3gGg` |
| grant_type | `client_credentials` |
| scopes | `["SCOPE_TRIP_DRIVER", "DEFAULT", "SCOPE_INTERNAL_CLIENT"]` |

Here’s a sample cURL request to fetch a token:
```
curl --location --request POST 'https://edge.blablacar.com/token' \
--header 'Content-Type: application/json' \
--data-raw '{
    "grant_type": "client_credentials",
    "client_id": "ios-technical-tests",
    "client_secret": "rVSUYoebg6zbZxYNxGOGAxv09oSi3gGg",
    "scopes": [
        "SCOPE_TRIP_DRIVER",
        "DEFAULT",
        "SCOPE_INTERNAL_CLIENT"
    ]
}'
```

## Implement a search

Implement a basic trip search with the help of BlaBlaCar’s API inside your new project. 
It displays a list of trips (you can display the minimum information for each cell : from / to / driver name / picture / price ....)

Optional: The first screen should be a form with a departure and arrival city.

```
curl --location --request GET 'https://edge.blablacar.com/trip/search?from_address=Paris&to_address=Toulouse&search_uuid=8401658C-E98D-457E-A087-34FA2D979D69' \
--header 'Authorization: Bearer xxxxx-yyyyy-zzzzz' \
--header 'X-Locale: fr_FR' \
--header 'X-Visitor-Id: 8401658C-E98D-457E-A087-34FA2D979D69' \
--header 'X-Currency: EUR' \
--header 'X-Client: iOS|1.0.0'
```

## What's next?

Once your case is shared, the iOS team will review it and debrief together.
If the decision is made to go to the next round, we will invite you for an on-site technical interview based on your case (the interview can also be done remotely).
- You will have the opportunity to meet the team during an informal coffee break
- We will proceed with a 2 hours technical interview, with a few engineers from the team
- We will prepare technical questions based on your returned case
- Prepare a 10 min pitch to present your project to you interviewers
- You will have to present your project on screen during the interview (expect some live coding). Please notify us if you are not able to bring your laptop (or to share your computer’s screen if the interview is done remotely).
