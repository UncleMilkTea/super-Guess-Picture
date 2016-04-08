//
//  dataModel.h
//  超级猜图
//
//  Created by 侯玉昆 on 15/12/21.
//  Copyright © 2015年 侯玉昆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject

@property(copy,nonatomic) NSString *answer;

@property(copy,nonatomic) NSString *icon;

@property(copy,nonatomic) NSString *title;

@property(strong,nonatomic) NSArray *options;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)dataWithModel:(NSDictionary *)dict;

@end
