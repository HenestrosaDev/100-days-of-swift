# Local Notifications

[Project 21](https://www.hackingwithswift.com/read/21/overview) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                                                                                                           |
|:---------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [72](https://www.hackingwithswift.com/100/72) | <ul><li>[Setting up](https://www.hackingwithswift.com/read/21/1/setting-up)</li><li>[Scheduling notifications: UNUserNotificationCenter and UNNotificationRequest](https://www.hackingwithswift.com/read/21/2)</li><li>[Acting on responses](https://www.hackingwithswift.com/read/21/3)</li></ul> |
| [73](https://www.hackingwithswift.com/100/73) | <ul><li>[Wrap up](https://www.hackingwithswift.com/read/21/4)</li><li>[Review for Project 21: Local Notifications](https://www.hackingwithswift.com/review/hws/project-21-local-notifications)</li></ul>                                                                                           |

## I've learnt...

- To send notifications
- To schedule notifications with `UNTimeIntervalNotificationTrigger` (seconds) and UNCalendarNotificationTrigger (with DateComponents class)
- To create categories. Very similar to channels in Android.

## Challenges

Taken from [here](https://www.hackingwithswift.com/read/21/4):

>- [x] Update the code in `didReceive` so that it shows different instances of `UIAlertController` depending on which action identifier was passed in.
>- [x] For a harder challenge, add a second `UNNotificationAction` to the alarm category of project 21. Give it the title “Remind me later”, and make it call `scheduleLocal()` so that the same alert is shown in 24 hours. (For the purpose of these challenges, a time interval notification with 86400 seconds is good enough – that’s roughly how many seconds there are in a day, excluding summer time changes and leap seconds.)
>- [x] And for an even harder challenge, update [project 2](https://github.com/HenestrosaConH/100-days-of-swift/tree/main/Courses/02-GuessTheFlag) so that it reminds players to come back and play every day. This means scheduling a week of notifications ahead of time, each of which launch the app. When the app is finally launched, make sure you call `removeAllPendingNotificationRequests()` to clear any un-shown alerts, then make new alerts for future days.

## Screenshots

![Notification permission](./Screenshots/1.png)
![Notification](./Screenshots/2.png)
![Notification options](./Screenshots/3.png)
