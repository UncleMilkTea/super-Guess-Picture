//
//  dataModel.m
//  超级猜图
//
//  Created by 侯玉昆 on 15/12/21.
//  Copyright © 2015年 侯玉昆. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)dataWithModel:(NSDictionary *)dict{

    return [[self alloc]initWithDict:dict];
}
@end
