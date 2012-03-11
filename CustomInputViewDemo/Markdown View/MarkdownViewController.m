//
//  MarkdownViewController.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/10/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "MarkdownViewController.h"
#import "MarkdownInputAccessoryView.h"

@implementation MarkdownViewController

@synthesize textView;
@synthesize accessoryView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.accessoryView.delegate = self.textView;
    self.textView.inputAccessoryView = self.accessoryView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textView = nil;
    self.accessoryView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
