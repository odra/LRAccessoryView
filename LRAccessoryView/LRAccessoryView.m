//
//  LRAccessoryView.m
//  LRAccessoryView
//
//  Created by Leonardo Rossetti on 31/05/13.
//  Copyright (c) 2013 Leonardo Rossetti. All rights reserved.
//
/*
 Leonardo Rossetti <me@lrossetti.com>
 2013
 
 In the original BSD license, both occurrences of the phrase "COPYRIGHT HOLDERS AND CONTRIBUTORS" in the disclaimer read "REGENTS AND CONTRIBUTORS".
 
 Here is the license template:
 
 Copyright (c) 2013, Leonardo Rossetti
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "LRAccessoryView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LRAccessoryView

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
        
        [buttons release];
        buttons = nil;
        [flexSpace release];
        flexSpace = nil;
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
    [doneButton release];
    doneButton = nil;
    [segmentedControl release];
    segmentedControl = nil;
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
