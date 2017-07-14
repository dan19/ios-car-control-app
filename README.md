# iOS Car Control App

iOS Application that enables to browse and listen to your Spotify playlist and access Yelp POI
while driving. The UI is made so the user doesn't have to look at the screen to interact with the app.
All the interaction are made through swipe gestures.
The screen is split in two:
- The top part enables interaction with Spotify:
  * Swipe left and right to go previous and next in the current playlist.
  * Swipe up and down to go to the previous or next playlist. When switching playlist, the name of the playlist is read by the iOS accessibility voice.

- The bottom part enables interaction with:
 * Contact book: each contact name will be read using the iOS accessibility voice while scrolling. One tap will enable to call the contact.
 * Yelp point of interest: using Yelp API, we show different POI based on the user location: Gas station, restaurants, parking...

 ### Todo:

 - Port the code to iOS 10 and support new screen sizes
 - Migrate to the new Spotify SDK. Libspotify not supported anymore.
 - Integrate with Alexa Voice Service
