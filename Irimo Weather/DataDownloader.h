//
//  DataDownloader.h
//  Iran Weather
//
//  Created by aDb on 12/16/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestCompleteBlock) (BOOL wasSuccessful,NSMutableDictionary *recievedData);

@interface DataDownloader : NSObject

- (void)RequestCitiesList:(RequestCompleteBlock)callback;
- (void)RequestWarnings:(RequestCompleteBlock)callback;
- (void)requestData:(NSString *)params withCallback:(RequestCompleteBlock)callback;
- (void)requestDataForLocation:(CLLocation *)location withCallback:(RequestCompleteBlock)callback;
- (NSDictionary *)serializedData:(NSData *)data;
@end
