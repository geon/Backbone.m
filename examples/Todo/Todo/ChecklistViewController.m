//
//  ChecklistViewController.m
//  Todo
//
//  Created by Victor Widell on 2015-09-20.
//  Copyright © 2015 Victor Widell. All rights reserved.
//

#import "ChecklistViewController.h"

@interface ChecklistViewController ()

@end

@implementation ChecklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.collection = [Checklist collectionWithArrayOfDictionaries:
					   @[@{@"title": @"First", @"completed": @true},
						 @{@"title": @"Then", @"completed": @false},
						 @{@"title": @"Also", @"completed": @false}]];

	[self.collection setUpUITableViewEventHandlers:self.tableView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return self.collection.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem" forIndexPath:indexPath];

	ChecklistItem *item = (ChecklistItem *) [self.collection findByPropertyNamed:@"indexPath" isEqual:indexPath];

	cell.textLabel.text = item.title;
	cell.accessoryType = item.completed
	? UITableViewCellAccessoryCheckmark
	: UITableViewCellAccessoryNone;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	ChecklistItem *item = (ChecklistItem *) [self.collection findByPropertyNamed:@"indexPath" isEqual:indexPath];
	item.completed = !item.completed;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

	if (editingStyle == UITableViewCellEditingStyleDelete) {

		// Trigger deletion.
		[[self.collection findByPropertyNamed:@"indexPath" isEqual:indexPath] destroyWithOptions:0];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];

	if (editing) {

		// Add the + button
		UIBarButtonItem *addButton =
		[[UIBarButtonItem alloc]
		 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
		 target:self
		 action:@selector(createModel:)];

		self.navigationItem.leftBarButtonItem = addButton;

	} else {

		// remove the + button
		self.navigationItem.leftBarButtonItem = nil;
	}
}

- (void)createModel:(id)sender {

	[self.collection add:
	 [ChecklistItem modelWidhDictionary:
	  @{@"title": @"New"}]];
}

@end
