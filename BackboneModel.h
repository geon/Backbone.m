
#import <Foundation/Foundation.h>
#import "NSObject+BackboneEvents.h"

typedef enum {
	BackboneModelOptionWait,
	BackboneModelOptionPrettyPrint,
} BackboneModelOption;


@interface BackboneModel : NSObject <BackboneEventsProtocol>

+ (NSSet *)propertyNames;
+ (NSString *)idPropertyName;

+ (NSDictionary *)parse:(NSDictionary *)rawData;
+ (id)modelWidhDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionaryWithOptions:(BackboneModelOption)options;


// Really should return promises. (Or a new object that will eventually trigger a sync event?)
- (void)saveWithOptions:(BackboneModelOption)options;
- (void)fetchWithOptions:(BackboneModelOption)options;
- (void)destroyWithOptions:(BackboneModelOption)options;
- (void)syncUsingMethod:(NSString *)method
			withOptions:(BackboneModelOption)options;

@end
