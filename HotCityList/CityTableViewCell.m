//
//  CityTableViewCell.m
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import "CityTableViewCell.h"
#define  ScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation CityTableViewCell


- (void)setHotModel:(NSArray<Hot *> *)hotModel {
    if (_hotModel != hotModel) {
        _hotModel = nil;
        _hotModel = hotModel;
        [self prepareLayout];
    }
}

- (void)prepareLayout {
    for(int i=0;i<self.hotModel.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.center = CGPointMake(ScreenWidth/6+(ScreenWidth/3-10)*(i%3), 32+(30+15)*(i/3));
        btn.tag = i + 1000;
        btn.bounds = CGRectMake(0, 0, ScreenWidth/3-28, 32);
        [btn setTitleColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1] forState:0];
        Hot *hot = self.hotModel[i];
        [btn setTitle:hot.name forState:0];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:btn];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    }
}

-(void)click:(UIButton *)btn {
//    if(_hotModel.count == 1 & btn.tag == 0) {
//        self.didSelectedBtn(_hotModel[btn.tag - 1000].code,_hotModel[btn.tag - 1000].name
//);
//    }else {
//        self.didSelectedBtn(_hotModel[btn.tag - 1000].code,_hotModel[btn.tag - 1000].name);
//    }
    Hot *ht = _hotModel[btn.tag-1000];
    self.didSelectedBtn(ht.code,ht.name);

}
@end
