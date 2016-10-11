//
//  NPPayloadTemplates.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TPKEY_ROOT                  @"Payloads"
#define TPKEY_TEMPLATENAME          @"Template Name"
#define TPKEY_PAYLOADCONTENT        @"Payload Content"

@interface NPPayloadTemplates : NSObject

@property (readonly, nonatomic) NSArray* templateNames;
@property (readonly, nonatomic) NSArray* payloadContents;

-(void)buildFromPlist:(NSString *)plistName;
-(NSString *)getPayloadContentAtIndex:(NSUInteger) index;
-(NSString *)getTemplateNameAtIndex:(NSUInteger) index;
-(NSUInteger)count;



@end
