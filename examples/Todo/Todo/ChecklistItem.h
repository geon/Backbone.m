//
//  ChecklistItem.h
//  Todo
//
//  Created by Victor Widell on 2015-09-20.
//  Copyright © 2015 Victor Widell. All rights reserved.
//

#import "BackboneModel.h"

@interface ChecklistItem : BackboneModel

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL completed;

@end
