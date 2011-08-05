//
//  GCDatabase.h
//  Hackman
//
//  Created by Aditya Herlambang on 8/4/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * pathForFile(NSString * filename);
id loadData(NSString * filename);
void saveData(id theData, NSString * filename);

