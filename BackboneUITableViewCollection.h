
#import <UIKit/UIKit.h>
#import "BackboneCollection.h"


@interface BackboneUITableViewCollection : BackboneCollection

- (BackboneModel *)findByIndexPath:(NSIndexPath *)indexPath;
- (void)setUpUITableViewEventHandlers:(UITableView *)tableView;

// TODO:
// Interface for reordering.
// Specialized add: atRow: ?

@end
