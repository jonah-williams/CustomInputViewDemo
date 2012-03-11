//
//  ResponsiveViewController.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/11/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "ResponsiveViewController.h"

@interface ResponsiveViewController ()

@property(nonatomic, strong) IBOutlet UITextView *textView;
@property(nonatomic, strong) IBOutlet UIView *keyboardAccessoryView;

- (IBAction) dismissKeyboard:(id)sender;
- (void) updateScrollInsets:(NSNotification *)notification;
- (void) resetScrollInsets:(NSNotification *)notification;
- (void) setInsets:(UIEdgeInsets)insets givenUserInfo:(NSDictionary *)userInfo;

@end

@implementation ResponsiveViewController

@synthesize textView;
@synthesize keyboardAccessoryView;

- (IBAction) dismissKeyboard:(id)sender {
    [self.textView resignFirstResponder];
}

- (void) updateScrollInsets:(NSNotification *)notification {
    //determine what portion of the view will be hidden by the keyboard
    CGRect keyboardEndFrameInScreenCoordinates;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrameInScreenCoordinates];
    CGRect keyboardEndFrameInWindowCoordinates = [self.view.window convertRect:keyboardEndFrameInScreenCoordinates fromWindow:nil];
    CGRect keyboardEndFrameInViewCoordinates = [self.view convertRect:keyboardEndFrameInWindowCoordinates fromView:nil];
    CGRect windowFrameInViewCoords = [self.view convertRect:self.view.window.frame fromView:nil];
    CGFloat heightBelowViewInWindow = windowFrameInViewCoords.origin.y + windowFrameInViewCoords.size.height - (self.view.frame.origin.y + self.view.frame.size.height);
    CGFloat heightCoveredByKeyboard = keyboardEndFrameInViewCoordinates.size.height - heightBelowViewInWindow;
    
    //build an inset to add padding to the content view equal to the height of the portion of the view hidden by the keyboard
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, heightCoveredByKeyboard, 0);
    [self setInsets:insets givenUserInfo:notification.userInfo];
}

- (void) resetScrollInsets:(NSNotification *)notification {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setInsets:insets givenUserInfo:notification.userInfo];
}

- (void) setInsets:(UIEdgeInsets)insets givenUserInfo:(NSDictionary *)userInfo {
    //match the keyboard's animation
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    UIViewAnimationOptions animationOptions = animationCurve;
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        self.textView.contentInset = insets;
        self.textView.scrollIndicatorInsets = insets;
    } completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textView = nil;
    self.keyboardAccessoryView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScrollInsets:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScrollInsets:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetScrollInsets:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
