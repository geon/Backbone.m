
#import <UIKit/UIKit.h>
#import "BackboneUITableViewModel.h"


@implementation BackboneUITableViewModel

- (NSIndexPath *)indexPath {

	return [NSIndexPath indexPathForRow:self.row
							  inSection:0];
}

@end
