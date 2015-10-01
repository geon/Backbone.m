//
//  KeyboardInputView.m
//  Todo
//
//  Created by Victor Widell on 2015-10-01.
//  Copyright © 2015 Victor Widell. All rights reserved.
//

// Inspired by http://derpturkey.com/uitextfield-docked-like-ios-messenger/

#import "KeyboardInputView.h"


@implementation KeyboardBar
@end


@implementation KeyboardInputView

+ (KeyboardInputView *)viewWithKeyboardBar:(KeyboardBar *)keyboardBar
								 superView:(UIView *)superView
								  delegate:(id<KeyboardInputViewDelegate>)delegate {

	// Create a responder that can get focus for typing.
	KeyboardInputView *keyboardInput = [KeyboardInputView new];
	keyboardInput.delegate = delegate;
	keyboardInput.inputAccessoryView = keyboardBar;

	// The responder HAS to be part of the view hierarchy.
	keyboardInput.hidden = YES;
	[superView addSubview:keyboardInput];

	return keyboardInput;
}


- (BOOL)canBecomeFirstResponder {

	return YES;
}


- (BOOL)becomeFirstResponder {

	// DODO: Move to some constructor.
	self.inputAccessoryView.inputView.delegate = self;

	BOOL result = [super becomeFirstResponder];
	if (result) {
		result = [self.inputAccessoryView.inputView becomeFirstResponder];
	}

	return result;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	[self.delegate inputString:self.inputAccessoryView.inputView.text
		 withKeyboardInputview:self];
	self.inputAccessoryView.inputView.text = nil;
	return NO;
}


- (BOOL)show {

	return [self becomeFirstResponder];
}


- (BOOL)hide {

	return [self.inputAccessoryView.inputView resignFirstResponder];
}

@end
