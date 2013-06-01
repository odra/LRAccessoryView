//
//  UIAccessoryView.m
//  UIaccessoryView
//
//  Created by Leonardo Rossetti on 31/05/13.
//  Copyright (c) 2013 Leonardo Rossetti. All rights reserved.
//

#import "UIAccessoryView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIAccessoryView

static NSString *previousText = @"Previous";
static NSString *nextText = @"Next";
static NSString *doneText = @"Done";

@synthesize delegate;
@synthesize dataSource;

- (id)init {
    self = [super init];
    
    if (self != nil) {
        currentIndex = 0;
        
        self.frame = CGRectMake(0, 0, 320, 44);
        self.translucent = YES;
        self.barStyle = UIBarStyleBlack;
        
        segmentedControl = [[UISegmentedControl alloc]
                            initWithItems:[NSArray arrayWithObjects:previousText, nextText, nil]];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.tintColor = [UIColor blackColor];
        segmentedControl.momentary = YES;
        [segmentedControl setSelectedSegmentIndex:0];
        [segmentedControl
         addTarget:self
         action:@selector(switchFields:)
         forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem* segmentedControlItem = [[UIBarButtonItem alloc]
                                                 initWithCustomView:segmentedControl];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
        
        doneButton = [[UIBarButtonItem alloc]
                      initWithTitle:doneText
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(didPressedDoneButton)];
        
        NSArray *buttons = [NSArray
                            arrayWithObjects:segmentedControlItem, flexSpace, doneButton, nil];
        
        [self
         setItems:buttons
         animated: YES];
        
        buttons = nil;
        [buttons release];
        flexSpace = nil;
        [flexSpace release];
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
    doneButton = nil;
    [doneButton release];
    segmentedControl = nil;
    [segmentedControl release];
}

- (void) switchFields:(UISegmentedControl *)control {
    if (segmentedControl.selectedSegmentIndex == 0) {
        currentIndex -=1;
    } else {
        currentIndex += 1;
    }
    
    if (currentIndex == 0) {
        [segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [segmentedControl setEnabled:YES forSegmentAtIndex:1];
    } else if ((currentIndex + 1) == [[self dataSource] numberOfFields]) {
        [segmentedControl setEnabled:YES forSegmentAtIndex:0];
        [segmentedControl setEnabled:NO forSegmentAtIndex:1];
    } else {
        [segmentedControl setEnabled:YES forSegmentAtIndex:0];
        [segmentedControl setEnabled:YES forSegmentAtIndex:1];
    }
    
    UITextField *f = [[self dataSource] fieldForRowAtIndex:currentIndex];
    [f becomeFirstResponder];
    f = nil;
}

- (void) didBeginEditingWithField:(UITextField *)f {
    for (int i = 0; i < [[self dataSource] numberOfFields]; i++) {
        UITextField *currentField = [[self dataSource] fieldForRowAtIndex:i];
        if ([currentField isEqual:f]) {
            currentIndex = i;
            [self reloadData];
        }
        currentField = nil;
    }
}

#pragma mark - DELEGATE

- (void) didPressedDoneButton {
    
    if ([[self delegate] respondsToSelector:@selector(didPressedDoneButton)]) {
        [[self delegate] didPressedDoneButton];
    }
    
}

- (NSInteger) numberOfFields {
    return [[self dataSource] numberOfFields];
}

#pragma mark - DataSource
- (UITextField *) fieldForRowAtIndex:(int)index {
    return [[self dataSource] fieldForRowAtIndex:index];
}

#pragma mark - Utils
- (void) reloadData {
    for (int i = 0; i < [[self dataSource] numberOfFields]; i++) {
        UITextField *f = [[self dataSource] fieldForRowAtIndex:i];
        [f addTarget:self action:@selector(didBeginEditingWithField:) forControlEvents:UIControlEventEditingDidBegin];
        if (currentIndex == 0) {
            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
        } else if ((currentIndex + 1) == [[self dataSource] numberOfFields])  {
            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
        } else {
            [segmentedControl setEnabled:YES forSegmentAtIndex:0];
            [segmentedControl setEnabled:YES forSegmentAtIndex:1];
        }
    }
}

@end
