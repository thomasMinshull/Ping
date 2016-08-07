# Ping
 
## Summary 
Ping, a networking application built as a midterm project at Lighthouse Labs. 
Ping measures the distance between users at networking events using Bluetooth running in the background and persists this data-using Realm. Late, users can access a list of other users who attended the event, sorted with those closest to them at a given time at the top of the list. This list includes information gather from LinkedIn’s API, and links to each users LinkedIn profile. Users, profile information is passed between devices using the mobile backend as a service (MBaaS) Backendless. 



## ToDo 
### New Features To be added 
 1. flush out unneeded locally stored data to free up room on users device (possible archiving historic data to the server) 
 2. throttle the connections to reduce strain on battery and storage on users device
 3. add a comment field to table view cells so users can make notes about people they have met (comments would be stored locally) 
 4. add the ability to export those notes/comments to other medium (IE email, text, Air drop, add to your notes app, etc ) 
 5. add the ability to easilly reskin the app for different conferences 

### clean up tasks
 1. Refactor remove comments
 2. stream line sign up process, create sign up managers, and improve persistence of current users 
 3. handle sign up edge cases 
 4. improve blue tooth communication to use central and peripheral deligates 
  
 
### list of features for final project 
Features/Tasks 
Priority: 

1. Add Throttling of bluetooth connections (send/store less data) 
2. Add the ability to manually add an event into the app (this will include start time and end time for the event). We will automatically turn the bluetooth on just prior to the event and turn it off just after the event 
3. Refactor the app Architecture as per Cories comments 
4. Fix UI (Date picker, etc) 
5. Create a simple animation for launch screen/onboarding 
6. Create an onboarding experience (the initial screens a first time user will see when logging into the app) 
7. Free up locally stored data. Data more than x day’s old is backed up to the server and removed from the device
8. Refactor the login process (improve the persistence of users/handle sign up edge cases) 
9. Integrate with MeetUp API to automatically get start time and end time of events you are signed up to attend
10. Improve the bluetooth architecture to use delegates (and conform to standard?) 
11. Add a comment field that will allow users to make a comment about how they met a user for them to reference later
12. Use geofencing to turn on/off bluetooth 
13. Display people grouped by distance in sections of the table view
14. Make comments (mentioned above) exportable via text messages/email 
