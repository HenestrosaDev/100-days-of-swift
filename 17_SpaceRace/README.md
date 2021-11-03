# SpaceRace
Project 17 from the 100 Days of Swift Course www.hackingwithswift/100/62

I've learnt...
- Per-pixel collision detection (SKPhysicsBody(texture:)). Gets pixel-perfect physics. This is computanionally expensive, so it should be used only when strictly needed.
- Advancing particle systems (advanceSimulationTime(seconds))
- Timer
- Linear and angular damping (friction simulator)

I have added the following features suggested by the instructor...

- Stop the player from cheating by lifting their finger and tapping elsewhere – try implementing touchesEnded() to make it work.
- Make the timer start at one second, but then after 20 enemies have been made subtract 0.1 seconds from it so it’s triggered every 0.9 seconds. After making 20 more, subtract another 0.1, and so on. Note: you should call invalidate() on gameTimer before giving it a new value, otherwise you end up with multiple timers.
- Stop creating space debris after the player has died.

To do as a personal challenge...

- [DONE] Add Game Over sprite 
- Add "Try again" button
- Add max. score with UserDefaults
