//
//  CSRendezvousNetworking.m
//  Rendezvous
//
//  Created by Christopher Su on 5/12/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "CSRendezvousNetworking.h"
#import "Globals.h"
#import "AFNetworking/AFNetworking.h"

@implementation CSRendezvousNetworking : NSObject

+ (void)prepareDictionaryUnexpected:(NSDictionary *)result data:(NSDictionary *)data {
    [result setValue:[NSNumber numberWithBool:NO] forKey:@"success"];
    [result setValue:[data objectForKey:@"status"] forKey:@"data"];
}

+ (void)prepareDictionaryExpected:(NSDictionary *)result data:(NSDictionary *)data {
    [result setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
    [result setValue:data forKey:@"data"];
}

+ (void)handleRequestSuccess:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject result:(NSDictionary *)result {
    NSDictionary *json = ((NSDictionary *)responseObject);
    if ([json objectForKey:@"status"]) {
        NSLog(@"Expected user object, got status.");
        [self prepareDictionaryUnexpected:result data:json];
    }
    else {
        [self prepareDictionaryExpected:result data:json];
    }
}

+ (NSDictionary *)expectUserRequest:(NSDictionary *)parameters type:(NetworkRequestType)type path:(NSString *)path {
    NSDictionary *result = [NSDictionary new];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    switch(type) {
        case GET: {
            [manager GET:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %ld", (long)operation.response.statusCode);
            }];
        }
        break;
        case POST: {
            [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %ld", (long)operation.response.statusCode);
            }];
        }
        break;
        case PUT: {
            [manager PUT:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %ld", (long)operation.response.statusCode);
            }];
        }
        break;
        case DELETE: {
            [manager DELETE:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %ld", (long)operation.response.statusCode);
            }];
        }
        break;
    }
    
    return result;
}

@end
