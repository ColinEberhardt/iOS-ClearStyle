//
//  SHCStrikethroughLabel.h
//  ClearStyle
//
//  Created by Colin Eberhardt on 29/08/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

// A UILabel subclass that can optionally have a strikethrough
//
@interface SHCStrikethroughLabel : UITextField

// A boolean value that determines whether the label should have a strikethrough.
@property (nonatomic) bool strikethough;

@end
