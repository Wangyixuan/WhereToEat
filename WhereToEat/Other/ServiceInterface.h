//
//  ServiceInterface.h
//  WhereToEat
//
//  Created by 王磊 on 2017/9/12.
//  Copyright © 2017年 WLtech. All rights reserved.
//

#ifndef ServiceInterface_h
#define ServiceInterface_h

//#define ServerDomain @"http://192.168.40.6:9999"
#define ServerDomain @"https://www.zhangxiaoshuai.cn"
//#define ServerDomain @"https://139.196.143.123"

// Application
#define App @"jjpush"

#define UpLoadLocationServerInterface KKStringWithFormat(@"%@/%@/appGetDataInitCoordinateServlet",ServerDomain,App)
#define UpLoadFavoriteServerInterface KKStringWithFormat(@"%@/%@/appGetDataCollectGymServlet",ServerDomain,App)
#define PushListServerInterface KKStringWithFormat(@"%@/%@/appGetDataPushGymListForUserServlet",ServerDomain,App)



#endif /* ServiceInterface_h */
 
