# 7SwiftyWords

Project 7 from the 100 Days of Swift Course https://hackingwithswift/100/33

I've learnt...
- didSet() use case.
- enumerated(). Turns an array into a map. ID is the position and the value is the content.
- Array's method joined() 
- replacingOcurrences(). Same as replace() in Java
- Auto Layout fully in code

I have added the following features suggested by the instructor...

- Use the techniques you learned in project 2 to draw a thin gray line around the buttons view, to make it stand out from the rest of the UI.
- If the user enters an incorrect guess, show an alert telling them they are wrong. You’ll need to extend the submitTapped() method so that if firstIndex(of:) failed to find the guess you show the alert.
- Try making the game also deduct points if the player makes an incorrect guess. Think about how you can move to the next level – we can’t use a simple division remainder on the player’s score any more, because they might have lost some points.
- (Day 58) Make the letter group buttons fade out when they are tapped. We were using isHidden property, but you'll need to switch to alpha because isHidden is either true or false, it has no animatable values between.

To do as a personal challenge...
- Add more files
