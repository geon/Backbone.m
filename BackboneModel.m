
#import "BackboneModel.h"
#import "BackboneCollection.h"
#import <objc/runtime.h>


@implementation BackboneModel

- (BackboneModel *)init {

	if (self = [super init]) {

		for (NSString *propertyName in self.class.propertyNames) {

			[self addObserver:self
				   forKeyPath:propertyName
					  options:0
					  context:nil];
		}
	}

	return self;
}


- (void)didChangeValueForKey:(NSString *)key {

	[self triggerEventNamed:@"change"
				  withEvent:key];

	[self triggerEventNamed:[NSString stringWithFormat:@"change:%@", key]
				  withEvent:nil];
}


- (void)dealloc {

	for (NSString *propertyName in self.class.propertyNames) {

		[self removeObserver:self
				  forKeyPath:propertyName];
	}
}


+ (NSSet *)propertyNames {

	NSMutableSet *propertyNames = [NSMutableSet new];

	unsigned int outCount, i;

	Class class = self.class;
	while (class && class != [BackboneModel class]) {

		objc_property_t *properties = class_copyPropertyList(class, &outCount);
		for(i = 0; i < outCount; i++) {

			NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
			[propertyNames addObject:propertyName];
		}
		free(properties);

		class = class_getSuperclass(class);
	}

	return [NSSet setWithSet:propertyNames];
}


+ (NSString *)idPropertyName {

	// Override to customize.
	return @"id";
}


+ (NSDictionary *)parse:(NSDictionary *)rawData {

	// Override to customize JSON parsing.
	return rawData;
}


+ (id)modelWidhDictionary:(NSDictionary *)dictionary {

	dictionary = [self parse:dictionary];

	BackboneModel *model = [self new];

	for (NSString *propertyName in model.class.propertyNames) {

		id value = [dictionary objectForKey:propertyName];
		if (value) {

// Handle this manually in parse: instead?
//			// Deserialize models and collections recursively.
//			Class modelClass = [self modelClassForPropertyName:propertyName];
//			if (modelClass) {
//
//				value = [modelClass modelWidhDictionary:value];
//			}

			[model setValue:value
					 forKey:propertyName];
		}
	}

	return model;
}


//- (NSData *)JSON {
//
//	return [NSJSONSerialization dataWithJSONObject:self.dictionary
//										   options:NSJSONWritingPrettyPrinted
//											 error:NULL];
//}


- (NSDictionary *)toDictionaryWithOptions:(BackboneModelOption)options {

	NSMutableDictionary *dictionary = [NSMutableDictionary new];

	for (NSString *propertyName in self.class.propertyNames) {

		id value = [self valueForKey:propertyName];

		// Serialize models and collections recursively.
		if ([value isKindOfClass:[BackboneModel class]]) {

			value = [(BackboneModel *)value toDictionaryWithOptions:options];

		} else if ([value isKindOfClass:[BackboneCollection class]]) {

			value = [(BackboneCollection *)value arrayOfDictionariesWithOptions:options];
		}

		[dictionary setObject:value
					   forKey:propertyName];
	}

	return [NSDictionary dictionaryWithDictionary:dictionary];
}


- (void)saveWithOptions:(BackboneModelOption)options {

// TODO:

//	[self syncUsingMethod:self.id ? @"PUT" : @"POST"
//			  withOptions:options];
}


- (void)fetchWithOptions:(BackboneModelOption)options {

	[self syncUsingMethod:@"GET"
			  withOptions:options];
}


- (void)destroyWithOptions:(BackboneModelOption)options {

	[self syncUsingMethod:@"DEL"
			  withOptions:options];
}


- (void)syncUsingMethod:(NSString *)method
			withOptions:(BackboneModelOption)options {


	// TODO:
}


+ (NSURL *)urlForModel:(BackboneModel *)model {

	// Please override.
	assert(0);
	return nil;
}

@end
