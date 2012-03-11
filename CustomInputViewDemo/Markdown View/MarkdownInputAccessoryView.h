//
//  MarkdownInputAccessoryView.h
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/10/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkdownInputAccessoryView : UIView

@property(nonatomic, weak) id <UITextInput> delegate;

- (IBAction)toggleStrong:(id)sender;
- (IBAction)toggleEmphasis:(id)sender;
- (IBAction)toggleCode:(id)sender;

@end
