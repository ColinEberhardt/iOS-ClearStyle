//
//  SHCViewController.m
//  ClearStyle
//
//  Created by Colin Eberhardt on 23/08/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import "SHCViewController.h"
#import "SHCToDoItem.h"
#import "SHCTableViewCell.h"
#import "SHCPullToAddNewBehaviour.h"
#import "SHCPinchToAddNewBehaviour.h"

@interface SHCViewController ()

@end

@implementation SHCViewController
{
    // a array of to-do items
    NSMutableArray* _toDoItems;
    
    // the offset applied to cells when entering 'edit mode'
    float _editingOffset;
        
    SHCPullToAddNewBehaviour* _pullAddNewBehaviour;
    SHCPinchToAddNewBehaviour* _pinchAddNewBehaviour;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // create a dummy todo list
        _toDoItems = [[NSMutableArray alloc] init];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Feed the cat"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Buy eggs"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Pack bags for WWDC"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Rule the web"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Buy a new iPhone"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Find missing socks"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Write a new tutorial"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Master Objective-C"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Remember your wedding anniversary!"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Drink less beer"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Learn to draw"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Take the car to the garage"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Sell things on eBay"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Learn to juggle"]];
        [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Give up"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor blackColor];
    
    // configure the table
    [self.tableView registerClassForCells:[SHCTableViewCell class]];
    self.tableView.datasource = self;
    
    _pullAddNewBehaviour = [[SHCPullToAddNewBehaviour alloc] initWithTableView:self.tableView];
    _pinchAddNewBehaviour  = [[SHCPinchToAddNewBehaviour alloc] initWithTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor*)colorForIndex:(NSInteger) index
{
    NSUInteger itemCount = _toDoItems.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

#pragma mark - SHCTableViewCellDelegate methods

- (void)cellDidBeginEditing:(SHCTableViewCell *)editingCell
{
    _editingOffset = _tableView.scrollView.contentOffset.y - editingCell.frame.origin.y;
    
    for(SHCTableViewCell* cell in [_tableView visibleCells])
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             cell.transform = CGAffineTransformMakeTranslation(0,  _editingOffset);
                             if (cell != editingCell)
                             {
                                 cell.alpha = 0.3;
                             }
                         }];
    }
}

- (void)cellDidEndEditing:(SHCTableViewCell *)editingCell
{
    for(SHCTableViewCell* cell in [_tableView visibleCells])
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             cell.transform = CGAffineTransformIdentity;
                             if (cell != editingCell)
                             {
                                 cell.alpha = 1.0;
                             }
                         }];
    }
}


- (void) toDoItemDeleted:(SHCToDoItem*) todoItem
{    
    float delay = 0.0;
    
    [_toDoItems removeObject:todoItem];
    
    NSArray* visibleCells = [_tableView visibleCells];
    
    UIView* lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    for(SHCTableViewCell* cell in visibleCells)
    {
        if (startAnimating)
        {
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 if (cell == lastView)
                                 {
                                     [_tableView reloadData];
                                 }
                             }];
            delay+=0.03;
        }
        
        if (cell.todoItem == todoItem)
        {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
}



#pragma mark - SHCCustomTableViewDataSource methods

- (void)itemAdded
{
    [self itemAddedAtIndex:0];
}

- (void)itemAddedAtIndex:(NSInteger)index
{
    // create the new item
    SHCToDoItem* toDoItem = [[SHCToDoItem alloc] init];
    [_toDoItems insertObject:toDoItem atIndex:index];
    
    // refresh the table
    [_tableView reloadData];
    
    // enter edit mode
    SHCTableViewCell* editCell;
    for(SHCTableViewCell* cell in _tableView.visibleCells)
    {
        if (cell.todoItem == toDoItem)
        {
            editCell = cell;
            break;
        }
    }
    [editCell.label becomeFirstResponder];
}

- (NSInteger)numberOfRows
{
    return _toDoItems.count;
}


- (UIView *) cellForRow:(NSInteger) row;
{
    SHCTableViewCell* cell = (SHCTableViewCell*)[_tableView dequeueReusableCell];
        
    int index = row;
    SHCToDoItem *item = _toDoItems[index];
    cell.todoItem = item;
    cell.backgroundColor = [self colorForIndex:row];
    cell.delegate = self;
    
    return cell;
}



@end
