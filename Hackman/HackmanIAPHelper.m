//
//  HackmanIAPHelper.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/3/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "HackmanIAPHelper.h"

@implementation HackmanIAPHelper

static HackmanIAPHelper * _sharedHelper;

+ (HackmanIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[HackmanIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"com.adityaherlambang.inapphackman.hackmanwords",
                                nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
