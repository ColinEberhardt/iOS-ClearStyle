//
//  SHCTableViewDataSource.h
//  ClearStyle
//
//  Created by Colin Eberhardt on 03/09/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCToDoItem.h"

// The SHCTableViewDataSource is adpoted by a class that is a source of data
// for a SHCTableView
@protocol SHCTableViewDataSource <NSObject>

// Indicates the number of rows in the table
- (NSInteger) numberOfRows;

// Obtains the cell for the given row
- (UIView *) cellForRow:(NSInteger) row;

// Informs the datasource that a new item has been added at the top of the table
- (void) itemAdded;

// Informs the datasource that a new item has been added at the given index
- (void) itemAddedAtIndex:(NSInteger)index;

@end 
