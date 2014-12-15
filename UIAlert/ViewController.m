//
//  ViewController.m
//  UIAlert
//
//  Created by Martin Prantl on 15.12.14.
//  Copyright (c) 2014 perrysoft. All rights reserved.
//

#import "ViewController.h"

#import "MyAlertMessage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Here you can see test usage
- (IBAction)testButton:(id)sender {
    MyAlertMessage * a = [[MyAlertMessage alloc] initWithTitle:@"Hello" WithMessage:@"World"];
    
    [a addButton:BUTTON_OK WithTitle:@"OK" WithAction:^(void *action) {
        NSLog(@"Button OK at index 0 click");
    }];
    [a addButton:BUTTON_CANCEL WithTitle:@"Cancel" WithAction:^(void *action) {
        NSLog(@"Button Cancel at index 1 click");
    }];
    [a show];
}
@end
