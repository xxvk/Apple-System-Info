//
//  ExtraNetwork.h
//  Apple_System_Info
//
//  Created by 樊半缠 on 16/8/5.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExtraNetwork : NSObject
///get data usage's raw value ,only via C api . not found swift api yet . Maybe will be replaced in future.
+ (NSArray <NSNumber *>*)getDataCounters;

@end
