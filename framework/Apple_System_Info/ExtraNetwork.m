//
//  ExtraNetwork.m
//  Apple_System_Info
//
//  Created by ea on 16/8/5.
//  Copyright © 2016年 vk. All rights reserved.
//

#import "ExtraNetwork.h"

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#import <sys/sysctl.h>

@implementation ExtraNetwork
/*
 The thing is that pdp_ip0 is one of interfaces, all pdpXXX are WWAN interfaces
 dedicated to different functions, voicemail, general networking interface.
 
 i read in apple forum that : The OS does not keep network statistics on a
 process-by-process basis. As such, there's no exact solution to this problem.
 You can, however, get network statistics for each network interface.
 
 In general en0 is your Wi-Fi interface and pdp_ip0 is your WWAN interface.
 
 There is no good way to get information wifi/cellular network data since,
 particular date-time!
 
 data statistic (ifa_data->ifi_obytes and ifa_data->ifi_ibytes) are stored
 from previos device reboot.
 
 i don't know why, but ifi_opackets and ifi_ipackets are shown just for lo0
 (i think its main interface ).
 
 yes. Then device is conected via WiFi and doesn't use internet if_iobytes
 values still come becouse this metod provides nerwork bytes exchanges and not
 just internet .
 */
+ (NSArray <NSNumber *>*)getDataCounters;
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}

//TODO: - eth0 address family: 10 (AF_INET6) address: <fe80::2d0:59ff:feda:eb51%eth0
//http://blog.csdn.net/bluefish625/article/details/6948923
@end
