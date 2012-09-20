//
//  SHCCustomTableView.h
//  ClearStyle
//
//  Created by Colin Eberhardt on 03/09/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHCTableViewDataSource.h"

// the height of table cells
extern float const SHC_ROW_HEIGHT;

// A simple table implementation that renders cells within a scrolling container
@interface SHCTableView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<UIScrollViewDelegate> delegate;

// the object that acts as the data source for this table
@property (nonatomic, assign) id<SHCTableViewDataSource> datasource;

// the UIScrollView that hosts the table contents
@property (nonatomic, assign, readonly) UIScrollView* scrollView;

// dequeues a cell that can be re-used
-(UIView*) dequeueReusableCell;

// an array of cells that are currenlty visible, sorted from top to bottom.
-(NSArray*) visibleCells;

// forces the table to dispose of all the cells and re-build the table.
-(void) reloadData;

// registers a class for use as new cells
-(void) registerClassForCells: (Class)cellClass;

@end
