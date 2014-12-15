UIAlert 1.0
============

Simple UIAlert for iOS using UIAlertView (iOS &lt;= 7) or UIAlertViewController (iOS >= 8) 

Basic usage:

MyAlertMessage * a = [[MyAlertMessage alloc] initWithTitle:@"Hello" WithMessage:@"World"];
    
[a addButton:BUTTON_OK WithTitle:@"OK" WithAction:^(void *action) {
        NSLog(@"Button OK at index 0 click");
}];

[a addButton:BUTTON_CANCEL WithTitle:@"Cancel" WithAction:^(void *action) {
        NSLog(@"Button Cancel at index 1 click");
 }];
 
 [a show];
 
 There are 3 types of Button:
 BUTTON_CANCEL - special functionality when addind to alert
 BUTTON_OK
 BUTTON_OTHER
 
 OK and OTHER are currently same
 
 On iOS8 ^(void *action) {} action can be cast to UIAlertAction * in action block.
