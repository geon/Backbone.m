
#import "BackboneModel.h"


@interface BackboneUITableViewModel : BackboneModel

@property(nonatomic, assign) NSInteger row;

- (NSIndexPath *)indexPath;

@end
