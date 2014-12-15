//
//  MyAlertMessage.m
//
//  Created by Martin Perry on 14.12.14.
//
// Source:
// http://www.doubleencore.com/2014/08/uialertcontroller-ios-8/
// http://ashfurrow.com/blog/uialertviewcontroller-example/
// http://nshipster.com/uialertcontroller/
//


#import "MyAlertMessage.h"

//=============================================================================
//============ "Structure" for single button (private class)  =================
//=============================================================================

@interface MyButton : NSObject
    @property (nonatomic,strong) NSString *title;
    @property ButtonType type;
    @property (nonatomic,strong) void (^actionHandler)(void *);
@end


@implementation MyButton
@end

//=============================================================================
//==================== Alert manager (private class) ==========================
//=============================================================================

//
// This class holds references to opened alerts
// It means, that those alerts are not destroyed by ARC
// until they are dismissed by user - click on button
// This class is singleton - life for whole app lifetime
// Generate unique ID for each Alert
//

@interface AlertManager : NSObject<UIAlertViewDelegate>

+(id)SharedManager;

+(NSInteger)nextIndex;

+(void)AddMyAlertMessage:(MyAlertMessage *)msg;

+(void)RemoveMyAlertMessage:(MyAlertMessage *)msg;

@end


@implementation AlertManager
{
    NSInteger _nextMsgIndex;
    NSMutableDictionary *_msgs;
}

//
// @public static
// static method to obtain singleton instance
//
+(id)SharedManager
{
    static AlertManager *sharedSingletonAlert = nil;
    @synchronized(self)
    {
        if(sharedSingletonAlert == nil)
        {
            sharedSingletonAlert = [[AlertManager alloc] init];
        }
    }
    return sharedSingletonAlert;
}

//
//
//
-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _msgs = [[NSMutableDictionary alloc] init];
        _nextMsgIndex = 0;
    }
    
    return self;
}

//
//
//
+(NSInteger)nextIndex
{
    AlertManager *m = [AlertManager SharedManager];

    
    NSInteger i = m->_nextMsgIndex;
    m->_nextMsgIndex++;
    return i;
}

//
//
//
//
+(void)AddMyAlertMessage:(MyAlertMessage *)msg
{
    AlertManager *m = [AlertManager SharedManager];
    
    [m->_msgs setObject:msg forKey:[NSNumber numberWithInteger:msg.ID]];
}

//
//
//
//
+(void)RemoveMyAlertMessage:(MyAlertMessage *)msg
{
    AlertManager *m = [AlertManager SharedManager];
    
    NSNumber *index = [NSNumber numberWithInteger:msg.ID];
    
    [m->_msgs removeObjectForKey:index];
}


//
//
//
//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSNumber *index = [NSNumber numberWithInteger:alertView.tag];
    
    MyAlertMessage *msg = [_msgs objectForKey:index];
    
    NSMutableArray *buttons = [msg buttons];
    MyButton *btn = [buttons objectAtIndex:buttonIndex];
    
    btn.actionHandler(NULL);
    
    [AlertManager RemoveMyAlertMessage:msg];
}

//
//
//
//
-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSNumber *index = [NSNumber numberWithInteger:alertView.tag];
    
    MyAlertMessage *msg = [_msgs objectForKey:index];
    
    //NSMutableArray *buttons = [(MyAlertMessage *)[_msgs objectForKey:index] buttons];
    //MyButton *btn = [buttons objectAtIndex:buttonIndex];
    
    //btn.actionHandler(NULL);
    
    [AlertManager RemoveMyAlertMessage:msg];
}

@end

//=============================================================================
//================== Alert message itself (public class) ======================
//=============================================================================

@interface MyAlertMessage ()

-(void)show7;
-(void)show8;

@end


@implementation MyAlertMessage
{
}


//
//
//
//
-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _buttons = [[NSMutableArray alloc] init];
        _title = @"";
        _message = @"";
        _ID = [AlertManager nextIndex];
    }
    
    return self;
}

//
//
//
//
-(id)initWithTitle:(NSString *)title WithMessage:(NSString *)msg
{
    self = [super init];
    if (self != nil)
    {
        _buttons = [[NSMutableArray alloc] init];
        
        _title = title;
        _message = msg;
        _ID = [AlertManager nextIndex];
    }
    
    return self;
}

//=============================================================================

//
//
//
//
-(void)addButton:(ButtonType)type WithTitle:(NSString *)title WithAction:(void (^)(void *action))handler
{
    MyButton *btn = [[MyButton alloc] init];
    
    btn.title = title;
    btn.type = type;
    btn.actionHandler = handler;
    
    [_buttons addObject:btn];
    
    /*
    void (^actionHandler)(void *);
    
    actionHandler((UIAlertAction *)NULL);
    
    UIAlertAction *btnAction = [UIAlertAction actionWithTitle:@"Kick through door" style:UIAlertActionStyleDestructive handler:
                                ^(UIAlertAction *action) {
                                    handler((__bridge void *)action);
                                }
                            ];
    */
    
}


//=============================================================================







//
//
//
-(void)show
{

    if (NSClassFromString(@"UIAlertController") != nil)
    {
        [self show8];
    }
    else
    {
        [self show7];
    }
}

-(void)show8
{
    //iOS >= 8
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_title
                                                                  message:_message
                                                                  preferredStyle:UIAlertControllerStyleAlert];

    
    [AlertManager AddMyAlertMessage:self]; //this is "useless", but we use it to keep same logic as for iOS7
    
    for (MyButton *btn in _buttons)
    {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        
        if (btn.type == BUTTON_CANCEL) style = UIAlertActionStyleCancel;
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:btn.title style:style handler:^(UIAlertAction *action) {
            btn.actionHandler((__bridge void *)(action));
            [AlertManager RemoveMyAlertMessage:self];   //this is "useless", but we use it to keep same logic as for iOS7
        }];
        
        [alertController addAction:alertAction];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        #ifdef TARGET_IS_EXTENSION
        
        #else
            UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
            [top presentViewController:alertController animated:YES completion:nil];
        #endif
    });
    
}


-(void)show7
{
#ifndef TARGET_IS_EXTENSION
    //iOS <= 7
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_title
                                                        message:_message
                                                       delegate:[AlertManager SharedManager]
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    
    alertView.tag = _ID;
    
    [AlertManager AddMyAlertMessage:self];
    
    
    for (MyButton *btn in _buttons)
    {
        if (btn.type == BUTTON_CANCEL)
        {
            [alertView setCancelButtonIndex:[alertView addButtonWithTitle:btn.title]];
        }
        else
        {
            [alertView addButtonWithTitle:btn.title];
        }
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [alertView show];
    });
#endif

}




@end
