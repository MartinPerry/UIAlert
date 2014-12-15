//
//  MyAlertMessage.h
//
//  Created by Martin Prantl on 14.12.14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum ButtonType
{
    BUTTON_OK,
    BUTTON_CANCEL,
    BUTTON_OTHER
    
} ButtonType;



@interface MyAlertMessage : NSObject

@property (readonly) NSMutableArray *buttons;
@property (readonly) NSInteger ID;

@property NSString *title;
@property NSString *message;

-(id)init;
-(id)initWithTitle:(NSString *)title WithMessage:(NSString *)msg;

-(void)addButton:(ButtonType)type WithTitle:(NSString *)title WithAction:(void (^)(void *action))handler;


-(void)show;

@end
