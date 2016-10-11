//
//  NPTokenContainer.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPTokenContainer.h"

@implementation NPTokenContainer
{
    NSMutableArray *tokens;
    NSMutableArray *tokenNames;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        tokens=[NSMutableArray array];
        tokenNames=[NSMutableArray array];
    }
    return self;
}

-(NSInteger)addToken:(NSData *)token withName:(NSString *)name
{
    assert([tokenNames count]==[tokens count]);
    if ([token length]!=TOKEN_LENGTH) {
        return -1;
    }
    [tokens addObject:token];
    [tokenNames addObject:name];
    return [tokens count]-1;
}

-(NSInteger)addToken:(NSData *)token
{
    return [self addToken:token withName:@""];
}

-(void)removeToken:(NSData *)token
{
    NSUInteger index=[tokens indexOfObjectIdenticalTo:token];
    if (index!=NSNotFound) {
        [self removeTokenAtIndex:index];
    }
}

-(void)removeTokenAtIndex:(NSUInteger)index
{
    assert(index<[tokens count]);
    [tokens removeObjectAtIndex:index];
    [tokenNames removeObjectAtIndex:index];
}

-(void)setTokenName:(NSString *)name atIndex:(NSUInteger)index
{
    assert(index<[tokens count]);
    [tokenNames replaceObjectAtIndex:index withObject:name];
}

-(NSData *)getTokenAtIndex:(NSUInteger)index
{
    if (index>=[tokens count]) {
        return nil;
    }
    return [tokens objectAtIndex:index];
}

-(NSString *)getTokenNameAtIndex:(NSUInteger)index
{
    if (index>=[tokenNames count]) {
        return nil;
    }
    return [tokenNames objectAtIndex:index];
}

-(NSArray *)getAllTokens
{
    return tokens;
}

-(NSArray *)getAllTokenNames
{
    return tokenNames;
}

-(NSUInteger)count
{
    assert([tokens count]==[tokenNames count]);
    return [tokens count];
}

-(void)combineWithTokenContainer:(NPTokenContainer *)tokenContainer
{
    NSArray *targetTokens=[tokenContainer getAllTokens];
    NSArray *targetTokenNames=[tokenContainer getAllTokenNames];
    assert([targetTokenNames count]==[targetTokens count]);
    [tokens addObjectsFromArray:targetTokens];
    [tokenNames addObjectsFromArray:targetTokenNames];
}

-(void)saveToPlist:(NSString *)plistName
{
    NSDictionary *dictToSave=@{TKC_NAMEKEY:tokenNames,
                               TKC_TOKENKEY:tokens};
    NSString *path=[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
                     stringByAppendingPathComponent:plistName]
                     stringByAppendingPathExtension:@"plist"];
    
    assert([dictToSave writeToFile:path atomically:NO]);
}

-(void)loadFromPlist:(NSString *)plistName
{
    NSString *path=[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
                     stringByAppendingPathComponent:plistName]
                    stringByAppendingPathExtension:@"plist"];

    NSDictionary *dictLoaded=[NSDictionary dictionaryWithContentsOfFile:path];
    if (dictLoaded) {
        NSArray *arrayNames=[dictLoaded objectForKey:TKC_NAMEKEY];
        assert([arrayNames isKindOfClass:[NSArray class]]);
        
        NSArray *arrayTokens=[dictLoaded objectForKey:TKC_TOKENKEY];
        assert([arrayTokens isKindOfClass:[NSArray class]]);
        
        tokens=[NSMutableArray arrayWithArray:arrayTokens];
        tokenNames=[NSMutableArray arrayWithArray:arrayNames];
        
    }
}
@end
