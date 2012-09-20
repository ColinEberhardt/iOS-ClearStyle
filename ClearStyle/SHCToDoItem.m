//
//  SHCToDoItem.m
//  ClearStyle
//
//  Created by Colin Eberhardt on 23/08/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import "SHCToDoItem.h"

@implementation SHCToDoItem

- (id)initWithText:(NSString*) text
{
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

+ (id)toDoItemWithText:(NSString *)text
{
    return [[SHCToDoItem alloc] initWithText:text];
}

@end
