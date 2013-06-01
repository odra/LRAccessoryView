//
//  RootViewController.m
//  UIaccessoryView
//
//  Created by Leonardo Rossetti on 31/05/13.
//  Copyright (c) 2013 Leonardo Rossetti. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIAccessoryView *v = [[UIAccessoryView alloc] init];
    v.delegate = self;
    v.dataSource = self;
    [field1 setInputAccessoryView:v];
    [field2 setInputAccessoryView:v];
    [field3 setInputAccessoryView:v];
    
    dataSource = [[NSMutableArray alloc] init];
    [dataSource addObject:field1];
    [dataSource addObject:field2];
    [dataSource addObject:field3];
    [v reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAccessoryView
- (void) didPressedDoneButton {
    [_field resignFirstResponder];
}

- (NSInteger) numberOfFields {
    return [dataSource count];
}

- (UITextField *)fieldForRowAtIndex:(int)index {
    UITextField *f = [dataSource objectAtIndex:index];
    
    return f;
}

#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _field = textField;
}

@end
