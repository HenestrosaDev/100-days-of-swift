# StormViewer
Project 1 and 3 from the 100 Days of Swift course https://www.hackingwithswift.com/100/16

## I've learnt...

<details>
<summary>As project 1</summary>
</br>
- App bundles .apk in Android and .app in iOS. They both have the resources and the code of our application ready to use for the user.</br>
- FileManager</br>
- Typecasting (using the "as" keyword, same as Kotlin)</br>
- View controllers</br>
- Storyboards</br>
- Outlets (property that is annotated with the symbol IBOutlet and whose value you can set graphically in a nib file or a storyboard.  @IBOutlet has no special meaning other than "this is connected to something in Interface Builder.)</br>
- Auto layout</br>
- UIImageView</br>
- Navigation bars, which are the equivalent of Action Bars in Android</br>
- Navigation controllers manage a stack of view controllers that can be pushed by us. This view controller stack is what gives us the smooth sliding in and out animation.</br>
- The use of try! to avoid catching the exception in case that we are completely sure that it won't trigger an exception</br>
</details>

<details>
<summary>As project 3</summary>
</br>
- UIBarBottomItem. I.e. navigationItem.rightBarButtonItem</br>
- UIActivityViewController. The same as a sharing Intent in Android.</br>
- Info.plist. Similar to the AndroidManifest. In this case, I used it to add the Privacy permission for being able to store an image in the photo library</br>
- Saving an image as a jpeg.</br>
</details>

## I have added the following features suggested by the instructor...

<details>
<summary>As project 1</summary>
</br>
- Use Interface Builder to select the text label inside your table view and adjust its size to something larger</br>
- In your main table view, show the image names in sorted order, so "nssl0033.jpg" comes before "nssl0034.jpg".</br>
- Rather than show image names in the detail title bar, show "Picture X of Y", where Y is the total number of images and X is the picture's position in the array.</br>
- Add a right bar button item that to the main view controller that recommends the app</br>
</details>

<details>
<summary>As project 3</summary>
</br>
- Add the image name to your shared items. activityItems is an array - you can add strings and other things freely
</details>

<details>
<summary>As for both</summary>
</br>
- (Day 40) Loading the list of NSSL images from our bundle in the background.</br>
- (Day 49) Modify the project so that it remembers how many times each storm image was shown – you don’t need to show it anywhere, but you’re welcome to try modifying your original copy of project 1 to show the view count as a subtitle below each image name in the table view.</br>
</details>

## To do as a personal challenge...

- Nothing for now
