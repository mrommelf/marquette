//
//  MosquittoMessage.h
//  Marquette
//
//  Created by Mark Rommelfanger on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mosquitto.h"

@interface MosquittoMessage : NSObject

@property (readwrite,retain) NSString *topic;
@property (readwrite,retain) NSString *payload;
@property (readwrite) NSInteger qos;
@property (readwrite) BOOL retain;

- (id)initWithMosquittoMessage:(const struct mosquitto_message*)message;

@end
