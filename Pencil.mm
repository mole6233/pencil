//
//  Pencil.mm
//
//  Created by j.chn@ya.ru on 14-9-30.
//  Copyright (c) 2014年 j.chn. All rights reserved.
//

#import "Pencil.h"

/*
 对于固定输入x2b，返回值不固定，已测试到到波动范围：［0,0.00002f]。因此以0.00001f作为b2x的终止是在误差范围内
 */
static double const DeltaLimit = 0.00001f;
static double const ContractionRatio = sqrt(2.0f)/2.0f;
static double const WidthStart = 0.1f;
static double const WidthLimit = 0.000001f;

@implementation Pencil
{
    BMK_COORD_TYPE _type;
}
-(id)initWithCoordType:(BMK_COORD_TYPE)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
// 百度IOS SDK: GPS坐标 -> 百度坐标 or
- (CLLocationCoordinate2D)x2b: (CLLocationCoordinate2D)coord
{
    return BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coord, _type));
}
// 坐标值比较
- (double) coordDelta:(CLLocationCoordinate2D) left right:(CLLocationCoordinate2D)right
{
    return fabs(left.latitude - right.latitude)+fabs(left.longitude - right.longitude);
}
//// 网络传播的（低精度）：百度坐标 -> GPS坐标 or WSG坐标
//-(CLLocationCoordinate2D)netB2g:(CLLocationCoordinate2D)bCoord
//{
//    CLLocationCoordinate2D t = [self g2b:bCoord];
//    double gpsLongitude = 2 * t.longitude - bCoord.longitude;
//    double gpsLatitude = 2 * t.latitude - bCoord.latitude;
//    return CLLocationCoordinate2DMake(gpsLatitude, gpsLongitude);
//}
// 高精度：百度坐标 -> GPS坐标 or WSG坐标
- (CLLocationCoordinate2D)b2x: (CLLocationCoordinate2D)bCoord
{
    if ([self outOfChina:bCoord]) {
        return bCoord;
    }
    CLLocationCoordinate2D xCoord = bCoord;//[self netB2g:bCoord];
    
    double lastDelta = [self coordDelta:bCoord right:[self x2b:xCoord]];
    double width = WidthStart;
    
    while (lastDelta > DeltaLimit && width > WidthLimit) {
        
        CLLocationCoordinate2D xCoords[] = {
            CLLocationCoordinate2DMake(xCoord.latitude + width, xCoord.longitude + width),
            CLLocationCoordinate2DMake(xCoord.latitude + width, xCoord.longitude - width),
            CLLocationCoordinate2DMake(xCoord.latitude - width, xCoord.longitude + width),
            CLLocationCoordinate2DMake(xCoord.latitude - width, xCoord.longitude - width)};
        
        double deltas[4];
        for (int i =0; i<4; i++) {
            deltas[i] = [self coordDelta:bCoord right:[self x2b:xCoords[i]]];
        }
        int j = 0;
        for (int i=1; i<4; i++) {
            if (deltas[i] < deltas[j]) {
                j = i;
            }
        }
        lastDelta = deltas[j];
        xCoord = xCoords[j];
        
        width *= ContractionRatio;
    }
    return xCoord;
}
-(BOOL) outOfChina:(CLLocationCoordinate2D) bCoord
{
    if (bCoord.longitude < 72.004 || bCoord.longitude > 137.8347)
        return YES;
    if (bCoord.latitude < 0.8293 || bCoord.latitude > 55.8271)
        return YES;
    return NO;
}
@end
