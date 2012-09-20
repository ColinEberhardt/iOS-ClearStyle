//
//  SHCTableViewCellDelegate.h
//  ClearStyle
//
//  Created by Colin Eberhardt on 24/08/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import "SHCToDoItem.h"

@class SHCTableViewCell;

#import <Foundation/Foundation.h>

// A protocol that the SHCTableViewCell uses to inform of state change
//
@protocol SHCTableViewCellDelegate <NSObject>

// indicates that the given item has been deleted
- (void) toDoItemDeleted:(SHCToDoItem*) todoItem;

// Indicates that the edit process has begun for the given cell 
- (void) cellDidBeginEditing:(SHCTableViewCell*) cell;

// Indicates that the edit process has committed for the given cell
- (void) cellDidEndEditing:(SHCTableViewCell*) cell;

@end
