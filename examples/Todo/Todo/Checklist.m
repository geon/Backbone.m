//
//  Checklist.m
//  Todo
//
//  Created by Victor Widell on 2015-09-20.
//  Copyright © 2015 Victor Widell. All rights reserved.
//

#import "Checklist.h"

@implementation Checklist

+ (Class)modelClass {

	return ChecklistItem.class;
}


+ (NSURL *)url {

	return [NSURL URLWithString:@"https://raw.githubusercontent.com/geon/Backbone.m/master/examples/Todo/Todo/checklist-items.json"];
}

@end
