# Core Graphics

[Project 27](https://www.hackingwithswift.com/read/27/overview) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
|:---------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [88](https://www.hackingwithswift.com/100/88) | <ul><li>[Setting up](https://www.hackingwithswift.com/read/27/1/setting-up)</li><li>[Creating the sandbox](https://www.hackingwithswift.com/read/27/2)</li><li>[Drawing into a Core Graphics context with UIGraphicsImageRenderer](https://www.hackingwithswift.com/read/27/3)</li><li>[Ellipses and checkerboards](https://www.hackingwithswift.com/read/27/4)</li><li>[Transforms and lines](https://www.hackingwithswift.com/read/27/5)</li><li>[Images and text](https://www.hackingwithswift.com/read/27/6)</li></ul> |
| [89](https://www.hackingwithswift.com/100/89) | <ul><li>[Wrap up](https://www.hackingwithswift.com/read/27/7)</li><li>[Review for Project 27: Core Graphics](https://www.hackingwithswift.com/review/hws/project-27-core-graphics)</li></ul>                                                                                                                                                                                                                                                                                                                               |

## I've learnt...

- Core Graphics: Very similar to the HTML5 & JavaScript's Canvas API.  It is responsible for rendering and manipulating 2D graphics, including text, images, shapes, and colors. The framework is written in Objective-C and is part of Apple's Core Frameworks.
- Some common use cases of Core Graphics include drawing custom user interfaces, creating charts and graphs, rendering images, and generating PDF documents. Developers can use Core Graphics to create high-quality, high-performance graphics in their macOS and iOS applications.

## Challenges

Taken from [here](https://www.hackingwithswift.com/read/27/7):

>- [x] Pick any emoji and try creating it using Core Graphics. You should find some easy enough, but for a harder challenge you could also try something like the star emoji.
>- [x] Use a combination of `move(to:)` and `addLine(to:)` to create and stroke a path that spells **TWIN** on the canvas.
>- [x] Go back to [project 3](https://github.com/HenestrosaConH/100-days-of-swift/tree/main/Courses/03-SocialMedia) and change the way the selected image is shared so that it has some rendered text on top saying “From Storm Viewer”. This means reading the `size` property of the original image, creating a new canvas at that size, drawing the image in, then adding your text on top.

## Screenshots

![Figure](./Screenshots/1.png)
![Star (challenge 1)](./Screenshots/2.png)
![Twin text (challenge 2)](./Screenshots/3.png)