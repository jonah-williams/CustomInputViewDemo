//
//  MusicScoreViewController.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/11/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "MusicScoreViewController.h"

@interface MusicScoreViewController ()

@end

@implementation MusicScoreViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.view becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
