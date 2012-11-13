//
//  SHCTableViewCell.m
//  ClearStyle
//
//  Created by Colin Eberhardt on 23/08/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import "SHCTableViewCell.h"
#import "SHCStrikethroughLabel.h"

#import <QuartzCore/QuartzCore.h>

@implementation SHCTableViewCell
{
    // Primary UI components
    CAGradientLayer* _gradientLayer;
    CALayer* _itemCompleteLayer;
    SHCStrikethroughLabel* _label;
    
    // Contextual cues
    UILabel* _tickLabel;
    UILabel* _crossLabel;
    
    // the item this cell is rendering
    SHCToDoItem* _todoItem;
    
    // Transient state
    bool _markCompleteOnDragRelease;
    bool _deleteOnDragRelease;
    CGPoint _originalCenter;
    
}

const float LABEL_LEFT_MARGIN = 15.0f;
const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

- (id)init
{
    self = [super init];
    if (self) {
        
        // create a label that renders the todo item text
        _label = [[SHCStrikethroughLabel alloc] initWithFrame:CGRectNull];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor = [UIColor clearColor];
        _label.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _label.delegate = self;
        [self addSubview:_label];
        
        // add a tick and cross
        _tickLabel = [self createCueLabel];
        _tickLabel.text = @"\u2713";
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        _crossLabel = [self createCueLabel];
        _crossLabel.text = @"\u2717";
        _crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_crossLabel];
        
        // add a layer that overlays the cell adding a subtle gradient effect
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                 (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                 (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f,
                               @0.01f,
                               @0.95f,
                               @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        // add a layer that renders a green background when an item is complete
        _itemCompleteLayer = [CALayer layer];
        _itemCompleteLayer.backgroundColor = [[[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0] CGColor];
        _itemCompleteLayer.hidden = YES;
        [self.layer insertSublayer:_itemCompleteLayer atIndex:0];
                
        // add a pan recognizer
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        
    }
    return self;
}

// utility method for creating the contextual cues
- (UILabel*) createCueLabel
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

// sets the alpha of the contextual cues 
- (void) setCueAlpha:(float)alpha
{
    _tickLabel.alpha = alpha;
    _crossLabel.alpha = alpha;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // ensure the gradient layers occupy the full bounds
    _gradientLayer.frame = self.bounds;
    _itemCompleteLayer.frame = self.bounds;
    
    // position the label and contextual cues
    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,
                              self.bounds.size.width - LABEL_LEFT_MARGIN,self.bounds.size.height);    
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                              UI_CUES_WIDTH, self.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.bounds.size.height);
}

#pragma mark - horizontal pan gesture methods

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y))
    {
        return YES;
    }
    
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    
    // if the gesture has just started, record the current centre location
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _originalCenter = self.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        
        // determine whether the item has been dragged far enough to initiate a delete / complete
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
        
        // fade the contextual cues
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 2);
        [self setCueAlpha:cueAlpha];
        
        // indicate when the item have been pulled far enough to invoke the given action
        _tickLabel.textColor = _markCompleteOnDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        _crossLabel.textColor = _deleteOnDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        
        if (!_deleteOnDragRelease)
        {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        
        if (_markCompleteOnDragRelease)
        {
            // mark the item as complete and update the UI state
            self.todoItem.completed = YES;
            _itemCompleteLayer.hidden = NO;
            _label.strikethough = YES;
        }
        
        if (_deleteOnDragRelease)
        {
            // notify the delegate that this item should be deleted
            [self.delegate toDoItemDeleted:self.todoItem];
        }
    }
    
}

#pragma mark - property getters / setters

-(SHCStrikethroughLabel*) label
{
    return _label;
}

-(SHCToDoItem*) todoItem
{
    return _todoItem;
}

-(void) setTodoItem:(SHCToDoItem *)todoItem
{
    _todoItem = todoItem;
    
    // we must update all the visual state associated with the model item
    _label.text = todoItem.text;
    _label.strikethough = todoItem.completed;
    _itemCompleteLayer.hidden = !todoItem.completed;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return !self.todoItem.completed;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    self.todoItem.text = textField.text;
    [self.delegate cellDidEndEditing:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate cellDidBeginEditing:self];
}

@end
