///
//  DBManager.h
//  Iran Weather
//
//  Created by aDb on 12/19/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

#define debugMethod(...) NSLog((@"In %s,%s [Line %d] "), __PRETTY_FUNCTION__,__FILE__,__LINE__,##__VA_ARGS__)
static FMDatabase *shareDataBase = nil;
@implementation DBManager


 

//+ (FMDatabase *)createDataBase {
//    //debugMethod();
//    @synchronized (self) {
//        if (shareDataBase == nil) {
//
//            shareDataBase = [[FMDatabase databaseWithPath:dataBasePath] retain];
//        }
//        return shareDataBase;
//    }
//}




+ (FMDatabase *)createDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataBase = [FMDatabase databaseWithPath:dataBasePath];
    });
    return shareDataBase;
}


+ (BOOL) isTableExist:(NSString *)tableName
{
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"%@ isOK %ld", tableName,(long)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}


+ (BOOL)createTable {
 
    NSLog(@"%@",dataBasePath);
    if (1){
        {
            shareDataBase = [DBManager createDataBase];
            if ([shareDataBase open]) {
                if (![DBManager isTableExist:@"setting_table"]) {
                    NSString *sql = @"CREATE TABLE \"setting_table\" (\"setting_id\" TEXT PRIMARY KEY  NOT NULL , \"cityInfo\" TEXT NOT NULL)";
                    NSLog(@"no Medicine ");
                    [shareDataBase executeUpdate:sql];
                }
                [shareDataBase close];
            }
        }
    }
    return YES;
}


+ (void)closeDataBase {
    if(![shareDataBase close]) {
        NSLog(@"connection Closed.");
        return;
    }
}

+ (void)deleteDataBase {
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        [shareDataBase executeUpdate:@"DROP TABLE \"setting_table\" "];
    }
    [shareDataBase close];}

+ (BOOL) saveOrUpdataSetting:(Settings *)weatherData
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"INSERT INTO \"setting_table\" (\"setting_id\",\"cityInfo\") VALUES(?,?)",weatherData.settingId,weatherData.cityInfo];
        [shareDataBase close];
    }
    return isOk;
}

+ (Settings *) selectSettingBySettingId:(NSString*)SettingId
{
    Settings *m = nil;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM \"setting_table\" WHERE \"setting_id\" = '%@'",SettingId]];
        if ([s next]) {
            m = [[Settings alloc] init];
            m.SettingId = [s stringForColumn:@"setting_id"];
            m.cityInfo = [s stringForColumn:@"cityInfo"];
        }
        [shareDataBase close];
    }
    return m;
}

+(void) deleteRow:(NSString*)ObjId
{
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        [shareDataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM \"setting_table\" WHERE \"setting_id\"=%@",ObjId]];
    }
    [shareDataBase close];
}

+ (NSMutableArray *) selectSetting
{
    Settings *m = nil;
    NSMutableArray *settingArray = [[NSMutableArray alloc]init];
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:@"SELECT * FROM \"setting_table\""];
        while ([s next]) {
            m = [[Settings alloc] init];
            m.SettingId = [s stringForColumn:@"setting_id"];
            m.cityInfo = [s stringForColumn:@"cityInfo"];
            [settingArray addObject:m];
        }
        
        [shareDataBase close];
    }
    return settingArray;
}
@end
