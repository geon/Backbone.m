
#import <Foundation/Foundation.h>
#import "NSObject+BackboneEvents.h"

@interface BackboneModel : NSObject <BackboneEventsProtocol>

- (NSSet *)propertyNames;

@end
