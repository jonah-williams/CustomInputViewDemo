//
//  MusicScoreView.m
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/10/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import "MusicScoreView.h"

@interface MusicScoreView ()

@property(nonatomic, readwrite, strong) IBOutlet UIView *inputView;
@property(nonatomic, readwrite, strong) IBOutlet UIView *inputAccessoryView;

- (void) loadInputView;

@end

@implementation MusicScoreView

@synthesize inputView;
@synthesize inputAccessoryView;

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self loadInputView];
    }
    return self;    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadInputView];
    }
    return self;
}

- (void)loadInputView {
    UINib *inputViewNib = [UINib nibWithNibName:@"MusicScoreInputView" bundle:nil];
    [inputViewNib instantiateWithOwner:self options:nil];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
