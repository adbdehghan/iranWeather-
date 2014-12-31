//
//  DBManager.h
//  FetionHD
//
//  Created by 李 俊杰 on 13-8-12.
//  Copyright (c) 2013年 chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Settings.h"

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"dataBase.sqlite"

@interface DBManager : NSObject

/****/
/**
 *	@brief	数据库对象单例方法
 *
 *	@return	返回FMDateBase数据库操作对象
 */
+ (FMDatabase *)createDataBase;


/**
 *	@brief	关闭数据库
 */
+ (void)closeDataBase;

/**
 *	@brief	清空数据库内容
 */
+ (void)deleteDataBase;

+(void) deleteRow:(NSString*)ObjId;

/**
 *	@brief	判断表是否存在
 *
 *	@param 	tableName 	表明
 *
 *	@return	创建是否成功
 */
+ (BOOL) isTableExist:(NSString *)tableName;


/**
 *	@brief	创建所有表
 *
 *	@return	
 */
+ (BOOL)createTable;
/**
 *	@brief	添加chatdata  如果主键重复就更新
 *
 *	@param 	chatData 	要保存的chatdata
 *
 *	@return	返回是否保存或者更新成功
 */
+ (BOOL) saveOrUpdataSetting:(Settings*)weatherData;
+ (Settings *) selectSettingBySettingId:(NSString*)SettingId;
+ (NSMutableArray *) selectSetting;
@end
