//
//  MusicScoreInputView.h
//  CustomInputViewDemo
//
//  Created by Jonah Williams on 3/11/12.
//  Copyright (c) 2012 Carbon Five. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicScoreView;

@interface MusicScoreInputView : UIView

@property (nonatomic, weak) IBOutlet MusicScoreView *delegate;

@end
