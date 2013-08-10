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
        connectedPeers = [[NSMutableArray alloc] init];
        availablePeers = [[NSMutableArray alloc] init];
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
    return connectedPeers;
}

- (NSArray *)availablePeers {
    return availablePeers;
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
        case GKPeerStateAvailable:
            [availablePeers addObject:peerID];
            manager->peerAvailable(_peerID);
            break;
        case GKPeerStateConnecting:
            manager->peerConnecting(_peerID);
            break;
        case GKPeerStateConnected:
            [connectedPeers addObject:peerID];
            [self session:session willAcceptConnectionRequestFromPeer:peerID];
            break;
        case GKPeerStateDisconnected:
            [connectedPeers removeObject:peerID];
            manager->peerDisconnected(_peerID);
            break;
        case GKPeerStateUnavailable:
            [availablePeers removeObject:peerID];
            manager->peerUnavailable(_peerID);
            break;
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