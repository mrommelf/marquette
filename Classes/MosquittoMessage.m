//
//  MosquittoMessage.m
//  Marquette
//
//  Created by Mark Rommelfanger on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MosquittoMessage.h"

@implementation MosquittoMessage

@synthesize topic = _topic;
@synthesize payload = _payload;

- (id)initWithMosquittoMessage:(const struct mosquitto_message*)message
{
    if ( self = [super init] ) {
        _topic = [NSString stringWithUTF8String: message->topic];
        _payload = [[[NSString alloc] initWithBytes:message->payload
                                      length:message->payloadlen
                                      encoding:NSUTF8StringEncoding] autorelease];
    } else {
        return nil;
    }
    return self;
}

@end
