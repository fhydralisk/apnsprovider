//
//  NPTokenTableSource.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/24.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//
#import "NPMacro.h"
#import "NPTokenTableSource.h"

@implementation NPTokenTableSource

-(void)rebuildTableView:(NSTableView *)tableView
{
    NSArray *tableColumns=[tableView.tableColumns copy];
    for (NSTableColumn *tableColumn in tableColumns) {
        [tableView removeTableColumn:tableColumn];
    }
    
    NSTableColumn *tableColumnName=[[NSTableColumn alloc] init];
    tableColumnName.identifier=TKTS_NAMECOLUMNNAME;
    tableColumnName.title=TKTS_NAMECOLUMNNAME;
    tableColumnName.width=70.0;
    [tableView addTableColumn:tableColumnName];
    
    NSTableColumn *tableColumnToken=[[NSTableColumn alloc] init];
    tableColumnToken.identifier=TKTS_TOKENCOLUMNNAME;
    tableColumnToken.title=TKTS_TOKENCOLUMNNAME;
    tableColumnToken.width = 300.0;
    [tableView addTableColumn:tableColumnToken];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView reloadData];
    //[tableView removeTableColumn:]
}

-(NSInteger)checkNameFilled
{
    NSArray *names=[_theContainer getAllTokenNames];
    NSUInteger indexUnfilled=[names indexOfObject:@""];
    return indexUnfilled==NSNotFound?-1:indexUnfilled;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_theContainer count];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTextField *textField=nil;
    if ([tableColumn.identifier isEqualToString:TKTS_NAMECOLUMNNAME]) {
        textField=[NSTextField new];
        textField.stringValue=[_theContainer getTokenNameAtIndex:row];
        textField.editable=_nameEditable;
        textField.tag=row;
        textField.backgroundColor=[NSColor clearColor];
        //textField send
        if (_nameEditable) {
            textField.backgroundColor=[NSColor textBackgroundColor];
            [textField setTarget:self];
            [textField setAction:@selector(nameUpdated:)];
            [textField.cell setSendsActionOnEndEditing:YES];
        }
        textField.bordered=NO;
        
    }
    
    if ([tableColumn.identifier isEqualToString:TKTS_TOKENCOLUMNNAME]) {
        textField=[NSTextField new];
        NSData *token=[_theContainer getTokenAtIndex:row];
        NSMutableString *stringToken=[NSMutableString string];
        unsigned char *tokenPtr=(unsigned char*)[token bytes];
        for (int i=0; i<[token length]; i++) {
            [stringToken appendFormat:@"%02X",tokenPtr[i]];
        }
        textField.stringValue=stringToken;
        textField.editable=NO;
        textField.bordered=NO;
        textField.backgroundColor=[NSColor clearColor];
    }
    return textField;
}

-(void)nameUpdated:(id)sender
{
    NPLog(@"name updated");
    NSTextField *textField=sender;
    [_theContainer setTokenName:textField.stringValue atIndex:textField.tag];
}


@end
