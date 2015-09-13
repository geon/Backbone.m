//
//  BackboneCollection.m
//  Backbone.m Demo
//
//  Created by Victor Widell on 2015-09-05.
//  Copyright (c) 2015 Victor Widell. All rights reserved.
//

#import "BackboneCollection.h"

@implementation BackboneCollection

- (NSArray *)arrayOfDictionariesWithOptions:(BackboneModelOption)options {

	NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:self.models.count];

	for (BackboneModel *model in self.models) {

		[dictionaries addObject:[model toDictionaryWithOptions:options]];
	}

	return [NSArray arrayWithArray:dictionaries];
}

@end
