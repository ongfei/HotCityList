//
//  CityTableViewCell.h
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"

@interface CityTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray<Hot *> *hotModel;
@property (nonatomic,copy) void(^didSelectedBtn)(NSString *code, NSString *cityName);
@end
