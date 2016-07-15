//
//  CitySelectController.h
//  SinoMT
//
//  Created by SINOKJ on 16/7/15.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "ViewController.h"

typedef void (^CityBlock)(NSString *cityName,NSString *code);//block

@interface CitySelectController : ViewController

@property (nonatomic, copy) CityBlock cityBlock;

@end
