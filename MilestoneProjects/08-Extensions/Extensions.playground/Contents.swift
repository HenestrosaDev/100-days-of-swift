import UIKit

/**
 1. Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its
 size down to 0.0001 over a specified number of seconds.
 */
extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            }
        )
    }
}

let view = UIView()
view.bounceOut(duration: 5)

/**
 2. Extend Int with a times() method that runs a closure as many times as the number is high. For
 example, 5.times { print("Hello!") } will print “Hello” five times.
 */
extension Int {
    func times(closure: @escaping () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0 ..< self {
            closure()
        }
    }
}

var counter = 0
3.times { counter += 1 }
print("counter: \(counter)")
assert(counter == 3)


(-3).times {
    print("Nothing happens because it's lower than 0")
}

/**
 3. Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!
 */
extension Array {
    mutating func remove<T: Comparable>(item: T) {
        for (index, arrayItem) in self.enumerated() {
            if item == arrayItem as! T {
                self.remove(at: index)
                break
            }
        }
    }
}

/** Paul's solution:
 extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let location = self.firstIndex(of: item) {
            self.remove(at: location)
        }
    }
 }
 */

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
print(numbers)
assert(numbers == [1, 2, 4, 5])

var numbersWithDuplicate = [1, 2, 3, 4, 5, 4, 5]
numbersWithDuplicate.remove(item: 5)
print(numbersWithDuplicate)
assert(numbersWithDuplicate == [1, 2, 3, 4, 4, 5])

var itemNotInArray = [1, 2, 3]
itemNotInArray.remove(item: 6) // item not in unknownNumber
print(itemNotInArray)
assert(itemNotInArray == [1, 2, 3])
