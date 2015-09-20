
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
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for(i = 0; i < outCount; i++) {

		NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
		[propertyNames addObject:propertyName];
	}
	free(properties);

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

			SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [propertyName capitalizedString]]);
			NSMethodSignature * signature = [model.class instanceMethodSignatureForSelector:selector];
			NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:model];
			[invocation setSelector:selector];

			switch ([signature getArgumentTypeAtIndex:2][0]) {

				case 'c': {

					char primitiveValue;

					// The "char" type can also be a BOOL, char integer or a character, so check the actual value.
					if ([value isKindOfClass:[NSString class]]) {

						// Interpret a string like a character.
						primitiveValue = [value characterAtIndex:0];

					} else {

						// Interpret NSNumber as a char integer (possibly a BOOL).
						primitiveValue = [value charValue];
					}

					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];

				} break;

				case 'i': {
					int primitiveValue = [value intValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 's': {
					short primitiveValue = [value shortValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'l': {
					long primitiveValue = [value longValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'q': {
					long long primitiveValue = [value longLongValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'C': {
					unsigned char primitiveValue = [value unsignedCharValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'I': {
					unsigned int primitiveValue = [value unsignedIntValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'S': {
					unsigned short primitiveValue = [value unsignedShortValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'L': {
					unsigned long primitiveValue = [value unsignedLongValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'Q': {
					unsigned long long primitiveValue = [value unsignedLongLongValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'f': {
					float primitiveValue = [value floatValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'd': {
					double primitiveValue = [value doubleValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case 'B': {
					BOOL primitiveValue = [value boolValue];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case '*': {
					const char *primitiveValue = [value cStringUsingEncoding:NSUTF8StringEncoding];
					[invocation setArgument:(void *) &primitiveValue
									atIndex:2];
				} break;

				case '@': {

// TODO: Support models and collections recursively.

//					Class modelClass = [self modelClassForPropertyName:propertyName];
//					if (modelClass) {
//
//						value = [modelClass modelWidhDictionary:value];
//					}

					[invocation setArgument:(void *) &value
									atIndex:2]; // 0: self, 1: selector, 2-n: arguments
				} break;

				default:
					assert(0);
			}

			[invocation invoke];
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

		SEL selector = NSSelectorFromString(propertyName);
		NSMethodSignature * signature = [self.class instanceMethodSignatureForSelector:selector];
		NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:self];
		[invocation setSelector:selector];
		[invocation invoke];

		void *untypedValue = malloc(signature.methodReturnLength);
		[invocation getReturnValue:untypedValue];

		id value = nil;
		switch (signature.methodReturnType[0]) {

			case 'c':
				value = [NSString stringWithFormat:@"%c", *((char *) untypedValue)];
				break;

			case 'i':
				value = [NSNumber numberWithInt:*((int *) untypedValue)];
				break;

			case 's':
				value = [NSNumber numberWithShort:*((short *) untypedValue)];
				break;

			case 'l':
				value = [NSNumber numberWithLong:*((long *) untypedValue)];
				break;

			case 'q':
				value = [NSNumber numberWithLongLong:*((long long *) untypedValue)];
				break;

			case 'C':
				value = [NSNumber numberWithUnsignedChar:*((unsigned char *) untypedValue)];
				break;

			case 'I':
				value = [NSNumber numberWithUnsignedInt:*((unsigned int *) untypedValue)];
				break;

			case 'S':
				value = [NSNumber numberWithUnsignedShort:*((unsigned short *) untypedValue)];
				break;

			case 'L':
				value = [NSNumber numberWithUnsignedLong:*((unsigned long *) untypedValue)];
				break;

			case 'Q':
				value = [NSNumber numberWithUnsignedLongLong:*((unsigned long long *) untypedValue)];
				break;

			case 'f':
				value = [NSNumber numberWithFloat:*((float *) untypedValue)];
				break;

			case 'd':
				value = [NSNumber numberWithDouble:*((double *) untypedValue)];
				break;

			case 'B':
				value = [NSNumber numberWithBool:*((BOOL *) untypedValue)];
				break;

			case '*':
				value = [NSString stringWithUTF8String:((char *) untypedValue)];
				break;

			case '@':
				if ([value isKindOfClass:[BackboneModel class]]) {

					value = [((__bridge BackboneModel *) untypedValue) toDictionaryWithOptions:options];

				} else if ([value isKindOfClass:[BackboneCollection class]]) {

					value = [((__bridge BackboneCollection *) untypedValue) arrayOfDictionariesWithOptions:options];

				} else {

					value = (__bridge id) untypedValue;
				}
				break;

			default:
				assert(0);
		}

		free(untypedValue);

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
