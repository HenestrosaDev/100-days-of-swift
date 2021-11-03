# LocalNotifications
Project 21 from the 100 Days of Swift Course https://www.hackingwithswift.com/100/72

## I've learnt...

- To show notifications (obviously)
- To schedule notifications with UNTimeIntervalNotificationTrigger (seconds) and UNCalendarNotificationTrigger (with DateComponents class)
- To create categories. Very similar to channels in Android.

## I have added the following features suggested by the instructor...

- Update the code in didReceive so that it shows different instances of UIAlertController depending on which action identifier was passed in.
- For a harder challenge, add a second UNNotificationAction to the alarm category of project 21. Give it the title “Remind me later”, and make it call scheduleLocal() so that the same alert is shown in 24 hours. (For the purpose of these challenges, a time interval notification with 86400 seconds is good enough – that’s roughly how many seconds there are in a day, excluding summer time changes and leap seconds.)
- (3rd challenge is for project 2)
