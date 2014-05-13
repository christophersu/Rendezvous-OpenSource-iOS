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

+ (NSDictionary *)expectUserArgumentRequest:(NSString *)argument type:(NetworkRequestType)type path:(NSString *)path {
    return [self expectUserRequest:nil type:type path:path argument:argument];
}

+ (NSDictionary *)expectUserParameterRequest:(NSDictionary *)parameters type:(NetworkRequestType)type path:(NSString *)path {
    return [self expectUserRequest:parameters type:type path:path argument:nil];
}

+ (void)expectUserRequestError:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    NSLog(@"Error: %ld", (long)operation.response.statusCode);
}

+ (NSDictionary *)expectUserRequest:(NSDictionary *)parameters type:(NetworkRequestType)type path:(NSString *)path argument:(NSString *)argument {
    NSDictionary *result = [NSDictionary new];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    switch(type) {
        case GET: {
            [manager GET:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self expectUserRequestError:operation error:error];
            }];
        }
        break;
        case POST: {
            [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self expectUserRequestError:operation error:error];
            }];
        }
        break;
        case PUT: {
            [manager PUT:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self expectUserRequestError:operation error:error];
            }];
        }
        break;
        case DELETE: {
            [manager DELETE:[NSString stringWithFormat:@"%s%@", APIBaseURL, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self handleRequestSuccess:operation responseObject:responseObject result:result];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self expectUserRequestError:operation error:error];
            }];
        }
        break;
    }
    
    return result;
}

@end
