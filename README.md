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
- User Login
- User Signup
- User Logout
- Users info and corresponding favorite movies are saved as plists
- Current logged-in user and current favorite movies are saved in UserDefaults 
- Users can view their list of favorite movies and edit it.
- Profile Tab:
  - Users can view their username and password
  - Users can update their username and password
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
  - If no internet connection, informs user and exits.



