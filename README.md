# elit
A one stop shop for **movie-lovers**. <br>
elit is an app that for users to find and learn about new movies.

### Origin
"elit" in latin means "movies". The purpose of elit is not to find movies thats users may already know, 
but to help users find and look up new movies that they might have missed out on, and may want to watch in the future. 
All of our data is pulled from [The Movie Database API](https://developers.themoviedb.org/3/getting-started/introduction).

### Purpose
With Movies presented as card models, users can either swipe left or right based on how they feel about the movie. 
Swiping left means that the user did not like the given movie and would like to move on to the next. 
Swiping right means that the user is considering to watch it in the future. It also adds the movie to the **Favorite Tab** so that the user can come back to it later.

--- 

## Features
### Users
- User Login <br>
- User Signup
- User Logout
- Users info and corresponding favorite movies are saved as plists
- Current logged-in user and current favorite movies are saved in UserDefaults 
- Users can view their list of favorite movies and edit it.
- Profile Tab:
  - Users can view their username and password
  - Users can update their username and password <br>
<img src ="https://github.com/art4829/elit/blob/master/App%20Walkthrough/Login.gif" width="200"/> <br>
### Movies
- GET Movies data from TMDB Api
- Filter Movies:
  - Based on various filters: ratings, genres, language
  - Filters are remembered after users apply them
  - Users can reset filters
- Movies Tab:
  - Tap on a movie card to show the description as a pop-up
  - Swiping right adds the movie to the user’s favourites.
  - Swiping left presents a new movie card
- Favorites Tab:
  - Shows the movie’s name and rating
  - Items can be deleted or moved around
  - If no internet connection, informs user and exits.<br>
<img src ="https://github.com/art4829/elit/blob/master/App%20Walkthrough/Swipe.gif" width="200"/> <br>
<img src ="https://github.com/art4829/elit/blob/master/App%20Walkthrough/Filter.gif" width="200"/> <br>
---
### Wish List for next version
- If no movies are found, alert the user. Currently, it is assumed that movies are going to be found for the filters inputted by the user.
- If the device is no longer connected to the internet after the app opens, then inform the user and exit. Currently, it only checks when the app is first opened.
- User Login handled through a server and not in local storage.
- Add TV Shows as an option.
- Improve UI of movie cards
- Users can share their favorites on social media or to other users.

## Final Thoughts
This was our first IOS Project and we had a lot of fun building it. While we utilized many concepts we learned in class, we also did our own research and learned alot from it. We really appreciate [The Movie Database](https://www.themoviedb.org/) for their APIs as this project would not have been possible without them. For people trying to implement similar concepts, we definetly suggest looking for tutorials online. While they are helpful, we **strongly** recommend using them as a reference and not simply following and copying what they teach. If you have any suggestions for our application, please let us know! Thank you.

