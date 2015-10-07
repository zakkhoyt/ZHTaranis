//
//  ZHDefines.h
//  Zakk Hoyt
//
//  Created by Zakk Hoyt
//


#ifndef ZH_DEFINES_H
#define ZH_DEFINES_H
//******************************************************************************
#   if defined(DEBUG)
#       define ZH_LOG(...) NSLog(@"INFO: %@", [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_INFO(...) NSLog(@"%s:%d ***** INFO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_TODO NSLog(@"%s:%d TODO: Implement", __FUNCTION__, __LINE__);
#       define ZH_LOG_TODO_TASK(...) NSLog(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_DEBUG(...) NSLog(@"%s:%d ***** DEBUG: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_WARNING(...) NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_ERROR(...) NSLog(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_CRITICAL(...) NSLog(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); NSAssert(NO, @"Critical Error");
#       define ZH_LOG_TRACE NSLog(@"%s:%d ***** TRACE", __FUNCTION__, __LINE__);
#       define ZH_LOG_TEST(...) NSLog(@"%s:%d\n********************************************************* TESTING: %@ *********************************************************", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#   else
// We only want warnings and errors to appear in the console for release builds
#       define ZH_LOG(...)
#       define ZH_LOG_INFO(...)
#       define ZH_LOG_TODO
#       define ZH_LOG_TODO_TASK(...)
#       define ZH_LOG_DEBUG(...)
#       define ZH_LOG_WARNING(...) NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_ERROR(...) NSLog(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_CRITICAL(...) NSLog(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_TRACE
#       define ZH_LOG_TEST(...)
#   endif
// End trace defines ***************************************************************
//******************************************************************************

#endif // ZH_DEFINES_H