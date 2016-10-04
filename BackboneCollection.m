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
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end


@implementation BackboneCollection

- (BackboneCollection *)init {

	if (self = [super init]) {

		self.models = [NSMutableSet new];
	}

	return self;
}


+ (id)idOfModel:(BackboneModel *)model {

	return [model valueForKey:[self.class.modelClass idPropertyName]];
}

- (void)add:(BackboneModel *)model {

	// Check id and refuse if existing.
	id newModelId = [self.class idOfModel:model];
	if (newModelId) {

		for (BackboneModel *existingModel in self.models) {

			if ([[self.class idOfModel:existingModel] isEqual:newModelId]) {

				// Allready exists!
				return;
			}
		}
	}

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


+ (NSURL *)url {

	// Please override.
	assert(0);

	return nil;
}


+ (NSURL *)urlForModel:(BackboneModel *)model {

	return [[self url] URLByAppendingPathComponent:
			[[model valueForKey:[model.class idPropertyName]] description]];
}




- (void)fetchWithOptions:(BackboneModelOption)options {

	NSMutableURLRequest *request = [NSMutableURLRequest new];
	request.URL = self.class.url;
	request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

	(void) [[NSURLConnection alloc] initWithRequest:request
										   delegate:self
								   startImmediately:YES];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	self.response = (NSHTTPURLResponse *)response;
	self.data = [NSMutableData data];
	[self.data setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)bytes {

	[self.data appendData:bytes];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

	self.response = nil;
	self.data = nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	NSError *error = nil;

	// Catch HTTP error statii.
	NSUInteger statusCode = self.response.statusCode;
	if (statusCode >= 400) {

		error = [NSError errorWithDomain:@"fetch"
									code:statusCode
								userInfo:nil];
	}

	NSArray *JSONObject = nil;
	if (!error) {

		JSONObject = [NSJSONSerialization JSONObjectWithData:self.data
													 options:0
													   error:&error];
	}

	if (![JSONObject isKindOfClass:[NSArray class]]) {

		error = [NSError errorWithDomain:@"fetch"
									code:0
								userInfo:nil];
	}

	if (!error) {

		NSString *idPropertyName = [self.class.modelClass idPropertyName];
		for (NSDictionary *dictionary in JSONObject) {

			BackboneModel *existingModel = [self findByPropertyNamed:idPropertyName isEqual:dictionary[idPropertyName]];

			if (!existingModel) {

				[self add:[self.class.modelClass modelWidhDictionary:dictionary]];

			} else {

				for (NSString *propertyName in dictionary) {

					[existingModel setValue:dictionary[propertyName]
									 forKey:propertyName];
				}
			}
		}
	}

	self.response = nil;
	self.data = nil;
}

@end
