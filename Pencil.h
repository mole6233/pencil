//
//  Pencil.h
//
//  Created by j.chn@ya.ru on 14-9-30.
//  Copyright (c) 2014年 j.chn. All rights reserved.
//  将百度坐标/火星坐标/GPS坐标 互相转换
//  依赖：baidu map sdk
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface Pencil : NSObject

// baidu -> gps
+ (CLLocationCoordinate2D)b2g: (CLLocationCoordinate2D)bCoord;
// baidu -> gcj
+ (CLLocationCoordinate2D)b2w: (CLLocationCoordinate2D)bCoord;

// gcj -> gps
+ (CLLocationCoordinate2D)w2g: (CLLocationCoordinate2D)wCoord;
// gcj -> baidu
+ (CLLocationCoordinate2D)w2b: (CLLocationCoordinate2D)wCoord;

// gps -> gcj
+ (CLLocationCoordinate2D)g2w: (CLLocationCoordinate2D)gCoord;
// gps -> baidu
+ (CLLocationCoordinate2D)g2b: (CLLocationCoordinate2D)gCoord;

@end
