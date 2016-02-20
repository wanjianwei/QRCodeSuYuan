//
//  AppDelegate.m
//  PresentationLayer
//
//  Created by jway on 14-10-3.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@implementation AppDelegate
Reachability*reach1;
Reachability*reach2;

//增加一个判断程序不是第一次进入前台的标志
int flag=0;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
           // Override point for customization after application launch.
        
            //判断是不是第一次启动应用
           if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
               {
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
                        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
                       DemoViewController *userGuideViewController = [[DemoViewController alloc] init];
                        self.window.rootViewController = userGuideViewController;
                     }
           else
               {
                       //如果不是第一次启动的话,使用登陆作为根视图
                   UIStoryboard*mainStoryBoard=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
               ViewController*view =[mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstViewController"];
                      self.window.rootViewController =view;
                   
               
                   }
           [self.window makeKeyAndVisible];
    /*
         reach1=[Reachability reachabilityForInternetConnection];
         reach2=[Reachability reachabilityForLocalWiFi];
        [reach1 startNotifier];
        [reach2 startNotifier];
    if ([reach1 currentReachabilityStatus]==NotReachable&&[reach2 currentReachabilityStatus]==NotReachable)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkbreakNOtification" object:nil];
    }
    */
         return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    flag=flag+1;

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //再次进入前台是socket连接可能已经断开了
    if (flag!=0)
    {
        
        BusinessLogicLayer*layer=[BusinessLogicLayer shareManaged];
        if (layer.socket1.isConnected==NO)
        {
            [layer connectWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"IP"] AndPort:8808];
        }
    }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end