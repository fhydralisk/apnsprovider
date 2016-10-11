//
//  PayloadController.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/29.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "PayloadController.h"

#define APNSKEY_APS                 @"aps"

#define APNSKEY_APS_ALERT           @"alert"
#define APNSKEY_APS_ALERT_TITLE     @"title"
#define APNSKEY_APS_ALERT_BODY      @"body"
#define APNSKEY_APS_BADGE           @"badge"
#define APNSKEY_APS_SOUND           @"sound"
#define APNSKEY_APS_CONETNTAVALIABLE @"content-available"


@interface PayloadController ()

@end

@implementation PayloadController

@dynamic string;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTextView *textV=_rawTextScrollView.contentView.documentView;
    [textV setAutomaticQuoteSubstitutionEnabled:NO];
    // Do view setup here.
}

-(void)convertToConvenient:(id)sender
{
    if  ([self convertJsonToConvenient:[_rawTextScrollView.contentView.documentView string]]==NO)
    {
        [[NSSound soundNamed:@"Ping"]play];
        return;
    }
    [_tabView selectTabViewItemAtIndex:0];
}

-(void)convertToRaw:(id)sender
{
    NSTextView *textV=_rawTextScrollView.contentView.documentView;
    //[textV setString:[self buildJson]];
    textV.string=[self buildJson];
    [_tabView selectTabViewItemAtIndex:1];
}

-(void)typeText:(id)sender
{
    if (sender==_titleText) {
        _titleCheck.state=[_titleText.stringValue length]>0?NSOnState:NSOffState;
    }
    
    if (sender==_contentText) {
        _contentCheck.state=[_contentText.stringValue length]>0?NSOnState:NSOffState;
    }
    
    if (sender==_soundText) {
        _soundCheck.state=[_soundText.stringValue length]>0?NSOnState:NSOffState;
    }
    
    if (sender==_badgeText) {
        _badgeCheck.state=[_badgeText.stringValue length]>0?NSOnState:NSOffState;
    }
}
-(NSString *)string
{
    if ([_tabView.selectedTabViewItem.identifier isEqualToString:@"Convenient"]) {
        return [self buildJson];
    }
    if ([_tabView.selectedTabViewItem.identifier isEqualToString:@"Raw"]) {
        return [_rawTextScrollView.contentView.documentView string];
    }
    return nil;
}

-(void)setString:(NSString *)string
{
    NSTextView *textV=_rawTextScrollView.contentView.documentView ;
    //[setString:string];
    textV.string=string;
    [self convertJsonToConvenient:string];
}


-(NSString *)buildJson
{
    NSMutableDictionary *aps=[NSMutableDictionary dictionary];
    NSDictionary *root=@{APNSKEY_APS:aps};
    
    id alert=nil;
    if (_titleCheck.state==NSOnState) {
        alert=[NSMutableDictionary dictionary];
        [alert setObject:_titleText.stringValue forKey:APNSKEY_APS_ALERT_TITLE];
        if (_contentCheck.state==NSOnState) {
            [alert setObject:_contentText.stringValue forKey:APNSKEY_APS_ALERT_BODY];
        }
    } else {
        if (_contentCheck.state==NSOnState) {
            alert=[NSString stringWithString:_contentText.stringValue];
        }
    }
    if (alert) {
        [aps setObject:alert forKey:APNSKEY_APS_ALERT];
    }
    
    if (_soundCheck.state==NSOnState) {
        [aps setObject:_soundText.stringValue forKey:APNSKEY_APS_SOUND];
    }
    
    if (_badgeCheck.state==NSOnState) {
        [aps setObject:[NSNumber numberWithInteger:_badgeText.stringValue.integerValue] forKey:APNSKEY_APS_BADGE];
    }
    
    if (_contentAvaliableCheck.state==NSOnState) {
        [aps setObject:@1 forKey:APNSKEY_APS_CONETNTAVALIABLE];
    }
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:root options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

-(BOOL)convertJsonToConvenient:(NSString *)json
{
    NSTextView *textV=_rawTextScrollView.contentView.documentView ;
    //[setString:string];
    NSString *jsonString=textV.string;
    NSData *jsonData=[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    

    NSDictionary *jsonRoot=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    if (jsonRoot==nil) {
        return NO;
    }
    
    NSDictionary *aps=[jsonRoot objectForKey:APNSKEY_APS];
    if (aps==nil) {
        return NO;
    }
    
    _titleCheck.state=NSOffState;
    _contentCheck.state=NSOffState;
    _badgeCheck.state=NSOffState;
    _soundCheck.state=NSOffState;
    _contentAvaliableCheck.state=NSOffState;
    _titleCheck.stringValue=@"";
    _contentText.stringValue=@"";
    _badgeText.stringValue=@"";
    _soundText.stringValue=@"default";
    
    id alert=[aps objectForKey:APNSKEY_APS_ALERT];
    if ([alert isKindOfClass:[NSDictionary class]]) {
        NSString *title=[alert objectForKey:APNSKEY_APS_ALERT_TITLE];
        NSString *content=[alert objectForKey:APNSKEY_APS_ALERT_BODY];
        if (title) {
            if ([title isKindOfClass:[NSString class]]==NO) {
                return NO;
            }
            _titleCheck.state=NSOnState;
            _titleText.stringValue=title;
        }
        
        if (content) {
            if ([content isKindOfClass:[NSString class]]==NO) {
                return NO;
            }
            _contentCheck.state=NSOnState;
            _contentText.stringValue=content;
        }
    } else if ([alert isKindOfClass:[NSString class]]) {
        _contentCheck.state=NSOnState;
        _contentText.stringValue=alert;
    } else if (alert!=nil) {
        return NO;
    }
    
    NSString *sound=[aps objectForKey:APNSKEY_APS_SOUND];
    if (sound) {
        if ([sound isKindOfClass:[NSString class]]==NO) {
            return NO;
        }
        _soundCheck.state=NSOnState;
        _soundText.stringValue=sound;
    }
    
    NSNumber *badge=[aps objectForKey:APNSKEY_APS_BADGE];
    if (badge) {
        if ([badge isKindOfClass:[NSNumber class]]==NO) {
            return NO;
        }
        _badgeCheck.state=NSOnState;
        _badgeText.stringValue=[NSString stringWithFormat:@"%ld",(long)[badge integerValue]];
    }
    
    NSNumber *contentAvaliable=[aps objectForKey:APNSKEY_APS_CONETNTAVALIABLE];
    if ([contentAvaliable integerValue]==1) {
        _contentAvaliableCheck.state=NSOnState;
    }
    
    return YES;
    
}
@end
