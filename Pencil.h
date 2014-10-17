//
//  Pencil.h
//  Created by j.chn@ya.ru on 14-9-30.
//  Copyright (c) 2014年 j.chn@ya.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface Pencil : NSObject

//百度坐标转换成GPS坐标

- (CLLocationCoordinate2D)b2g: (CLLocationCoordinate2D)badCoord;

@end
