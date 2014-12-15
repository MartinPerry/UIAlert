# UIAlert 1.0

Simple UIAlert Objective-C class for iOS using UIAlertView (iOS &lt;= 7) or UIAlertViewController (iOS >= 8).

##Some implementation info

Because of ARC and usage of inner action blocks for `UIAlertView`, ARC removed created message after calling `show`. To prevent removing this, private singleton class `AlertManager` is used, that holds references to all created messages until they are closed by clicking on button in them. This class also generates uniques ID for every message.

Second private class is called `MyButton` and holds info for every added button.

UIAlert class is very simple and try to cover only basic funcionality from `UIAlertView`. `UIAlertViewController` is much more flexible - see for example [http://nshipster.com/uialertcontroller/](http://nshipster.com/uialertcontroller/) (only in Swift)


## Installation

Just copy `UIAlert/MyAlertMessage.m` and `UIAlert/ MyAlertMessage.h` to your project

## Usage and example

    MyAlertMessage * a = [[MyAlertMessage alloc] initWithTitle:@"Hello" WithMessage:@"World"];
    
    [a addButton:BUTTON_OK WithTitle:@"OK" WithAction:^(void *action) {
            NSLog(@"Button OK at index 0 click");
    }];

    [a addButton:BUTTON_CANCEL WithTitle:@"Cancel" WithAction:^(void *action) {
            NSLog(@"Button Cancel at index 1 click");
    }];
 
    [a show];
 
There are 3 types of Button:
- `BUTTON_CANCEL` - special functionality when addind to alert
- `BUTTON_OK`
- `BUTTON_OTHER`
 
OK and OTHER are currently same
 
On iOS8 `^(void *action) {}` action can be cast to `UIAlertAction *` in action block.
