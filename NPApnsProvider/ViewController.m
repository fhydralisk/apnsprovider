//
//  ViewController.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//
#import "NPMacro.h"
#import "ViewController.h"
#import "NPApnsErrorPacket.h"
#import "NPApnsFramePacket.h"
#import "NPApnsNotificationPacket.h"
#import "PayloadController.h"
//#import "NPGernalPacket.h"
#import "NPPayloadTemplates.h"
#import "NPTokenContainer.h"
#import "NPTokenTableSource.h"
#import "TokenController.h"

#define TOKENVC_STORYBOARDID @"TokenSelect"
#define MAIN_STORYBOARD     @"Main"

#define SERVERPOP_DOMAINKEY @"Domain"

#define CERT_NOT_CHOOSE @"Certificate File Not Choosed"



@implementation ViewController
{
    NSData *lastToken;
    NPPayloadTemplates *payloadTemplates;
    NPTokenContainer *tokenContainer;
    NPTokenTableSource *tokenTableSource;
    BOOL disconnectFromServerSide;
    PayloadController *payloadController;
    NSDictionary *lastIds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NPLog(@"view lo");
    _appDelegate=[[NSApplication sharedApplication] delegate];
    _appDelegate.firstViewController=self;
    
    [_appDelegate.clientEngine setDelegate:self];
    //[_appDelegate.serverEngine setDegelate:self];
    
    
    /*if (lastToken) {
        [self addTextToStatus:@"Token binded"];
    }*/
    [self doInitPayloadView];
    [self doInitCert];
    [self doInitPayloadPopupMenu];
    [self doInitServerPopMenu];
    [self doInitTokenTable];
    
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(windowCloseNotification:) name:NSWindowWillCloseNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(informTokenAddition:) name:TokenAddComplete object:nil];
    //NPLog(@"%@",[NSString localizedStringWithFormat:@"Choose a certificate file (*.cer) first"]);
    
    //[[NSApplication sharedApplication] keyWindow].delegate=self;
    
    // disable smart quotes for the NSTextView, otherwise notification will not be sent correctly.
    //[_notifyView.contentView.documentView setAutomaticQuoteSubstitutionEnabled:NO];
    //tests

    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


-(void)doInitPayloadView
{
    payloadController=[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Payload"];
    [self.view addSubview:payloadController.view];
    NSRect frame;
    frame.origin=_notifyView.frame.origin;
    frame.size=payloadController.view.frame.size;
    frame.origin.y-=5;
    payloadController.view.frame=frame;
    [_notifyView removeFromSuperview];
}



//view contents initialization methods

-(void)doInitPayloadPopupMenu
{
    payloadTemplates=[NPPayloadTemplates new];
    [payloadTemplates buildFromPlist:PLT_PLISTNAME];
    [_payloadTempPop.menu removeAllItems];
    for (int i=0; i<[payloadTemplates count]; i++) {
        [_payloadTempPop.menu addItemWithTitle:[payloadTemplates getTemplateNameAtIndex:i] action:nil keyEquivalent:@""];
    }
    [self payloadTempSelected:_payloadTempPop];
    
    
}

-(void)doInitServerPopMenu
{

    [_serverSelectPop.menu removeAllItems];
    for (int i=0; i<[_appDelegate.servers count]; i++) {
        [_serverSelectPop.menu addItemWithTitle:[_appDelegate.servers objectAtIndex:i] action:nil keyEquivalent:@""];
    }
    //[self payloadTempSelected:_payloadTempPop];
    
    
}

-(void)doInitCert
{
    NSString *pathCert=[[NSUserDefaults standardUserDefaults] objectForKey:UDEFKEY_CERT];
    
    if (pathCert) {
        /*NSFileManager *fileMan=[NSFileManager defaultManager];
        BOOL isDir=NO;
        if (![fileMan fileExistsAtPath:pathCert isDirectory:&isDir]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDEFKEY_CERT];
            return;
        }
        
        if (isDir) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDEFKEY_CERT];
            return;
        }*/
        NSData *dataCert=[[NSUserDefaults standardUserDefaults] objectForKey:UDEFKEY_CERTDATA];
        _appDelegate.clientEngine.certData=dataCert;
        _labelCert.stringValue=[pathCert lastPathComponent];
    }
}

-(void)doInitTokenTable
{
    tokenTableSource=[NPTokenTableSource new];
    tokenContainer=[NPTokenContainer new];
    [tokenContainer loadFromPlist:TOKENSTORENAME];
    
    tokenTableSource.theContainer=tokenContainer;
    //tokenTableSource.nameEditable=YES;
    
    [tokenTableSource rebuildTableView:_tokenSV.contentView.documentView];
}
//server engine delegate

/*-(void)serverEngine:(NPMyTCPServerEngine *)serverEngine clientDidConnect:(NPMyTCPServerClient *)client
{
    [self addTextToStatus:@"client connected"];
}

-(void)serverEngine:(NPMyTCPServerEngine *)serverEngine client:(NPMyTCPServerClient *)client didReceivePacket:(NPPacket *)packet
{
    NSData *pktData=[packet content];
    switch ([[packet getHeaderField:GPH_TYPE] unsignedCharValue]) {
        case 7:
            lastToken=pktData;
            [self performSelectorOnMainThread:@selector(addTextToStatus:) withObject:@"Token binded" waitUntilDone:NO];
            [[NSUserDefaults standardUserDefaults] setObject:lastToken forKey:@"lastToken"];
            break;
            
        default:
            break;
    }
    
}

-(void)serverEngine:(NPMyTCPServerEngine *)serverEngine clientDidDisconnect:(NPMyTCPServerClient *)client
{
    [self performSelectorOnMainThread:@selector(addTextToStatus:) withObject:@"client disconnected" waitUntilDone:NO];
}

-(BOOL)serverEngine:(NPMyTCPServerEngine *)serverEngine client:(NPMyTCPServerClient *)client shouldDisconnectWithErrorPacket:(NPPacket *)errorPacket
{
    [self performSelectorOnMainThread:@selector(addTextToStatus:) withObject:@"error packet received" waitUntilDone:NO];
    return NO;
}*/


//client engine delegate

-(void)clientEngineSSLHandshakeSucceed:(NPApnsClientEngine *)engine
{
    [self addTextToStatus: NSLocalizedString(@"Connected to APN server successfully",@"connected")];
}

-(void)clientEngineDidConnectToServer:(NPTCPClientEngine *)clientEngine
{
    [self addTextToStatus: NSLocalizedString(@"Connected to server, validating identity...",@"connected")];
}

-(void)clientEngineDidDisconnect:(NPTCPClientEngine *)clientEngine
{
    if (disconnectFromServerSide) {
        [self addTextToStatus:NSLocalizedString(@"Disconnected by server due to invalid certificate, invalid data, network error... etc",@"disconnected")];
    } else {
        [self addTextToStatus:NSLocalizedString(@"Disconnected by user",@"disconnected")];
    }
}

-(void)clientEngine:(NPTCPClientEngine *)clientEngine didReceivePacket:(NPPacket *)packet
{
    /*
    0
    No errors encountered
    1
    Processing error
    2
    Missing device token
    3
    Missing topic
    4
    Missing payload
    5
    Invalid token size
    6
    Invalid topic size
    7
    Invalid payload size
    8
    Invalid token
    10
    Shutdown
    255
    None (unknown)*/
    
    NSUInteger errorType=[[packet getHeaderField:APNSEPH_STATUS] unsignedIntegerValue];
    NSUInteger errorNid=[[packet getHeaderField:APNSEPH_ID]unsignedIntegerValue];
    
    static NSDictionary *dictError=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictError=@{@"0":NSLocalizedString(@"No errors encountered",@""),
                    @"1":NSLocalizedString(@"Processing error",@""),
                    @"2":NSLocalizedString(@"Missing device token",@""),
                    @"3":NSLocalizedString(@"Missing topic",@""),
                    @"4":NSLocalizedString(@"Missing payload",@""),
                    @"5":NSLocalizedString(@"Invalid token size",@""),
                    @"6":NSLocalizedString(@"Invalid topic size",@""),
                    @"7":NSLocalizedString(@"Invalid payload size",@""),
                    @"8":NSLocalizedString(@"Invalid token",@""),
                    @"10":NSLocalizedString(@"Shutdown",@""),
                    @"255":NSLocalizedString(@"None (unknown)",@"")};
    });
    
    NSString *errDescription=[dictError objectForKey:[NSString stringWithFormat:@"%ld",errorType]];
    if ([lastIds objectForKey:@(htonl(errorNid))]!=nil) {
        NSString *deviceName=lastIds[@(htonl(errorNid))];
        if (errDescription) {
            [self addTextToStatus:[NSString stringWithFormat:NSLocalizedString(@"Failed sending APN to %@, description:%@, frameID=0x%08X",@"Apns error hint"),deviceName, errDescription, htonl(errorNid)]];
        } else {
            [self addTextToStatus:[NSString stringWithFormat:NSLocalizedString(@"Failed sending APN to %@, description:%ld, frameID=0x%08X",@"Apns error hint"),deviceName, errorType, htonl(errorNid)]];
        }

    } else {
        if (errDescription) {
            [self addTextToStatus:[NSString stringWithFormat:NSLocalizedString(@"APNS Error:%@ frameID=0x%08X",@"Apns error hint"),errDescription, htonl(errorNid)]];
        } else {
            [self addTextToStatus:[NSString stringWithFormat:NSLocalizedString(@"APNS Error:%ld frameID=0x%08X",@"Apns error hint"),errorType, htonl(errorNid)]];
        }
    }
    
}

-(BOOL)clientEngine:(NPTCPClientEngine *)clientEngine didReceiveErrorPacket:(NPPacket *)packet
{
    [self addTextToStatus:NSLocalizedString(@"Error Packet received",@"error packet")];
    return NO;
}

// window notification

-(void)windowCloseNotification:(NSNotification *)notification
{
    if (notification.object==self.view.window) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSApplication sharedApplication] terminate:self];
    }
}


@end


@implementation ViewController (Actions)

-(void)removeTokenClicked:(id)sender
{
    NSTableView *tableV=_tokenSV.contentView.documentView;
    NSArray *tokens=[[tokenContainer getAllTokens] copy];
    
    if ([tableV numberOfSelectedRows]>0) {
        NSIndexSet *indexSet=[tableV selectedRowIndexes];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL* stop){
            [tokenContainer removeToken:[tokens objectAtIndex:index]];
        }];
        [tableV reloadData];
        [tokenContainer saveToPlist:TOKENSTORENAME];
    }

}

/*-(void)listenClicked:(id)sender {
    if ([_appDelegate.serverEngine startListen])
        [self addTextToStatus:@"Listen started"];
}*/

-(void)connectClicked:(id)sender {
    //_appDelegate.clientEngine.cert=@"/Users/Hydralisk/Documents/code/APNs/aps_development.cer";
    disconnectFromServerSide=YES;

    NSData *certData=_appDelegate.clientEngine.certData;
    if (certData==nil) {
        [self addTextToStatus:NSLocalizedString(@"Choose a certificate file (*.cer) first",@"choose cert")];
        return;
    }
    
    /*NSFileManager *fileMan=[NSFileManager defaultManager];
    BOOL isDir=NO;
    if (![fileMan fileExistsAtPath:pathCert isDirectory:&isDir]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDEFKEY_CERT];
        _labelCert.stringValue=NSLocalizedString(CERT_NOT_CHOOSE,@"Cert not choose");
        [self addTextToStatus:NSLocalizedString(@"Certificate do not exist, choose again.",@"choose again")];
        return;
    }
    
    if (isDir) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UDEFKEY_CERT];
        _labelCert.stringValue=CERT_NOT_CHOOSE;
        [self addTextToStatus:NSLocalizedString(@"Certificate do not exist, choose again.",@"choose again")];
       return;
    }*/

    
    if (_serverSelectPop.selectedItem==nil) {
        [self addTextToStatus:NSLocalizedString(@"Select server first.", @"select server")];
        return;
    }
    if (_appDelegate.clientEngine.isConnected) {
        [self addTextToStatus:NSLocalizedString(@"Already connected, please disconnect first",@"disconnect first")];
        return;
    }
    
    _appDelegate.clientEngine.serverDomain=_serverSelectPop.selectedItem.title;
    
    [self addTextToStatus:[NSString stringWithFormat:NSLocalizedString(@"Connecting to %@",@"connect to"), _serverSelectPop.selectedItem.title]];
    if ([_appDelegate.clientEngine connect]==NO) {
        [[NSSound soundNamed:@"Ping"]play];
    }
}

-(void)notifyClicked:(id)sender {
    if (!_appDelegate.clientEngine.isConnected) {
        [self addTextToStatus:NSLocalizedString(@"Not connected to server",@"not connected")];
        return;
    }
    
    if ([tokenContainer count])
    {
        //NSTextView *notifyView=(NSTextView *)_notifyView.contentView.documentView;
        /*NSString *payload=
         [[@"{  \"aps\" : { \"alert\" : { \"body\" : \"" stringByAppendingString:notifyView.string] stringByAppendingString:@"\" , \"actions\" : [{ \"id\" : \"delete\", \"title\" : \"Delete\" },{ \"id\" : \"add\", \"title\" : \"Add\" }] } , \"badge\" : 50, \"sound\" : \"default\" , \"category\" : \"testCategory\" }, \"acme2\" : [ \"bang\",  \"whiz\" ] }"];
         
         NPLog(@"payload=%@",payload);*/
        NSString *payload=payloadController.string;
        NSMutableDictionary *idForToken=[NSMutableDictionary dictionary];
        
        for (int i=0; i<[tokenContainer count]; i++) {
            
            NSData *token=[tokenContainer getTokenAtIndex:i];
            
            NPApnsFramePacket *tokenPacket=[NPApnsFramePacket new];
            [tokenPacket setNumber:APNSFPTYPE_DEVICETOCKEN toFiled:APNSFPH_TYPE byNetOrder:YES];
            [tokenPacket autoEndHeaders];
            [tokenPacket fillContent:token];
            assert([tokenPacket endPacket]);
            
            NPApnsFramePacket *payloadPacket=[NPApnsFramePacket new];
            [payloadPacket setNumber:APNSFPTYPE_PAYLOAD toFiled:APNSFPH_TYPE byNetOrder:YES];
            [payloadPacket fillContent:[NSData dataWithBytes:[payload UTF8String] length:[payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
            
            [payloadPacket autoEndHeaders];
            assert([payloadPacket endPacket]);
            
            NPApnsFramePacket *idPacket=[NPApnsFramePacket new];
            [idPacket setNumber:APNSFPTYPE_NOTIFICATIONID toFiled:APNSFPH_TYPE byNetOrder:YES];
            assert([idPacket autoEndHeaders]);
            UInt32 contentId=rand();
            NSData *contentDataId=[NSData dataWithBytes:&contentId length:sizeof(contentId)];
            [idPacket fillContent:contentDataId];
            assert([idPacket endPacket]);
            
            NPApnsFramePacket *expirePacket=[NPApnsFramePacket new];
            [expirePacket setNumber:APNSFPTYPE_EXPIRATION toFiled:APNSFPH_TYPE byNetOrder:YES];
            [expirePacket autoEndHeaders];
            UInt32 content=0;
            NSData *contentData=[NSData dataWithBytes:&content length:sizeof(content)];
            [expirePacket fillContent:contentData];
            assert([expirePacket endPacket]);
            
            
            NPApnsFramePacket *priorityPacket=[NPApnsFramePacket new];
            [priorityPacket setNumber:APNSFPTYPE_PRIORITY toFiled:APNSFPH_TYPE byNetOrder:YES];
            [priorityPacket autoEndHeaders];
            UInt8 contentPri=10;
            NSData *contentDataPri=[NSData dataWithBytes:&contentPri length:sizeof(contentPri)];
            [priorityPacket fillContent:contentDataPri];
            assert([priorityPacket endPacket]);
            
            
            NPApnsNotificationPacket *notifyPacket=[NPApnsNotificationPacket new];
            [notifyPacket fillContent:[tokenPacket data]];
            [notifyPacket fillContent:[payloadPacket data]];
            [notifyPacket fillContent:[expirePacket data]];
            [notifyPacket fillContent:[priorityPacket data]];
            [notifyPacket fillContent:[idPacket data]];
            [notifyPacket autoEndHeaders];
            assert([notifyPacket endPacket]);
            
            [_appDelegate.clientEngine sendPacket:notifyPacket];
            
            [self addTextToStatus:[NSString stringWithFormat:NSLocalizedString(@"Notification sent to: %@ with id 0x%08X",@"notification sent"),[tokenContainer getTokenNameAtIndex:i],contentId]];
            [idForToken setObject:[tokenContainer getTokenNameAtIndex:i] forKey:@(contentId)];
        }
        
        lastIds=[NSDictionary dictionaryWithDictionary:idForToken];
        
    } else {
        [self addTextToStatus:NSLocalizedString(@"Token not binded",@"Token not binded")];
    }
}

-(void)endClicked:(id)sender {
    disconnectFromServerSide=NO;

    //[_appDelegate.serverEngine disconnectAll];
    //[_appDelegate.serverEngine stopListen];
    [_appDelegate.clientEngine disconnect];
    
}

-(void)chooseCertClicked:(id)sender
{
    NSOpenPanel *openPannel=[NSOpenPanel openPanel];
    openPannel.canChooseDirectories=NO;
    openPannel.canChooseFiles=YES;
    openPannel.allowsMultipleSelection=NO;
    openPannel.allowsOtherFileTypes=NO;
    openPannel.allowedFileTypes=@[@"cer"];
    [openPannel beginSheetModalForWindow:[[NSApplication sharedApplication]keyWindow] completionHandler:^(NSModalResponse result){
        if(result==NSFileHandlingPanelOKButton)
        {
            NSURL *certURL=[openPannel URL];
            NPLog(@"%@",[certURL path]);
            _appDelegate.clientEngine.certData=[NSData dataWithContentsOfURL:certURL];
            _labelCert.stringValue=[[certURL path] lastPathComponent];
            [[NSUserDefaults standardUserDefaults] setObject:[certURL path] forKey:UDEFKEY_CERT];
            [[NSUserDefaults standardUserDefaults] setObject:[NSData dataWithContentsOfURL:certURL] forKey:UDEFKEY_CERTDATA];
        }
        
    }];
    
}

-(void)payloadTempSelected:(id)sender
{
    NPLog(@"menu action");
    if (_payloadTempPop.indexOfSelectedItem==-1) {
        return;
    }
    //NSTextView *textView=_notifyView.contentView.documentView;
    payloadController.string=[payloadTemplates getPayloadContentAtIndex:_payloadTempPop.indexOfSelectedItem];
    
    
}

@end

@implementation ViewController (Methods)

-(void)addTextToStatus:(NSString *)text
{
    
    NSTextView *textV=(NSTextView *)_statusView.contentView.documentView;
    textV.string=[[textV.string stringByAppendingString:text] stringByAppendingString:[NSString stringWithCString:"\n" encoding:NSUTF8StringEncoding]];
    [textV scrollPoint:CGPointMake(0,textV.bounds.size.height)];
    
}

-(void)informTokenAddition:(NSNotification *)notification
{
    NPTokenContainer *container=[notification.userInfo objectForKey:TOKEN_CONTAINER];
    [tokenContainer combineWithTokenContainer:container];
    [_tokenSV.contentView.documentView reloadData];
    [tokenContainer saveToPlist:TOKENSTORENAME];
}

@end
