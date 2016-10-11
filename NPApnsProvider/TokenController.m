//
//  TokenController.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//
#import "NPMacro.h"
#import "TokenController.h"
#import "NPTokenContainer.h"
#import "NPTokenTableSource.h"
#import "AppDelegate.h"
#import "NPTokenPacket.h"
//#import "NPMyTCPServerEngine.h"
NSString *TokenAddComplete = @"NPTokenAdded";

@interface TokenController ()
{
    NPTokenContainer *tokenContainer;
    NPTokenTableSource *tokenTableSource;
    NPTCPServerEngine *serverEngine;
}

@end

@implementation TokenController

-(void)dealloc
{
    //NPLog(@"tockencontroller dealloc");
    [serverEngine stopListen];
    [serverEngine disconnectAll];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NPLog(@"%d",nil==[self.view window]);
    
    [self doInitTokenTable];
    
    //[self.view.window setStyleMask: [[self.view window] styleMask] & ~NSResizableWindowMask];
    //self.preferredMaximumSize=self.view.frame.size;
    self.preferredContentSize=self.view.frame.size;
    _tokenText.delegate=self;
    _hintLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"%luc left",@"hint label"),(unsigned long)TOKEN_LENGTH*2];
    serverEngine=[[NPTCPServerEngine alloc] initWithPort:SERVER_PORT];
    [serverEngine setDelegate:self];
    [serverEngine setPacketClass:[NPTokenPacket class]];
    
    if ([serverEngine startListen]) {
        [_hintListening startAnimation:self];
        _hintListeningNA.stringValue=@"";
    } else {
        _hintListeningNA.stringValue=@"N/A";
    }
    
    _hintPort.stringValue=[NSString stringWithFormat:
                           NSLocalizedString(@"Your device should connect to this application on port %d.",@"hint port"),SERVER_PORT];
    // Do view setup here.
}

-(void)doInitTokenTable
{
    tokenTableSource=[NPTokenTableSource new];
    tokenContainer=[NPTokenContainer new];
    //[tokenContainer loadFromPlist:TOKENSTORENAME];
    
    tokenTableSource.theContainer=tokenContainer;
    tokenTableSource.nameEditable=YES;
    
    [tokenTableSource rebuildTableView:_tokenSV.contentView.documentView];

}

-(void)controlTextDidChange:(NSNotification *)obj{
    if (_tokenText.stringValue.length>TOKEN_LENGTH*2) {
        [[NSSound soundNamed:@"Ping"]play];
        _tokenText.stringValue=[_tokenText.stringValue substringToIndex:TOKEN_LENGTH*2];
        return;
    }
    if (_tokenText.stringValue.length==TOKEN_LENGTH*2)
    {
        for (int i=0; i<TOKEN_LENGTH*2; i++) {
            //unichar c=[[_tokenText.stringValue uppercaseString] characterAtIndex:i];
            
            if ([self convertToken:_tokenText.stringValue]==nil) {
                _hintLabel.textColor=[NSColor redColor];
                _hintLabel.stringValue=NSLocalizedString(@"Failed",@"f");
                return;
            }
        }
        _hintLabel.textColor=[NSColor greenColor];
        _hintLabel.stringValue=NSLocalizedString(@"Passed",@"p");
        return;
        
    }
    _hintLabel.textColor=[NSColor textColor];
    _hintLabel.stringValue=[NSString stringWithFormat:NSLocalizedString(@"%luc left",@"hint label"),TOKEN_LENGTH*2-_tokenText.stringValue.length];
}

-(NSData *)convertToken:(NSString *)stringToken
{
    if (stringToken.length!=TOKEN_LENGTH*2) {
        return nil;
    }
    unsigned char *tokenDataBuf=malloc(TOKEN_LENGTH);
    memset(tokenDataBuf, 0, TOKEN_LENGTH);

    for (int i=0; i<TOKEN_LENGTH*2; i++) {
        unichar c=[[stringToken uppercaseString] characterAtIndex:i];
        unsigned char conv;
        if (c>='0' && c<='9') {
            conv=c-'0';
        } else if (c>='A' && c<='F') {
            conv=c-'A'+10;
        } else {
            free(tokenDataBuf);
            return nil;
        }
        
        
        if (i%2==0) {
            tokenDataBuf[i/2]=conv<<4;
        } else {
            tokenDataBuf[i/2]+=conv;
        }
    }
    
    NSData *tokenData=[NSData dataWithBytesNoCopy:tokenDataBuf length:TOKEN_LENGTH];
    return tokenData;
}
// server Engine delegate
-(void)serverEngine:(NPTCPServerEngine *)sEngine client:(NPTCPServerClient *)client didReceivePacket:(NPPacket *)packet
{
    [sEngine disconnectClient:client];
    if ([[packet data]length]!=TOKEN_LENGTH) {
        NSAlert *alert=[NSAlert new];
        alert.informativeText=NSLocalizedString(@"Please send a valid token", @"token");
        alert.messageText=NSLocalizedString(@"Token sent via network is invalid", @"token");
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    [[packet data] writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"lastTokenData.token"]  atomically:NO];
    [tokenContainer addToken:[packet data]];
    [_tokenSV.contentView.documentView reloadData];
}

-(void)serverEngine:(NPTCPServerEngine *)serverEngine clientDidConnect:(NPTCPServerClient *)client
{
    NPLog(@"client connect");
}

@end

@implementation TokenController (Actions)

-(void)addClicked:(id)sender
{
    //[_tokenText.cell numberFormatter]
    NSData *token=[self convertToken:_tokenText.stringValue];
    if (token==nil) {
        [[NSSound soundNamed:@"Ping"]play];
        [_tokenText selectText:self];
        return;
    }
    [tokenContainer addToken:token];
    [_tokenSV.contentView.documentView reloadData];
    
}

-(void)selectFileClicked:(id)sender
{
    NSOpenPanel *openPannel=[NSOpenPanel openPanel];
    openPannel.canChooseDirectories=NO;
    openPannel.canChooseFiles=YES;
    openPannel.allowsMultipleSelection=YES;
    [openPannel beginSheetModalForWindow:[[NSApplication sharedApplication]keyWindow] completionHandler:^(NSModalResponse result){
        if(result==NSFileHandlingPanelOKButton)
        {
            NSArray *tokenURLs=[openPannel URLs];
            BOOL found=NO;
            for (NSURL *tokenUrl in tokenURLs) {
                NSString *pathOfToken=[tokenUrl path];
                NSData *data=[NSData dataWithContentsOfFile:pathOfToken];
                if ([data length]==TOKEN_LENGTH) {
                    found=YES;
                    [tokenContainer addToken:data withName:[[pathOfToken lastPathComponent] stringByDeletingPathExtension]];
                }
            }
            
            if (found==NO) {
                NSAlert *alert=[NSAlert new];
                alert.informativeText=[NSString stringWithFormat:NSLocalizedString(@"No valid file found. The length of file must be %d",@"404"),TOKEN_LENGTH];
                [[NSSound soundNamed:@"Ping"]play];
                [alert runModal];
            } else {
                [_tokenSV.contentView.documentView reloadData];
            }
            /*NPLog(@"%@",[certURL path]);
            _appDelegate.clientEngine.cert=[certURL path];
            _labelCert.stringValue=[[certURL path] lastPathComponent];
            [[NSUserDefaults standardUserDefaults] setObject:[certURL path] forKey:UDEFKEY_CERT];*/
        }
        
    }];

}

-(void)confirmClicked:(id)sender
{
    if ([tokenContainer count]==0) {
        [[NSSound soundNamed:@"Ping"]play];
        return;
    }
    NSInteger indexCheckFaild=[tokenTableSource checkNameFilled];
    if (indexCheckFaild!=-1) {
        [[NSSound soundNamed:@"Ping"]play];
        NSTableView *tableV=_tokenSV.contentView.documentView;
        [tableV selectRowIndexes:[NSIndexSet indexSetWithIndex:indexCheckFaild] byExtendingSelection:NO];
        NSAlert *alert=[[NSAlert alloc] init];
        alert.informativeText=NSLocalizedString(@"Each token must be given a name",@"Token name needed");
        [alert runModal];
        return;
    }
    //ViewController *viewController=(ViewController *)[self presentingViewController];
    //[viewController informTokenAddition:tokenContainer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TokenAddComplete
                                                        object:self
                                                      userInfo:@{TOKEN_CONTAINER:tokenContainer}];
    [self dismissController:self];
}

-(void)removeClicked:(id)sender
{
    NSTableView *tableV=_tokenSV.contentView.documentView;
    NSArray *tokens=[[tokenContainer getAllTokens] copy];
    
    if ([tableV numberOfSelectedRows]>0) {
        NSIndexSet *indexSet=[tableV selectedRowIndexes];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL* stop){
            [tokenContainer removeToken:[tokens objectAtIndex:index]];
        }];
        [tableV reloadData];
    }
}

-(void)abortClicked:(id)sender
{
    [self dismissController:self];
}


-(void)showAddressClicked:(id)sender
{
    NSAlert *alert=[[NSAlert alloc]init];
    NSArray *ips=[NPTCPServerEngine serverIps];
    NSMutableString *ipsString=[NSMutableString string];
//stringWithString:];
    for (NSString *ip in ips) {
        [ipsString appendFormat:@"%@\n",ip];
    }
    alert.alertStyle=NSInformationalAlertStyle;
    alert.informativeText=ipsString;
    alert.messageText=NSLocalizedString(@"Avaliable Server IPs:", @"ips");
    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
    
}
@end
