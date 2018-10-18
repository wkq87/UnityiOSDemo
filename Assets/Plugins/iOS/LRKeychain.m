

#import "LRKeychain.h"

NSString* const STR_SPLITTER = @"|";
NSString* const STR_EOF = @"endofline";
NSString* const STR_ARRAY_SPLITTER = @"%%%";

@implementation LRKeychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(id)kSecClass,// 标识符(kSecAttrGeneric通常值位密码)
            service, (__bridge id)kSecAttrService,// 服务(kSecAttrService)
            service, (__bridge id)kSecAttrAccount,// 账户(kSecAttrAccount)
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,// kSecAttrAccessiblein变量用来指定这个应用何时需要访问这个数据
            nil];
}

+ (void)addKeychainData:(id)data forKey:(NSString *)key {
    // 获取查询字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // 在删除之前先删除旧数据
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    // 添加新的数据到字典
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    // 将数据字典添加到钥匙串
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)getKeychainDataForKey:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery: key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
//        @try {
//            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
//        } @catch (NSException *e) {
//            NSLog(@"Unarchive of %@ failed: %@", key, e);
//        } @finally {
//            
//        }
    }
    
    return ret;
}

+ (void)deleteKeychainDataForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery: key];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}




+(NSString*) charToNSString:(char*)value {
    if (value != NULL) {
        return [NSString stringWithUTF8String: value];
    } else {
        return [NSString stringWithUTF8String: ""];
    }
}

+(const char*)NSIntToChar:(NSInteger)value {
    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)value];
    return [tmp UTF8String];
}

+ (const char*) NSStringToChar:(NSString*)value {
    return [value UTF8String];
}

+ (NSArray*)charToNSArray:(char*)value {
    NSString* strValue = [LRKeychain charToNSString:value];
    
    NSArray* array;
    if([strValue length] == 0) {
        array = [[NSArray alloc] init];
    } else {
        array = [strValue componentsSeparatedByString:STR_ARRAY_SPLITTER];
    }
    
    return array;
}

+ (const char*) NSStringsArrayToChar:(NSArray*) array {
    return [LRKeychain NSStringToChar:[LRKeychain serializeNSStringsArray:array]];
}

+ (NSString*) serializeNSStringsArray:(NSArray*) array {
    
    NSMutableString* data = [[NSMutableString alloc] init];
    
    
    for(NSString* str in array) {
        [data appendString:str];
        [data appendString: STR_ARRAY_SPLITTER];
    }
    
    [data appendString: STR_EOF];
    
    NSString* str = [data copy];
#if UNITY_VERSION < 500
    [str autorelease];
#endif
    
    return str;
}


+ (NSMutableString*)serializeErrorToNSString:(NSError*)error {
    NSString* description = @"";
    if(error.description != nil) {
        description = error.description;
    }
    
    return  [self serializeErrorWithDataToNSString:description code: (int) error.code];
}

+ (NSMutableString*)serializeErrorWithDataToNSString:(NSString*)description code:(int)code {
    NSMutableString* data = [[NSMutableString alloc] init];
    
    [data appendFormat:@"%i", code];
    [data appendString: STR_SPLITTER];
    [data appendString: description];
    
    return  data;
}



+ (const char*) serializeErrorWithData:(NSString*)description code: (int) code {
    NSString* str = [LRKeychain serializeErrorWithDataToNSString:description code:code];
    return [LRKeychain NSStringToChar:str];
}

+ (const char*) serializeError:(NSError*)error  {
    NSString* str = [LRKeychain serializeErrorToNSString:error];
    return [LRKeychain NSStringToChar:str];
}

@end


void SaveMyData(char* key,char* value){
    NSString* savekey = [LRKeychain charToNSString:key];
    NSString* savevalue = [LRKeychain charToNSString:value];
    [LRKeychain addKeychainData:savevalue forKey:savekey];
}

//如果没有存这个key值，则返回“”
const char* GetMyData(char* key){
    NSString* savekey = [LRKeychain charToNSString:key];
    NSString* savevalue = (NSString*)[LRKeychain getKeychainDataForKey:savekey];
    if (savevalue == nil) {
        return strdup("");
    }else{
        const char* ret = [LRKeychain NSStringToChar:savevalue];
        if (ret == nil) {
            return strdup("");
        }
        return strdup(ret);
    }
}
