//
//  KeyboardInputView.h
//  Todo
//
//  Created by Victor Widell on 2015-10-01.
//  Copyright © 2015 Victor Widell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardBar : UIVisualEffectView
@property (nonatomic, weak) IBOutlet UITextField *inputView;
@end


@class KeyboardInputView;
@protocol KeyboardInputViewDelegate <NSObject>

- (void)inputString:(NSString *)string withKeyboardInputview:(KeyboardInputView *)view;

@end


@interface KeyboardInputView : UIView <UITextFieldDelegate>

@property (nonatomic, readwrite, strong) KeyboardBar *inputAccessoryView;
@property (nonatomic, weak) id<KeyboardInputViewDelegate> delegate;

+ (KeyboardInputView *)viewWithKeyboardBar:(KeyboardBar *)keyboardBar
								 superView:(UIView *)superView
								  delegate:(id<KeyboardInputViewDelegate>)delegate;
- (BOOL)show;
- (BOOL)hide;

@end
