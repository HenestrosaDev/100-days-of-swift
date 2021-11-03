# WordScramble
Project 5 from the 100 Days of Swift Course https://hackingwithswift/100/26

## I've learnt...

- Reloading table views
- Inserting rows
- Text input in alerts
- Strings and UTF-16
- Closures
- NSRange

## I have added the following features suggested by the instructor...

- Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into isReal() that returns false if the word length is under three letters. For the second part, just compare the start word against their input word and return false if they are the same.
- Refactor all the else statements we just added so that they call a new method called showErrorMessage(). This should accept an error message and a title, and do all the UIAlertController work from there.
- Add a left bar button item that calls startGame(), so users can restart with a new word whenever they want to.
- Bonus: Once you’ve done those three, there’s a really subtle bug in our game and I’d like you to try finding and fixing it.
