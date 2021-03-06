//
//  DataDownloader.m
//  Iran Weather
//
//  Created by aDb on 12/16/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "DataDownloader.h"
#import "XMLReader.h"
#import "WeatherData.h"
#import "JCDHTTPConnection.h"

@implementation DataDownloader
NSMutableDictionary *receivedData;
NSMutableDictionary *citiesListData;
NSMutableDictionary *warningsData;


- (void)requestData:(NSString *)params withCallback:(RequestCompleteBlock)callback
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://mshapp.sms1000.ir/data/%@.xml",params]]];
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSData *data) {
         if (response.statusCode == 200) {
             
             NSDictionary *XML = [self serializedData:data];
             receivedData = [XML valueForKey:@"row"];

             callback(YES,receivedData);
         } else {
             callback(NO,nil);
         }
     } failure:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
         callback(NO,nil);
     } didSendData:nil];
}


- (void)requestDataForLocation:(CLLocation *)location withCallback:(RequestCompleteBlock)callback
{
       
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://mshapp.sms1000.ir/data/%@.xml",@""]]];
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSData *data) {
         if (response.statusCode == 200) {
             
             NSDictionary *XML = [self serializedData:data];
             receivedData = [XML valueForKey:@"row"];
             
             callback(YES,receivedData);
         } else {
             callback(NO,nil);
         }
     } failure:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
         callback(NO,nil);
     } didSendData:nil];
}


- (void)RequestCitiesList:(RequestCompleteBlock)callback
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mshapp.sms1000.ir/Stations.xml"]];
    
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSData *data) {
         if (response.statusCode == 200) {
             
             NSDictionary *XML = [self serializedData:data];
             citiesListData = [XML valueForKey:@"stations"];
             citiesListData = [citiesListData valueForKey:@"station"];
             callback(YES,citiesListData);
         } else {
             callback(NO,nil);
         }
     } failure:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
         callback(NO,nil);
     } didSendData:nil];

}

- (void)RequestWarnings:(RequestCompleteBlock)callback
{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mshapp.sms1000.ir/Warnings.xml"]];
    
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSData *data) {
         if (response.statusCode == 200) {
             
             NSDictionary *XML = [self serializedData:data];
             warningsData = [XML valueForKey:@"Warnings"];
             warningsData = [warningsData valueForKey:@"Warning"];
             callback(YES,warningsData);
         } else {
             callback(NO,nil);
         }
     } failure:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
         callback(NO,nil);
     } didSendData:nil];
    
}


- (NSDictionary *)serializedData:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                   error:&error];
    return dict;
}

@end
