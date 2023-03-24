# Swift Strings

[Project 24](https://www.hackingwithswift.com/read/24/overview) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                                                                                                                                                                |
|:---------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [80](https://www.hackingwithswift.com/100/80) | <ul><li>[Setting up](https://www.hackingwithswift.com/read/24/1/setting-up)</li><li>[Strings are not arrays](https://www.hackingwithswift.com/read/24/2)</li><li>[Working with strings in Swift](https://www.hackingwithswift.com/read/24/3)</li><li>[Formatting strings with NSAttributedString](https://www.hackingwithswift.com/read/24/4)</li></ul> |
| [81](https://www.hackingwithswift.com/100/81) | <ul><li>[Wrap up](https://www.hackingwithswift.com/read/24/5)</li><li>[Review for Project 24: Swift Strings](https://www.hackingwithswift.com/review/hws/project-24-swift-strings)</li></ul>                                                                                                                                                            |

## I Have Learnt...

- Strings are different from arrays. Even though we can loop over them, we can’t read individual letters from the string (`name[3]` is incorrect).
- Useful extensions for Strings, such as `deletePrefix(_:)`, `deleteSuffix(_:)`, `capitalizeFirst`, containsAny(of:)
- `NSAttributedString` for formatting strings. 

## Challenges

Taken from [here](https://www.hackingwithswift.com/read/24/5):

>- [x] Create a `String` extension that adds a `withPrefix()` method. If the string already contains the prefix it should return itself; if it doesn’t contain the prefix, it should return itself with the prefix added. For example: `"pet".withPrefix("car")` should return “carpet”.
>- [x] Create a `String` extension that adds an `isNumeric` property that returns true if the string holds any sort of number. Tip: creating a `Double` from a `String` is a failable initializer.
>- [x] Create a `String` extension that adds a `lines` property that returns an array of all the lines in a string. So, “this\nis\na\ntest” should return an array with four elements.
