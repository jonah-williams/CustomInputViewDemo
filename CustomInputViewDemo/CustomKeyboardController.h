//
//  CustomKeyboardController.h
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 2/14/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomKeyboardController : UIViewController

@property(nonatomic, retain) IBOutlet UIView *customInputView;
@property(nonatomic, retain) IBOutlet UIView *customInputAccessoryView;
@property(nonatomic, retain) IBOutlet UITextView *textView;

@end
