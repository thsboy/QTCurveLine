//
//  AppDelegate.h
//  QTCurveLineDemo
//
//  Created by thsboy on 2020/7/22.
//  Copyright © 2020 qdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

