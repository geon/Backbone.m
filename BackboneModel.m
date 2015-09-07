
#import "BackboneModel.h"
#import <objc/runtime.h>

@implementation BackboneModel

- (BackboneModel *)init {

	if (self = [super init]) {

		for (NSString *propertyName in self.propertyNames) {

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

	for (NSString *propertyName in self.propertyNames) {

		[self removeObserver:self
				  forKeyPath:propertyName];
	}
}


- (NSSet *)propertyNames {

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

@end
