>Interface -> Storyboard
```
Storyboard is part of interface builder which is written in XML
The Interface builder editor helps to design full UI without writing any code. Simply drag and depo button , texfields.
```

### Short Summary
**SwiftUI (SFFTUI):** A modern, declarative framework for building cross-platform Apple app interfaces quickly, with built-in state management and real-time previews.

**Storyboard:** A visual, drag-and-drop editor for laying out UIKit-based interfaces with navigation flow visualization, better suited for established workflows and legacy projects.

>Change storyboard to SwiftUI
```
1)deleting main.storyboard
2)change storyboard name main to empty in info.plist
3)type main in runner and look for UIkit storyboard base name chnage its value to empty
4) configure sceneDelegate file so we work without storyboards

```
>SceneDelegate
```
It introduced in ios 13 focuses on managing the lifecycle and configuaration of multiple instances of UI within our app
```
>Window
```
rectangualar are where host represent app's content and having rootviewController to manages the content within window
```
# What is a Cocoa Touch Class?

A Cocoa Touch class is a custom class file created in Xcode for iOS, iPadOS, or tvOS app development. It usually inherits from a base class in the Cocoa Touch framework, such as `UIViewController`, `UIView`, or `UITableViewCell`. Developers use Cocoa Touch classes to create custom views, controllers, or models that integrate seamlessly with Apple's user interface and event-handling systems.

cmd+shift+A to switch bw dark and light mode emulator
