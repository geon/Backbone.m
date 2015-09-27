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

- (void)add:(BackboneModel *)model;
- (void)remove:(BackboneModel *)model;
- (NSInteger)count;
- (NSSet<BackboneModel *> *)unsorted;
- (NSSet *)modelsPassingTest:(BOOL (^)(BackboneModel *model, BOOL *stop))predicate;
- (BackboneModel *)findByPropertyNamed:(NSString *)propertyName isEqual:(id)value;

// Deserialization
+ (id)collectionWithArrayOfDictionaries:(NSArray *)array;
+ (NSString *)modelClassName;

// Serialization
- (NSArray *)arrayOfDictionariesWithOptions:(BackboneModelOption)options;

@end
