pencil
======

百度坐标转gps坐标 or gcj 坐标

示例：
------

______
转换为gps坐标

  Pencil *gpsPencil = [[Pencil alloc]initWithCoordType:BMK_COORDTYPE_GPS];

  CLLocationCoordinate2D gpsCoord = [gpsPencil b2x:baiduCoord];

______
转换为gcj坐标

  Pencil *gcjPencil = [[Pencil alloc]initWithCoordType:BMK_COORDTYPE_OMMON];

  CLLocationCoordinate2D gcjCoord = [gcjPencil b2x:baiduCoord];

______

