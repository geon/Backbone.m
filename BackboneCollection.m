//
//  BackboneCollection.m
//  Backbone.m Demo
//
//  Created by Victor Widell on 2015-09-05.
//  Copyright (c) 2015 Victor Widell. All rights reserved.
//

#import "BackboneCollection.h"

@implementation BackboneCollection

- (BackboneCollection *)init {

	if (self = [super init]) {

		self.models = [NSMutableArray new];
	}

	return self;
}


- (void)add:(BackboneModel *)model {

	NSLog(@"TODO: Check id and update in place if existing.");

	// Propagate change events from models.
	[model onEventNamed:@"change"
			  inContext:self
		handleEventWith:^(BackboneCollection *self, NSString *propertyName) {

			[self triggerEventNamed:@"change"
						  withEvent:@{@"model": model,
									  @"propertyName": propertyName}];

			[self triggerEventNamed:[NSString stringWithFormat:@"change:%@", propertyName]
						  withEvent:model];
		}];

	[self.models addObject:model];
	[self triggerEventNamed:@"add"
				  withEvent:model];
}


- (NSInteger)count {

	return self.models.count;
}


+ (id)collectionWithArrayOfDictionaries:(NSArray *)array {

	BackboneCollection *collection = [self new];

	for (NSDictionary *dictionary in array) {

		[collection add:
		 [NSClassFromString([self modelClassName])
		  modelWidhDictionary:dictionary]];
	}

	return collection;
}


+ (NSString *)modelClassName {

	// Please override.
	assert(0);

	return nil;
}


- (NSArray *)arrayOfDictionariesWithOptions:(BackboneModelOption)options {

	NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:self.models.count];

	for (BackboneModel *model in self.models) {

		[dictionaries addObject:[model toDictionaryWithOptions:options]];
	}

	return [NSArray arrayWithArray:dictionaries];
}

@end
