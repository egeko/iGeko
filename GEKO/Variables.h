//
//  Variables.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#ifndef GEKO_Variables_h
#define GEKO_Variables_h

#define SWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define NAV_SHEIGHT ([[UIScreen mainScreen] bounds].size.height) - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif
