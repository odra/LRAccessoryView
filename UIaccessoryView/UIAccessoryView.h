//
//  UIAccessoryView.h
//  UIaccessoryView
//
//  Created by Leonardo Rossetti on 31/05/13.
//  Copyright (c) 2013 Leonardo Rossetti <me@lrossetti.com>. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIAccessoryViewDelegate <NSObject>
@required
- (void) didPressedDoneButton;
@end

@protocol UIAccessoryViewDataSource <NSObject>
@required
- (NSInteger) numberOfFields;
- (UITextField *) fieldForRowAtIndex:(int)index;
@end

@interface UIAccessoryView : UIToolbar {
    UIBarButtonItem *doneButton;
    UISegmentedControl* segmentedControl;
    int currentIndex;
}

@property (retain) id delegate;
@property(retain) id dataSource;

- (void) reloadData;

@end
