//
//  MarkdownInputAccessoryView.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/10/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "MarkdownInputAccessoryView.h"

@implementation MarkdownInputAccessoryView

@synthesize delegate;

- (IBAction)toggleStrong:(id)sender {
    UITextRange *selectedText = [delegate selectedTextRange];
    if (selectedText == nil) {
        //no selection or insertion point
        //...
    }
    else if (selectedText.empty) {
        //inserting text at an insertion point
        [delegate replaceRange:selectedText withText:@"*"];
        //...
    }
    else {
        //updated a selected range
        //...
    }
}

- (IBAction)toggleEmphasis:(id)sender {
    //...
}

- (IBAction)toggleCode:(id)sender {
    //...
}

@end
