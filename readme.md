Backbone.m
==========

Use Backbone models in Objective C.

Example

```objective-c

#import "BackboneModel.h"

@interface User : BackboneModel

@property(nonatomic, assign) NSInteger likes;
@property(nonatomic, strong) NSString *name;

@end

```

That's all you need to have a fully working Backbone model.

Usage

```objective-c

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [User new];
    self.model.name = @"geon"

    for (NSString *propertyName in self.model.propertyNames) {

        [self updateView:propertyName];
    }

    [self.model onEventNamed:@"change"
                   inContext:self
             handleEventWith:^(FirstViewController *self, NSString *propertyName) {

                 [self updateView:propertyName];
             }];
}


- (void)updateView:(NSString *)propertyName {

    if ([@"name" isEqualToString:propertyName] || [@"likes" isEqualToString:propertyName] ) {

        self.likesLabel.text = [NSString stringWithFormat:@"%@ has %i likes", self.model.name, self.model.likes];
    }
}


- (IBAction)pressedLikeButton:(id)sender {

    self.model.likes++;
}

```

Simple, no?



So far
------
* Change events
* Models

Wanted
------
* All relevant events
* Collections
* JSON
  * Parsing
  * Encoding
* REST

