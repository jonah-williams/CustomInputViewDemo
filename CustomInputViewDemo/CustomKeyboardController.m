//
//  CustomKeyboardController.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 2/14/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "CustomKeyboardController.h"

@implementation CustomKeyboardController

@synthesize customInputView;
@synthesize customInputAccessoryView;
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    [customInputView release], customInputView = nil;
    [customInputAccessoryView release], customInputAccessoryView = nil;
    [textView release], textView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.inputView = self.customInputView;
    self.textView.inputAccessoryView = self.customInputAccessoryView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.customInputView = nil;
    self.customInputAccessoryView = nil;
    self.textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
