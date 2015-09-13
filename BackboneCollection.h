//
//  BackboneCollection.h
//  Backbone.m Demo
//
//  Created by Victor Widell on 2015-09-05.
//  Copyright (c) 2015 Victor Widell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BackboneEvents.h"
#import "BackboneModel.h"

@interface BackboneCollection : NSObject <BackboneEventsProtocol>

@property(nonatomic, strong) NSArray *models;
- (NSArray *)arrayOfDictionariesWithOptions:(BackboneModelOption)options;

@end
