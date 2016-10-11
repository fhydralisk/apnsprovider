//
//  NPTokenTableSource.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "NPTokenContainer.h"

#define TKTS_NAMECOLUMNNAME @"Name"
#define TKTS_TOKENCOLUMNNAME @"Token"


@interface NPTokenTableSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (strong, nonatomic) NPTokenContainer *theContainer;
@property BOOL nameEditable;

-(void)rebuildTableView:(NSTableView *)tableView;

/**
 Returns the first unfilled index of Name. -1 if all filled
 */
-(NSInteger)checkNameFilled;


@end
