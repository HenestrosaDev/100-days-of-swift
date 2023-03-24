# Marble Maze

[Project 26](https://www.hackingwithswift.com/read/26/overview) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

Portal assets under [CC0 License](https://creativecommons.org/publicdomain/zero/1.0/legalcode) thanks to [Mumu](https://opengameart.org/content/shiny-orbs-64x64).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                           |
|:---------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [85](https://www.hackingwithswift.com/100/85) | <ul><li>[Setting up](https://www.hackingwithswift.com/read/26/1/setting-up)</li><li>[Loading a level: categoryBitMask, collisionBitMask, contactTestBitMask](https://www.hackingwithswift.com/read/26/2)</li></ul> |
| [86](https://www.hackingwithswift.com/100/86) | <ul><li>[Tilt to move: CMMotionManager](https://www.hackingwithswift.com/read/26/3)</li><li>[Contacting but not colliding](https://www.hackingwithswift.com/read/26/4)</li></ul>                                   |
| [87](https://www.hackingwithswift.com/100/87) | <ul><li>[Wrap up](https://www.hackingwithswift.com/read/26/5)</li><li>[Review for Project 26: Marble Maze](https://www.hackingwithswift.com/review/hws/project-26-marble-maze)</li></ul>                           |

## I Have Learnt...

- Core Motion: Framework provided by Apple that enables you to access the motion and environmental sensors on an iOS device. The framework provides access to a range of sensors, including the accelerometer, gyroscope, magnetometer, and barometer. With Core Motion, you can track the movement and orientation of the device, as well as measure the ambient pressure and relative altitude. Used in this project to get the input of the accelerometer

## Challenges

Taken from [here](https://www.hackingwithswift.com/read/25/5):

**Note**: I have taken [this repository](https://github.com/clarknt/100-days-of-swift/blob/main/34-Project26/README.md) by GitHub user [clarknt](https://github.com/clarknt) as a reference to complete the 3rd challenge.

>- [x] Rewrite the `loadLevel()` method so that it's made up of multiple smaller methods. This will make your code easier to read and easier to maintain, or at least it should do if you do a good job!
>- [x] When the player finally makes it to the finish marker, nothing happens. What should happen? Well, that's down to you now. You could easily design several new levels and have them progress through.
>- [x] Add a new block type, such as a teleport that moves the player from one teleport point to the other. Add a new letter type in `loadLevel()`, add another collision type to our enum, then see what you can do.

## To Do as a Personal Challenge...

- [ ] Add a menu
- [ ] Add even more levels
- [ ] Save score to `UserDefaults`
- [ ] Make an Android version

## Screenshots

<div align="center">
  <img src="./Screenshots/1.png" alt="Level 1" width="490">
  <img src="./Screenshots/2.png" alt="Level 2" width="490">
</div>

<div align="center">
  <img src="./Screenshots/3.png" alt="Level 3" width="490">
  <img src="./Screenshots/4.png" alt="Level 4" width="490">
</div>

<img src="./Screenshots/5.png" alt="Level 5" width="490">
