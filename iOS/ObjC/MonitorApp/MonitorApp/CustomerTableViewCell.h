//
//  CustomerTableViewCell.h
//  MonitorApp
//
//  Created by Radwar on 8/24/17.
//  Copyright © 2017 curbside. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Curbside;

static NSString *kCustomerTableViewCellIdentifier = @"kCustomerTableViewCellIdentifier";

@interface CustomerTableViewCell : UITableViewCell

@property (nonatomic, strong)CSUserStatusUpdate *userStatusUpdate;

@end
