# Whack-a-Penguin

[Project 14](https://www.hackingwithswift.com/read/14/overview) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                                                                                                   |
|:---------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [55](https://www.hackingwithswift.com/100/55) | <ul><li>[Setting up](https://www.hackingwithswift.com/read/14/1/setting-up)</li><li>[Getting up and running: SKCropNode](https://www.hackingwithswift.com/read/14/2)</li><li>[Penguin, show thyself: SKAction moveBy(x:y:duration:)](https://www.hackingwithswift.com/read/14/3)</li></ul> |
| [56](https://www.hackingwithswift.com/100/56) | <ul><li>[Whack to win: SKAction sequences](https://www.hackingwithswift.com/read/14/4)</li><li>[Wrap up](https://www.hackingwithswift.com/read/14/5)</li><li>[Review for Project 14: Whack-a-Penguin](https://www.hackingwithswift.com/read/14/6)</li></ul>                                | 

## I Have Learnt...

- `SKCropNode`: Subclass of `SKNode` in the SpriteKit framework that allows you to mask a portion of a node's contents using a mask node. This can be useful for creating effects such as circular images or hiding parts of a node that you don't want to be visible.
- `SKTexture`: A class in the SpriteKit framework that represents an image or a region of an image that can be displayed by a `SKSpriteNode` or other SpriteKit node.
- `asyncAfter()`: `DispatchQueue` class method that allows you to schedule a closure to be executed on a specified dispatch queue after a specified amount of time.  
- New `SKAction` types such as `run()`, `wait(forDuration:)`, `moveBy(x:y:duration:)` and `playSoundFileNamed(_:waitForCompletion:)`. Remember that `SKAction` is a class in the SpriteKit framework that provides a way to perform actions on `SKNode` instances such as `SKSpriteNode` or `SKShapeNode`. 

## Challenges

Taken from [here](https://www.hackingwithswift.com/read/14/5):

>- [x] Record your own voice saying "Game over!" and have it play when the game ends.
>- [x] When showing “Game Over” add an `SKLabelNode` showing their final score.
>- [x] Use `SKEmitterNode` to create a smoke-like effect when penguins are hit, and a separate mud-like effect when they go into or come out of a hole. (This challenge needs some rework because when some penguins hide, the mud particle appears below the hole)

## To Do as a Personal Challenge...

- [ ] To add a max score with UserDefaults
- [ ] Difficulties
- [ ] Retry button
- [ ] Add **Try again** button when showing **Game Over**

## Screenshots

<div align="center">
  <img src="./Screenshots/1.png" alt="Main screen" width="490">
  <img src="./Screenshots/2.png" alt="Game over screen" width="490">
</div>
