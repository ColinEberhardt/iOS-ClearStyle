//
//  SHCPinchAddNewBehaviour.h
//  ClearStyle
//
//  Created by Colin Eberhardt on 11/09/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHCTableView;

// A behaviour that adds the facility to pinch the list in order to insert a new
// item at any location.
//
@interface SHCPinchToAddNewBehaviour : NSObject

// associates this behaviour with the given table
- (id)initWithTableView:(SHCTableView*)tableView;

@end
