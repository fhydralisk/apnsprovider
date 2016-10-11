//
//  TokenController.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NopqzipLib/NopqzipLib.h>
#import "NPTokenContainer.h"
//#import "NPMyTCPServerEngine.h"
#define TOKEN_CONTAINER @"TokenContainer"

extern NSString *TokenAddComplete;

@interface TokenController : NSViewController <NSTextFieldDelegate, NPServerDelegate>

//@property (readonly, nonatomic) NPTokenContainer* tokenContainer;

// Outlets
@property (weak, nonatomic) IBOutlet NSScrollView *tokenSV;
@property (weak, nonatomic) IBOutlet NSTextField *tokenText;
@property (weak, nonatomic) IBOutlet NSTextField *hintLabel;
@property (weak, nonatomic) IBOutlet NSProgressIndicator *hintListening;
@property (weak, nonatomic) IBOutlet NSTextField *hintListeningNA;
@property (weak, nonatomic) IBOutlet NSTextField *hintPort;



@end

@interface TokenController (Actions)

//actions
-(IBAction)addClicked:(id)sender;
-(IBAction)selectFileClicked:(id)sender;
-(IBAction)confirmClicked:(id)sender;
-(IBAction)removeClicked:(id)sender;
-(IBAction)abortClicked:(id)sender;
-(IBAction)showAddressClicked:(id)sender;

@end

@interface TokenController (Methods)


@end
