# GuessTheFlag
Project 2 from the 100 Days of Swift course https://www.hackingwithswift.com/100/19

## I've learnt...
- The differences between @2x (the points unit are multiply by 2 on retina screens) and @3x (the points unit are multiply by 3 on HD retina screens)
- Asset catalogs (drop the files into the Assets folder, just like that)
- Handling of UIButton
- CALayer manages the UIKit. It's the core animation type responsible for managing the way your view looks. It sits below all our UI views.
- UIColor. Note: For example, we can't put UIColor.lightGray property directly into our border color property because it belongs to CALayer, which doesn't know where UI color is. That's why we convert it into a cgColor.
- Randomize in Swift
- UIAlertController, the same as AlertDialog in Android
- Actions, buttons that we add to the AlertController. Same as positive/negative buttons in AlertDialog.

## I have added the following features suggested by the instructor...

- Try showing the player's score in the navigation bar, alongside the flag to guess
- Keep track of how many questions have been asked, and show one final alert after they have answered 10
- When someone chooses the wrong flag, tell them their mistake in your alert
- (Day 49) Modify the project so that it saves the player’s highest score, and shows a special message if their new score beat the previous high score.
- (Day 73) And for an even harder challenge, update project 2 so that it reminds players to come back and play every day. This means scheduling a week of notifications ahead of time, each of which launch the app. When the app is finally launched, make sure you call removeAllPendingNotificationRequests() to clear any un-shown alerts, then make new alerts for future days.

## To do as a personal challenge...
- Add more flags
- Stylize the layout
- Add settings such as timer and a score goal
