# Swifty Ninja

[Project 23](https://www.hackingwithswift.com/read/23/overview) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                                                                                                                                                                            |
|:---------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [77](https://www.hackingwithswift.com/100/77) | <ul><li>[Setting up](https://www.hackingwithswift.com/read/23/1/setting-up)</li><li>[Basics quick start: SKShapeNode](https://www.hackingwithswift.com/read/23/2)</li><li>[Shaping up for action: CGPath and UIBezierPath](https://www.hackingwithswift.com/read/23/3)</li><li>[Enemy or bomb: AVAudioPlayer](https://www.hackingwithswift.com/read/23/4)</li></ul> |
| [78](https://www.hackingwithswift.com/100/78) | <ul><li>[Follow the sequence](https://www.hackingwithswift.com/read/23/5)</li><li>[Slice to win](https://www.hackingwithswift.com/read/23/6)</li><li>[Game over, man: SKTexture](https://www.hackingwithswift.com/read/23/7)</li></ul>                                                                                                                              |
| [79](https://www.hackingwithswift.com/100/79) | <ul><li>[Wrap up](https://www.hackingwithswift.com/read/23/8)</li><li>[Review for Project 23: Swifty Ninja](https://www.hackingwithswift.com/review/hws/project-23-swifty-ninja)</li></ul>                                                                                                                                                                          |

## I Have Learnt...

- `SKShapeNode`: Creates onscreen graphical elements from mathematical points, lines, and curves
- `AVAudioPlayer`: Class in the AVFoundation framework that provides an easy way to play audio in an iOS or macOS app.
- `physicsWorld.speed`: Scene's physics speed.
- `CaseIterable` protocol: Provides a way to get a collection of all the cases in an enumeration. The protocol requires that conforming enumerations provide a static `allCases` property that returns a collection of the enumeration's cases.
- `removeFirst()`: Method available on mutable collections in Swift that removes and returns the first element of the collection.
- Action groups: A way to group multiple `UIAction` objects together in iOS. They are represented by the `UIActionGroup` class and provide a way to organize related actions together in a compact and visually appealing way. 

## Challenges

Taken from [here](https://www.hackingwithswift.com/read/23/8):

>- [ ] Try removing the magic numbers in the createEnemy() method. Instead, define them as constant properties of your class, giving them useful names.
>- [x] Create a new, fast-moving type of enemy that awards the player bonus points if they hit it.
>- [x] Add a “Game over” sprite node to the game scene when the player loses all their lives.

## To Do as a Personal Challenge...

- [x] To add **New Game** button
- [x] To refactor the project

## Screenshots

<div align="center">
  <img src="./Screenshots/1.png" alt="Main screen" width="490">
  <img src="./Screenshots/2.png" alt="Game over screen" width="490">
</div>
