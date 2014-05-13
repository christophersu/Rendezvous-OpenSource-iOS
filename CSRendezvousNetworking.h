//
//  Globals.h
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRendezvousNetworking : NSObject

#define APIBaseURL "http://69.91.217.124"

typedef NS_ENUM(NSInteger, NetworkRequestType) {
    GET,
    POST,
    PUT,
    DELETE
};

+ (NSDictionary *)expectUserRequest:(NSDictionary *)parameters type:(NetworkRequestType)type path:(NSString *)path;

@end
