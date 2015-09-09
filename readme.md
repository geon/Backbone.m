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



Model implementation compared to Backbone.js
--------------------------------------------


Js                       | Objective C | Comment
-------------------------|-------------|---------
extend                   |             | Not idiomatic Objective C. Just use normal inheritence.
constructor / initialize |             | Not idiomatic Objective C. Just use the normal constructor.
get                      |             | Not idiomatic Objective C. Just use the properties.
set                      |             | Not idiomatic Objective C. Just use the properties.
escape                   |             | Useless outside a browser.
has                      |             | Not idiomatic Objective C. Objective C is statically typed.
unset                    |             | Not idiomatic Objective C. Objective C is statically typed.
clear                    |             | Not idiomatic Objective C. Objective C is statically typed.
id                       |             | Not idiomatic Objective C. Just use the id property.
idAttribute              | idProperty  | Read only.
cid                      |             | Not yet implemented.
attributes               |             | Not idiomatic Objective C.
changed                  |             | Not yet implemented.
defaults                 |             | Not idiomatic Objective C.
toJSON                   | JSON        |
sync                     | sync        |
fetch                    | fetch       |
save                     | save        | Not idiomatic Objective C. Can't set multiple properties at once.
destroy                  | destroy     |
Underscore Methods (9)   |             | Not idiomatic Objective C.
validate                 |             | Not yet implemented.
validationError          |             | Not yet implemented.
isValid                  |             | Not yet implemented.
url                      |             | Read only.
urlRoot                  |             | Not idiomatic Objective C.
parse                    | parse       |
clone                    |             | Not idiomatic Objective C.
isNew                    |             | Not yet implemented.
hasChanged               |             | Not yet implemented.
changedAttributes        |             | Not yet implemented.
previous                 |             | Not yet implemented.
previousAttributes       |             | Not yet implemented.
