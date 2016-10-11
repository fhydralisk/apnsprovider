//
//  PayloadController.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/29.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PayloadController : NSViewController

@property (weak,nonatomic) IBOutlet NSTabView *tabView;

@property (weak,nonatomic) IBOutlet NSButton *titleCheck;
@property (weak,nonatomic) IBOutlet NSButton *contentCheck;
@property (weak,nonatomic) IBOutlet NSButton *badgeCheck;
@property (weak,nonatomic) IBOutlet NSButton *soundCheck;
@property (weak,nonatomic) IBOutlet NSButton *contentAvaliableCheck;

@property (weak,nonatomic) IBOutlet NSTextField *titleText;
@property (weak,nonatomic) IBOutlet NSTextField *contentText;
@property (weak,nonatomic) IBOutlet NSTextField *badgeText;
@property (weak,nonatomic) IBOutlet NSTextField *soundText;

@property (weak,nonatomic) IBOutlet NSScrollView *rawTextScrollView;

@property NSString *string;

-(IBAction)convertToRaw:(id)sender;
-(IBAction)convertToConvenient:(id)sender;
-(IBAction)typeText:(id)sender;

@end
