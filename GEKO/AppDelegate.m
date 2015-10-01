//
//  AppDelegate.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    CLLocationManager *locationManager;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Default NavigationBar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:97/255.0f green:172/255.0f blue:185/255.0f alpha:1.0f]];
    
    // Test
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // are you running on iOS8?
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
        
    } else {
        // iOS 7 or earlier
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    // SQLite Database
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"GekoDB.sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        [database executeUpdate:@"CREATE TABLE userInfos (id INTEGER  PRIMARY KEY DEFAULT NULL,nom TEXT DEFAULT NULL,prenom TEXT DEFAULT NULL,carteid TEXT DEFAULT NULL,cartestatus TEXT DEFAULT NULL,password TEXT DEFAULT NULL)"];
        [database executeUpdate:@"CREATE TABLE userPref (id INTEGER  PRIMARY KEY DEFAULT NULL,pref1 INTEGER DEFAULT NULL,pref2 INTEGER DEFAULT NULL,pref3 INTEGER DEFAULT NULL,pref4 INTEGER DEFAULT NULL,pref5 INTEGER DEFAULT NULL,pref6 INTEGER DEFAULT NULL,pref7 INTEGER DEFAULT NULL,pref8 INTEGER DEFAULT NULL)"];
        [database executeUpdate:@"INSERT INTO userPref (id, pref1, pref2, pref3, pref4, pref5, pref6, pref7, pref8) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1],[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
        [database close];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
