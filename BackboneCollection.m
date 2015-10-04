//
//  BackboneCollection.m
//  Backbone.m Demo
//
//  Created by Victor Widell on 2015-09-05.
//  Copyright (c) 2015 Victor Widell. All rights reserved.
//

#import "BackboneCollection.h"

@interface BackboneCollection ()

@property(nonatomic, strong) NSMutableSet <BackboneModel*> *models;

@end


@implementation BackboneCollection

- (BackboneCollection *)init {

	if (self = [super init]) {

		self.models = [NSMutableSet new];
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

	// Remove the model when destroyed.
	[model onEventNamed:@"destroy"
			  inContext:self
		handleEventWith:^(BackboneCollection *self, id model) {

			[self remove:model];

			[self triggerEventNamed:@"destroy"
						  withEvent:model];
		}];

	[self.models addObject:model];
	[self triggerEventNamed:@"add"
				  withEvent:model];
}


- (void)remove:(BackboneModel *)model {

	[self.models removeObject:model];
	[self triggerEventNamed:@"remove"
				  withEvent:model];
}


- (NSInteger)count {

	return self.models.count;
}


- (NSSet<BackboneModel *> *)unsorted {

	return [NSSet setWithSet:self.models];
}


- (NSSet *)modelsPassingTest:(BOOL (^)(BackboneModel *model, BOOL *stop))predicate {

	return [self.models objectsPassingTest:predicate];
}


- (BackboneModel *)findByPropertyNamed:(NSString *)propertyName isEqual:(id)value {

	for (BackboneModel *model in self.models) {

		if ([[model valueForKeyPath:propertyName] isEqual:value]) {

			return model;
		}
	}

	return nil;
}


+ (id)collectionWithArrayOfDictionaries:(NSArray *)array {

	BackboneCollection *collection = [self new];

	for (NSDictionary *dictionary in array) {

		[collection add:
		 [self.modelClass modelWidhDictionary:dictionary]];
	}

	return collection;
}


+ (Class)modelClass {

	// Please override.
	assert(0);

	return BackboneModel.class;
}


- (NSArray *)arrayOfDictionariesWithOptions:(BackboneModelOption)options {

	NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:self.models.count];

	for (BackboneModel *model in self.models) {

		[dictionaries addObject:[model toDictionaryWithOptions:options]];
	}

	return [NSArray arrayWithArray:dictionaries];
}

@end
