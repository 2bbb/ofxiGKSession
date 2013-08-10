//
//  ofxiGKSessionWrapper.h
//  ofxiGameKitP2PExmaple
//
//  Created by ISHII Tsuubito on 2013/08/10.
//
//

#pragma once

#import <GameKit/GameKit.h>
#import "ofxiGKSessionDataReceiver.h"
#import "ofxiGKSessionManager.h"
#import "ofxObjective-C++Utility.h"

@interface ofxiGKSessionWrapper : NSObject <
    GKSessionDelegate
> {
    GKSession *session;
    ofxiGKSessionDataReceiver *receiver;
    ofxiGKSessionManager *manager;
    NSMutableArray *connectedPeers;
    NSMutableArray *availablePeers;
    
    NSString *displayName;
    NSString *sessionID;
}

- (void)setManager:(ofxiGKSessionManager *)manager;
- (void)setDataReceiver:(ofxiGKSessionDataReceiver *)receiver;
- (void)setDisplayName:(NSString *)_displayName
          andSessionID:(NSString *)_sessionID;
- (void)startSessionForSessionMode:(GKSessionMode)mode;

- (GKSession *)session;

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context;

- (NSArray *)connectedPeers;
- (NSArray *)availablePeers;

@end