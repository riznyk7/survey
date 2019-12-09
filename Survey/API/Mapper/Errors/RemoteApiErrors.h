//
//  RemoteApiErrors.h
//  Survey
//
//  Created by Piter Miller on 9/14/18.
//  Copyright © 2018 home. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef RemoteApiErrors_h
#define RemoteApiErrors_h

static NSErrorDomain RemoteApiErrorDomain = @"com.survey.RemoteServer";

typedef NS_ERROR_ENUM(RemoteApiErrorDomain, ServerError) {
    wrongResponseFormat,
    generic
};

static NSErrorUserInfoKey RemoteApiErrorUnderliyngErrorsKey = @"kRemoteApiErrorUnderliyngErrorsKey";

#endif /* RemoteApiErrors_h */
