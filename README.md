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
  
 
