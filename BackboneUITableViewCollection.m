
#import <UIKit/UIKit.h>
#import "BackboneUITableViewCollection.h"
#import "BackboneUITableViewModel.h"

// All ordering is implemented here. A single model on it's own can't have ordering.


@implementation BackboneUITableViewCollection

- (void)setUpUITableViewEventHandlers:(UITableView *)tableView {

	[self onEventNamed:@"change:completed"
			 inContext:nil
	   handleEventWith:^(id context, BackboneUITableViewModel *model) {

		   // Re-render the row.
		   [tableView reloadRowsAtIndexPaths:@[model.indexPath]
							withRowAnimation:UITableViewRowAnimationFade];
	   }];

	[self onEventNamed:@"add"
			 inContext:nil
	   handleEventWith:^(id context, BackboneUITableViewModel *model) {

		   // Add the row visually.
		   [tableView insertRowsAtIndexPaths:@[model.indexPath]
							withRowAnimation:UITableViewRowAnimationFade];
	   }];

	[self onEventNamed:@"destroy"
			 inContext:nil
	   handleEventWith:^(id context, BackboneUITableViewModel *model) {

		   // Delete the row visually.
		   [tableView deleteRowsAtIndexPaths:@[model.indexPath]
							withRowAnimation:UITableViewRowAnimationFade];
	   }];
}


- (BackboneModel *)findByIndexPath:(NSIndexPath *)indexPath {

	return [self findByPropertyNamed:@"row"
							 isEqual:[NSNumber numberWithInteger:indexPath.row]];
}


- (void)add:(BackboneUITableViewModel *)model {

	// Insert the new row at the end.
	model.row = self.count;

	[super add:model];
}


- (void)remove:(BackboneUITableViewModel *)removedModel {

	// Move all later rows up one step.
	for (BackboneUITableViewModel *model in [self modelsPassingTest:^BOOL (BackboneModel *model, BOOL *stop) {

		return ((BackboneUITableViewModel *)model).row > removedModel.row;

	}]) {

		--model.row;
	} ;

	[super remove:removedModel];
}

@end
