//
//  NPTokenContainer.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TOKEN_LENGTH 32

#define TKC_NAMEKEY @"Names"
#define TKC_TOKENKEY @"Tokens"

@interface NPTokenContainer : NSObject

-(NSInteger)addToken:(NSData *)token;
-(NSInteger)addToken:(NSData *)token withName:(NSString *)name;

-(void)removeToken:(NSData *)token;
-(void)removeTokenAtIndex:(NSUInteger)index;

-(void)setTokenName:(NSString *)name atIndex:(NSUInteger)index;

-(NSData *)getTokenAtIndex:(NSUInteger)index;
-(NSString *)getTokenNameAtIndex:(NSUInteger)index;
-(NSArray *)getAllTokens;
-(NSArray *)getAllTokenNames;

-(void)combineWithTokenContainer:(NPTokenContainer *)tokenContainer;

-(NSUInteger)count;

-(void)saveToPlist:(NSString *)plistName;
-(void)loadFromPlist:(NSString *)plistName;

@end
