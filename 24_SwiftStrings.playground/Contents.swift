import UIKit


// 1. Strings are not arrays

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

// stores the 4th letter of the name
let letter = name[3]
let letter2 = name[name.index(name.startIndex, offsetBy: 3)] // same as line above

extension String {
    // subscript is a shortcut to elements of a collection, list, or sequence. i.e. var array = ["Antoine", "Jaap", "Lady"]; print(array[0]); The subscript always goes between []
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

// 2. Working with strings in Swift

let password = "12345"
password.hasPrefix("123")
password.hasPrefix("456")

extension String {
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

let weather = "it's going to rain"
print(weather.capitalized)
print(weather.uppercased())
print(weather.capitalizeFirst)

extension String {
    /**
     Capitalizes first letter
     */
    var capitalizeFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

// This has the same functionality as containsAny().
input.containsAny(of: languages)
languages.contains(where: input.contains)


// 3. Formatting strings with NSAttributedString

let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

// Adding multiple attributes to the same string

let string2 = "This is a test string"
let attributedString2 = NSMutableAttributedString(string: string)

attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.link, value: "https://www.hackingwithswift.com", range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
attributedString2.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 15, length: 6))


// Challenge 1 of instructor

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.contains(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

print("men".withPrefix("car"), terminator: "")


// Challenge 2 of instructor

extension String {
    var isNumeric: Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[A-Za-zÑñ ]+$")
        if regex.firstMatch(in: self, options: [], range: range) != nil {
            return false
        } else {
            return true
        }
    }
}

print("be lkmlkÑñ9ml mfyes".isNumeric, terminator: "")



// Challenge 3 of the instructor

extension String {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

print("this\nis\na\ntest".lines)
