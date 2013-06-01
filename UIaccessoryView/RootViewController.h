//
//  RootViewController.h
//  UIaccessoryView
//
//  Created by Leonardo Rossetti on 31/05/13.
//  Copyright (c) 2013 Leonardo Rossetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAccessoryView.h"

@interface RootViewController : UIViewController <UITextFieldDelegate, UIAccessoryViewDataSource, UIAccessoryViewDelegate> {
    IBOutlet UITextField *field1;
    IBOutlet UITextField *field2;
    IBOutlet UITextField *field3;
    NSMutableArray *dataSource;
    UITextField *_field;
}

@end
