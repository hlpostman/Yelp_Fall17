
# Project 3 - *Yelp Mockup*

**Yelp Mockup** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **13.5** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Table rows for search results should be dynamic height according to the content height.
- [x] Custom cells should have the proper Auto Layout constraints.
- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

The following **optional** features are implemented:

- [ ] Search results page
   - [ ] Infinite scroll for restaurant results.
   - [x] Implement map view of restaurant results.
- [x] Implement the restaurant detail page.

The following **additional** features are implemented (list anything else that you can get done to improve the app functionality!):
- [x] User can search for type of food and restaurant name simultaneously, like in real Yelp app (e.g. searching "Pizza" in Berkeley, CA will show you the well-loved pizza place "Jupiter" even though its name does not contain the word "Pizza")
- [x] User search experience is free of undesired results caused by filler words such as "of"
- [x] Customize navigation bar in detail view to be translucent as in real Yelp app detail view
- [x] Implement map view of the restaurant on the details page
- [x] Custom transition from list view to map view mimics that of real Yelp app
- [x] Custom transition from map view to list view mimics that of real Yelp app
- [ ] User sees business results displayed with number labels (e.g. "1. House of Thai, 2. Gecko Gecko Thai," etc) like in real Yelp app, when in table view

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. MapKit uses
2. Custom transitions (yelp has an interesting one between list and map view)

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/hlpostman/Yelp_Fall17/blob/master/YelpFall17_VideoWalkthrough.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I am thinking about adding a user story "User sees business results displayed with number labels (e.g. "1. House of Thai, 2. Gecko Gecko Thai," etc) like in real Yelp app, when in table view."  This is more complicated than I anticipated.  It involves either providing auto layout for 3 consecutive labels (i.e. putting a number label right in front of the business name), or adding the cell row via string interpolation in the cellForRowAt function, in such a way that the single number is preserved when a cell is scrolled out of the view and back on.

## License

    Copyright 2017 H.L. Postman (where it does not violate the 2014 copyright of Timothy Lee)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
