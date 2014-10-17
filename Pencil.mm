//
//  Pencil.mm
//
//  Created by j.chn@ya.ru on 14-9-30.
//  Copyright (c) 2014年 j.chn@ya.ru. All rights reserved.
//

#import "Pencil.h"
#import "BMapKit.h"

/*
 对于固定输入g2b，返回值不固定，已测试到到波动范围：［0,0.00002f]。因此以0.00001f作为b2g的终止是在误差范围内
 */
static double const DeltaLimit = 0.00001f;
static double const ContractionRatio = sqrt(2.0f)/2.0f;
static double const WidthStart = 0.1f;
static double const WidthLimit = 0.000001f;

@implementation Pencil

// 百度IOS SDK: GPS坐标 -> 百度坐标
- (CLLocationCoordinate2D)g2b: (CLLocationCoordinate2D)gpsCoord
{
    return BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(gpsCoord, BMK_COORDTYPE_GPS));
}
// 坐标值比较
- (double) coordDelta:(CLLocationCoordinate2D) left right:(CLLocationCoordinate2D)right
{
    return fabs(left.latitude - right.latitude)+fabs(left.longitude - right.longitude);
}
// 网络传播的（低精度）：百度坐标 -> GPS坐标
-(CLLocationCoordinate2D)netB2g:(CLLocationCoordinate2D)badCoord
{
    CLLocationCoordinate2D t = [self g2b:badCoord];
    double gpsLongitude = 2 * t.longitude - badCoord.longitude;
    double gpsLatitude = 2 * t.latitude - badCoord.latitude;
    return CLLocationCoordinate2DMake(gpsLatitude, gpsLongitude);
}
// 高精度：百度坐标 -> GPS坐标
- (CLLocationCoordinate2D)b2g: (CLLocationCoordinate2D)badCoord
{
    CLLocationCoordinate2D resGps = [self netB2g:badCoord];
    
    double lastDelta = [self coordDelta:badCoord right:[self g2b:resGps]];
    double width = WidthStart;
    
    while (lastDelta > DeltaLimit && width > WidthLimit) {
        
        CLLocationCoordinate2D gpsCoords[] = {
            CLLocationCoordinate2DMake(resGps.latitude + width, resGps.longitude + width),
            CLLocationCoordinate2DMake(resGps.latitude + width, resGps.longitude - width),
            CLLocationCoordinate2DMake(resGps.latitude - width, resGps.longitude + width),
            CLLocationCoordinate2DMake(resGps.latitude - width, resGps.longitude - width)};
        
        double deltas[4];
        for (int i =0; i<4; i++) {
            deltas[i] = [self coordDelta:badCoord right:[self g2b:gpsCoords[i]]];
        }
        int j = 0;
        for (int i=1; i<4; i++) {
            if (deltas[i] < deltas[j]) {
                j = i;
            }
        }
        lastDelta = deltas[j];
        resGps = gpsCoords[j];
        
        width *= ContractionRatio;
    }
    return resGps;
}
@end
