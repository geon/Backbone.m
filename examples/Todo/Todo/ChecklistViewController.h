//
//  ChecklistViewController.h
//  Todo
//
//  Created by Victor Widell on 2015-09-20.
//  Copyright © 2015 Victor Widell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checklist.h"

@interface ChecklistViewController : UITableViewController

@property(nonatomic, strong) Checklist *collection;

@end
