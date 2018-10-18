

#ifndef LRKeychain_h
#define LRKeychain_h

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface LRKeychain : NSObject

+ (void)addKeychainData:(id)data forKey:(NSString *)key;///< 添加数据
+ (id)getKeychainDataForKey:(NSString *)key;///< 根据key获取相应的数据
+ (void)deleteKeychainDataForKey:(NSString *)key;///< 删除数据


//数据处理相关
+ (NSString*) charToNSString: (char*)value;
+ (const char*) NSIntToChar: (NSInteger) value;
+ (const char*) NSStringToChar: (NSString*) value;
+ (NSArray*) charToNSArray: (char*)value;

+ (const char*) serializeErrorWithData:(NSString*)description code: (int) code;
+ (const char*) serializeError:(NSError*)error;

+ (NSMutableString*) serializeErrorWithDataToNSString:(NSString*)description code: (int) code;
+ (NSMutableString*) serializeErrorToNSString:(NSError*)error;


+ (const char*) NSStringsArrayToChar:(NSArray*) array;
+ (NSString*) serializeNSStringsArray:(NSArray*) array;

@end


#endif
