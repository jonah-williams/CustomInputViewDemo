//
//  MarkdownViewController.h
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/10/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarkdownInputAccessoryView;

@interface MarkdownViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet MarkdownInputAccessoryView *accessoryView;

@end
