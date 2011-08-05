//
//  GCDatabase.m
//  Hackman
//
//  Created by Aditya Herlambang on 8/4/11.
//  Copyright 2011 University of Arizona. All rights reserved.
//

#import "GCDatabase.h"


NSString * pathForFile(NSString * filename){
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}

id loadData(NSString * filename){
    NSString * filePath = pathForFile(filename);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data = [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
        
        NSKeyedUnarchiver * unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
        id retVal = [unarchiver decodeObjectForKey:@"Data"];
        [unarchiver finishDecoding];
        return retVal;
    }
    return nil;
}

void saveData (id theData, NSString * filename){
    NSMutableData *data = [[[NSMutableData alloc]init] autorelease];
    NSKeyedArchiver * archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:theData forKey:@"Data"];
    [archiver finishEncoding];
    [data writeToFile:pathForFile(filename) atomically:YES];
}


