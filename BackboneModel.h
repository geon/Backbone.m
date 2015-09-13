
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


// Really should return promises.
- (void)saveWithOptions:(BackboneModelOption)options;
- (void)fetchWithOptions:(BackboneModelOption)options;
- (void)destroyWithOptions:(BackboneModelOption)options;
- (void)syncUsingMethod:(NSString *)method
			withOptions:(BackboneModelOption)options;

+ (NSURL *)urlForModel:(BackboneModel *)model;

@end
