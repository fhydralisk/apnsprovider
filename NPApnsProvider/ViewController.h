//
//  ViewController.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@class NPTokenContainer;

@interface ViewController : NSViewController <NPApnsClientDelegate>

@property (weak, nonatomic, readonly) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet NSScrollView *notifyView;
@property (weak, nonatomic) IBOutlet NSScrollView *statusView;
@property (weak, nonatomic) IBOutlet NSTextField  *labelCert;
@property (weak, nonatomic) IBOutlet NSPopUpButton *payloadTempPop;
@property (weak, nonatomic) IBOutlet NSScrollView *tokenSV;
@property (weak, nonatomic) IBOutlet NSPopUpButton *serverSelectPop;

@end


@interface ViewController (Actions)

//-(IBAction)listenClicked:(id)sender;
-(IBAction)connectClicked:(id)sender;
-(IBAction)notifyClicked:(id)sender;
-(IBAction)endClicked:(id)sender;
-(IBAction)chooseCertClicked:(id)sender;
-(IBAction)payloadTempSelected:(id)sender;
-(IBAction)removeTokenClicked:(id)sender;

@end

@interface ViewController (Methods)
-(void)addTextToStatus:(NSString *)text;
-(void)informTokenAddition:(NPTokenContainer *)container;

@end

