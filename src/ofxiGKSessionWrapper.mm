//
//  ofxiGKSessionWrapper.mm
//  ofxiGameKitP2PExmaple
//
//  Created by ISHII Tsuubito on 2013/08/10.
//
//

#include "ofxiGKSessionWrapper.h"

@interface ofxiGKSessionWrapper ()

- (void)session:(GKSession *)_session willAcceptConnectionRequestFromPeer:(NSString *)peerID;

@end

@implementation ofxiGKSessionWrapper

- (instancetype)init {
    self = [super init];
    if(self) {
        connectedPeers = [[NSMutableDictionary alloc] init];
        availablePeers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setDisplayName:(NSString *)_displayName
          andSessionID:(NSString *)_sessionID
{
    displayName = [_displayName retain];
    sessionID = [_sessionID retain];
}

- (void)setManager:(ofxiGKSessionManager *)_manager {
    manager = _manager;
}

- (void)setDataReceiver:(ofxiGKSessionDataReceiver *)_receiver {
    receiver = _receiver;
}

- (void)startSessionForSessionMode:(GKSessionMode)mode {
    session = [[GKSession alloc] initWithSessionID:sessionID
                                       displayName:displayName
                                       sessionMode:mode];
    [session setDelegate:self];
    [session setDataReceiveHandler:self withContext:NULL];
    [session setAvailable:YES];
}

- (GKSession *)session {
    return session;
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context
{
    receiver->receiveData(convert(data));
}

- (NSArray *)connectedPeers {
    return [connectedPeers allValues];
}

- (NSArray *)connectedDisplayNames {
    return [connectedPeers allKeys];
}

- (NSString *)connectedPeerIdForDisplayName:(NSString *)_displayName {
    return [connectedPeers objectForKey:_displayName];
}

- (NSArray *)availablePeers {
    return [availablePeers allValues];
}

- (NSArray *)availableDisplayNames {
    return [availablePeers allKeys];
}

- (NSString *)availablePeerIdForDisplayName:(NSString *)_displayName {
    return [availablePeers objectForKey:_displayName];
}

- (void)session:(GKSession *)_session willAcceptConnectionRequestFromPeer:(NSString *)peerID {
    BOOL hasConnected = NO;
    for(NSString *peer in connectedPeers) {
        if ([peer isEqualToString:peerID]) {
            hasConnected = YES;
            break;
        }
    }
    if(!hasConnected) {
        manager->peerConnected(convert(peerID));
    }
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    manager->connectionWithPeerFailed(convert(peerID), convert([error description]));
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    manager->fail(convert([error description]));
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    manager->receiveConnectionRequest(convert(peerID));
}

- (void)session:(GKSession *)_session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state
{
    if([peerID isEqualToString:[_session peerID]]) return;
    string _peerID = convert(peerID);
    switch (state) {
        case GKPeerStateAvailable: {
            NSString *peerName = [_session displayNameForPeer:peerID];
            [availablePeers setObject:peerID
                               forKey:peerName];
            manager->peerAvailable(_peerID);
            break;
        }
        case GKPeerStateConnecting:
            manager->peerConnecting(_peerID);
            break;
        case GKPeerStateConnected: {
            NSString *peerName = [_session displayNameForPeer:peerID];
            [connectedPeers setObject:peerID
                               forKey:peerName];
            [self session:session willAcceptConnectionRequestFromPeer:peerID];
            break;
        }
        case GKPeerStateDisconnected: {
            NSString *peerName = [_session displayNameForPeer:peerID];
            [connectedPeers removeObjectForKey:peerName];
            manager->peerDisconnected(_peerID);
            break;
        }
        case GKPeerStateUnavailable: {
            NSString *peerName = [_session displayNameForPeer:peerID];
            [availablePeers removeObjectForKey:peerName];
            manager->peerUnavailable(_peerID);
            break;
        }
        default:
            break;
    }
}

- (void)dealloc {
    [connectedPeers release];
    [availablePeers release];
    [super dealloc];
}

@end