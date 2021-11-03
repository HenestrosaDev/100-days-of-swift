# FireworksNight
Project 20 from the 100 Days of Swift Course https://www.hackingwithswift.com/100/70

## I've learnt...

- follow(). Makes the node move along the path specified as, in the case of the project, path.cgPath
- UIBezierPath for drawing curve trajectories.
- for case let <variable> as <dataType> in <iteratable> { ... } This means that, if the element inside the <iteratable> can be casted as <dataType>, we'll go into the loop
- Color blending
- Shake gesture. override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) { ... } at the ViewController class
        
        
## I have added the following features suggested by the instructor...

- For an easy challenge try adding a score label that updates as the player's score changes
- Make the game end after a certain number of launches. You will need to use the invalidate() method of Timer to stop it from repeating.
- Use the waitForDuration and removeFromParent actions in a sequence to make sure explosion particle emitters are removed from the game scene when they are finished.

## To do as a personal challenge...

- Add UserDefaults to store the max. score
