# Photo Captions

[Milestone project 8](https://www.hackingwithswift.com/guide/9/1) from the [100 Days of Swift course](https://www.hackingwithswift.com/100) by [Hacking With Swift](https://www.hackingwithswift.com/).

## Contents

|                      Day                      | Contents                                                                                                                                                                                                          |
|:---------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [82](https://www.hackingwithswift.com/100/81) | <ul><li>[What you learned](https://www.hackingwithswift.com/guide/9/1)</li><li>[Key points](https://www.hackingwithswift.com/guide/9/2)</li><li>[Challenge](https://www.hackingwithswift.com/guide/9/3)</li></ul> |

## Challenge Instructions

*Instructions taken from [here](https://www.hackingwithswift.com/guide/9/3).*

>Your challenge this time is not to build a project from scratch. Instead, I want you to implement three Swift language extensions using what you learned in project 24. I’ve ordered them easy to hard, so you should work your way from first to last if you want to make your life easy!
>
>Here are the extensions I’d like you to implement:
>
>1. Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.
>2. Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.
>3. Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!
>
>As per usual, please try and complete this challenge yourself before you read my hints below. And again, don’t worry if you find this challenge challenging – the clue is in the name, these are designed to make you think!
> 
>Here are some hints in case you hit problems:
>1. Animation timings are specified using a TimeInterval, which is really just a Double behind the scenes. You should specify your method as bounceOut(duration: TimeInterval).
>2. If you’ve forgotten how to scale a view, look up CGAffineTransform in project 15.
>3. To add times() you’ll need to make a method that accepts a closure, and that closure should accept no parameters and return nothing: () -> Void.
>4. Inside times() you should make a loop that references self as the upper end of a range – that’s the value of the integer you’re working with.
>5. Integers can be negative. What happens if someone writes let count = -5 then uses count.times { … } and how can you make that better?
>6. When it comes to implementing the remove(item:) method, make sure you constrain your extension like this: extension Array where Element: Comparable.
>7. You can implement remove(item:) using a call to firstIndex(of:) then remove(at:).
>
>Those hints ought to be enough for you to solve the complete challenge, but if you still hit problems then read over my solutions below, or put this all into a playground to see it in action.
>```Swift
>import UIKit
>
>// extension 1: animate out a UIView
>extension UIView {
>    func bounceOut(duration: TimeInterval) {
>        UIView.animate(withDuration: duration) { [unowned self] in
>            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
>        }
>    }
>}
>
>// extension 2: create a times() method for integers
>extension Int {
>    func times(_ closure: () -> Void) {
>        guard self > 0 else { return }
>
>        for _ in 0 ..< self {
>            closure()
>        }
>    }
>}    
>
>// extension 3: remove an item from an array
>extension Array where Element: Comparable {
>    mutating func remove(item: Element) {
>        if let location = self.firstIndex(of: item) {
>            self.remove(at: location)
>        }
>    }
>}
>
>// some test code to make sure everything works
>let view = UIView()
>view.bounceOut(duration: 3)
>
>5.times { print("Hello") }
>
>var numbers = [1, 2, 3, 4, 5]
>numbers.remove(item: 3)
>```
>