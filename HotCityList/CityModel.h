//
//  CityModel.h
//  SinoMT
//
//  Created by SINOKJ on 16/6/21.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Hot,Objects;
@interface CityModel : NSObject
/**
 *  热门
 */
@property (nonatomic, strong) NSArray<Hot *> *hot;

@property (nonatomic, strong) NSArray<Objects *> *objects;

@end

@interface Hot : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger nHot;

@property (nonatomic, copy) NSString *initial;

@end

@interface Objects : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *name;
/**
 *  拼音
 */
@property (nonatomic, copy) NSString *phonetic;

@property (nonatomic, assign) NSInteger nHot;
/**
 *  首字母
 */
@property (nonatomic, copy) NSString *initial;

@end

