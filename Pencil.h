//
//  Pencil.h
//
//  Created by j.chn@ya.ru on 14-9-30.
//  Copyright (c) 2014年 j.chn. All rights reserved.
//  将百度坐标转换为GPS or GCJ 坐标

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface Pencil : NSObject

-(id)initWithCoordType:(BMK_COORD_TYPE)type;

- (CLLocationCoordinate2D)b2x: (CLLocationCoordinate2D)bCoord;

@end
