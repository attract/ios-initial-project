# AppSample
Project with lots of pre-installed libraries and frameworks for fast and simple project-up.

# Features
There are five categories of features in this project:
- managers;
- helpers;
- extensions;
- superclass for all view controllers with built-in funtions;
- other third-party libraries.

# Preinstalled managers
1. `RequestManager` is ready to use API-manager (uses `Alamofire` framework).
2. `ParserManager` and `ParseModel` are classes for parsing JSON into prebuild `RequestCompletion` data (SwiftyJSON framework is used).
3. `ReachabilityManager` is a class for checking network connection status. It allows to check internet connection before running network queries and let users to know if connection is down (uses `ReachabilitySwift` framework).

# Helpers
1. `DateTimeFormatter` is class for converting dates and times from `Date` object to `String` (for output) or `String` to `Date` for input. 
2. `ImageLoader` is powerfull cache system for images. It uses `SDWebImage` framework and allows saving images to cache and display when saving is complete in just one line of code (will be described in Extensions section). Once image is saved to cache it will always display from local storage.
3. `ProgressLoader` is class for showing loading indicators while some continues actions are running (i.e. network queries). It uses `SVProgressHUD` framework.
4. `Warnings` is a structure for proccessing errors. System `Error` objects are in different formats in different places. With our warnings structure all errors in app are always in same format, so it allows us to make universal error handlers.
5. `Alerter` is powerfull popup generator system. It uses `BulletinBoard` framework for displaying interactive messages with actions instead of system `UIAlertController`. Popups are made according to new iOS 11 guidelines and looks like AirPods connection card. 
6. `TapticEngine` class is made for awesome haptic feedback in response to some user's actions. It uses TapticEngine on iPhones 6s and higher. It works greate with `Alerter`.


# Extensions
What is Extension? It's addition to existing Swift classes, that allows to do more with system classes. Here is our extensions list with our additions:

1. `NSLayoutConstraint` extension allows to set constraint's multiplier programatically. By default, it can be changes in InterfaceBuilder only.
2. `NumberExtension` gives abbility to round float values to needed characters number after coma.
3. `StringExtension` implements lots of additions:
    - `localized` - returnes localized string value. Just call `myString.localized` instead of `NSLocalizedString(myString, tableName: tableName, bundle: Bundle.main, value: value, comment: comment)`;
    - `trimmed` - removes whitespaces from string. Just call `myString.trimmed` instead of `myString.trimmingCharacters(in: .whitespaces)`;
    - `substring` - cuts string to needed range;
    - `urlencoded` - returns url-encoded string. Just call 'myString.urlencoded' instead of 'myString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)';
    - `withoutHTMLTags` - removes all HTML-tags from string. Just call 'myString.withoutHTMLTags' instead of `myString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)`;
    - `getAttributedStringFromHTML` - function that allows to convert html-string to attributed string for displaying with needed attributes.
    - `+` allows easily concatanate to string or attributed strings. Just call `output = string1 + string2`;
    - `setAsLink` function sets as clickable link needed part of attribute string.
4. `UIColorExtension` brings support for next features:
    - initizlize color from hex-string;
    - create an image which is filled bu needed color.
5. `UIImageExtension` allows to do next things:
    - `rounded` allows easily create round image from regular. Just call `myImage.rounded`;
    - `imageWithCorrectOrientation` fixes invalid orientation in images which are made with system camera; 
    - `imageWithColor` filles non-filled parts of image with selected color.
6. `UIImageViewExtension` brings nexr cool features:
    - loading image from web and save it to cache, displaying this image from cache, make image round, display loading progress in just one single line of code: `myImageView.image(from: urlString, withPlaceholder: placeholderImage, isRounded: true, progressHandler: { // display progress if needed })`. Without this extension we have to write about 30 lines of code to make this;
    - make imageView round. In some cases we need to show round image, but we also need image in non-round state. With this extension we can make rounded just image container without rounding original image.
    - show and hide activity indicators on imageViews while images are loading from web.
7. `UINavigationControllerExtension` allows to add ability for adding handlers after view controller is pushed or poped. 
8. `UITableViewCellExtension` allows to add customized separators to UITableviewCell programaticaly.
9. `UITextFieldExtension` allows to set paddings to text fields.
10. `UIViewExtension` brings ability to customize some view's propertes dircetly from interface builder. They are `cornerRadius` (for making round corners), `borderWidth` and `borderColor`.
11. `UIDeviceExtension` allows to get current device model in readable mode. Needed for actions which are dependent from device model.

# BasicViewController: Superclass for all ViewControllers
All view controllers in app are subclassed from `BasicViewController`. Here is list of properies and functions which are already implemented in BasicViewController (and are available in all subclasses):
1. `ReachabilityManager` item.
2. `BulletinManager` item. Is used for popups.
3. `showAuthScreen` method allows direct navigation to authorization screen.
4. `logout` method erases all user data and calls `showAuthScreen`.
5. `showMainScreen` method navigates to root screen of app.
6. `showErrorScreen` method displays errors' messages. Uses `Alerter`.
7. `handleErrors` method processes all errors in application and shows relevant message to user. Uses `Alerter`.
8. `showApproriateAlert` method is used in form validators. It shows incorrectly filled field and sets focus to this field.
9. `Alerter` methods (all of them use `TapticEngine`):
    - `showSuccess` displays message about succesfully finished task;
    - `showWarning` displays warning message;
    - `showError` displays error message with "Retry" button;
    - `showCustom` displays fully customized popup with custom action handlers;
    - `showConfirm` displays confirm alert popup with two actions "Confirm" and "Cancel";
    - `showInfo` displays information message.
10. `makeTapticFeedback` uses `TapticEngine` and provides haptic feedback. Can use on of three presets:
    - success;
    - warning;
    - error.

As a result, all view controllers that are subclassed from BasicViewController are supporting all these features fully codeless.

# Other third-party libraries and frameworks
All third-party libraries are open-sourced.

In this list there are no frameworks which are used in managers, helpers and extension.
    - `DZNEmptyDataSet` allows to setup customizable views to empty lists;
    - `CCBottomRefreshControl`. Yes, by default iOS doesn't support infinity scrolling. With this framework we can implement this functionallity in our apps;
    - `SKPhotoBrowser` is a simple image viewer. I.e. it allows to view fullsize image after tapping on image thumbnail;
    - `Fabric` and `Crashlytics` allows to send beta versions to testers without TestFlight.

# Requres:
- `cocoapods` preinstalled

If you do not have cocoapods installed, then just run this command in terminal:
```sh
$ sudo gem install cocoapods
```

# How to start making project using AppSample:

 1. Open `AppSample.xcodeproj` in Xcode.
 2. Navigate to project settings.
 3. Change Name in all project's targets to needed.
 4. Change Bundle identifier to `com.new_app_name.ios.app`
 5. Close project.
 6. Open `terminal.app` and navigate to `.xcodeproj` directory
 
Now you need to init pods project in future workspace. Run this:
```sh
$ pod init
```
Once workspace is initialized, you need to install required pods. Run this:
```sh
$ open Podfile
```
Add next lines to your target section:

```
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
pod 'ReachabilitySwift'
pod 'DZNEmptyDataSet'
pod 'SDWebImage', '~>3.8'
pod 'CCBottomRefreshControl'
pod 'SKPhotoBrowser'
pod 'BRYXBanner'
pod 'SCLAlertView'
pod 'Fabric'
pod 'Crashlytics'
pod 'BulletinBoard', :git => 'https://github.com/alexaubry/BulletinBoard.git'
```

# Next steps

Close `terminal.app` and open `.xworkspace` file. That's all! Now your app has all needed features for comfortable development. Enjoy :)
