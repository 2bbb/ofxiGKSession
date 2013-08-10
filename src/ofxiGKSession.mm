//
//  ofxiGKSession.mm
//
//  Created by ISHII 2bit on 2013/08/08.
//
//

#include "ofxiGKSession.h"
#import "ofxObjective-C++Utility.h"

@interface ofxiGKSessionWrapper : NSObject <
    GKSessionDelegate
> {
    GKSession *session;
    ofxiGKSessionManager *manager;
    ofxiGKSessionDataReceiver *receiver;
    NSMutableArray *peers;
}

- (void)setManager:(ofxiGKSessionManager *)manager;
- (void)setDataReceiver:(ofxiGKSessionDataReceiver *)receiver;
- (void)startSessionForSessionMode:(GKSessionMode)mode
                         sessionID:(NSString *)sessionID
                       displayName:(NSString *)displayName;
- (void)unavailablize;

- (GKSession *)session;

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context;

- (NSArray *)connectedPeers;

@end

@implementation ofxiGKSessionWrapper

- (instancetype)init {
    self = [super init];
    if(self) {
        peers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setManager:(ofxiGKSessionManager *)_manager {
    manager = _manager;
}

- (void)setDataReceiver:(ofxiGKSessionDataReceiver *)_receiver {
    receiver = _receiver;
}

- (void)startSessionForSessionMode:(GKSessionMode)mode
                         sessionID:(NSString *)sessionID
                       displayName:(NSString *)displayName
{
    session = [[GKSession alloc] initWithSessionID:sessionID
                                       displayName:displayName
                                       sessionMode:mode];
    [session setDelegate:self];
    [session setDataReceiveHandler:self withContext:NULL];
    [session setAvailable:YES];
}

- (void)availablize {
    [session setAvailable:YES];
}

- (void)unavailablize {
    [session setAvailable:NO];
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
    return peers;
}

- (void)session:(GKSession *)_session willAcceptConnectionRequestFromPeer:(NSString *)peerID
{
    BOOL hasConnected = NO;
    for(NSString *peer in peers) {
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

- (void)session:(GKSession *)_session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    manager->connectionWithPeerFailed(convert(peerID), convert([error description]));
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    manager->fail(convert([error description]));
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    ofLogVerbose() << "did receive connection request from peer: " << convert(peerID);
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
            manager->peerAvailable(_peerID);
            break;
        case GKPeerStateConnecting:
            manager->peerConnecting(_peerID);
            break;
        case GKPeerStateConnected:
            [peers addObject:peerID];
            [self session:session willAcceptConnectionRequestFromPeer:peerID];
            break;
        case GKPeerStateDisconnected:
            [peers removeObject:peerID];
            manager->peerDisconnected(_peerID);
            break;
        case GKPeerStateUnavailable:
            manager->peerUnavailable(_peerID);
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [peers release];
    [super dealloc];
}

@end

// ==========================================================================================
#pragma mark -
#pragma mark ofxiGKSessionManager

ofxiGKSessionManager::ofxiGKSessionManager(ofxiGKSession *p2p) {
    gameKitP2P = p2p;
}

void ofxiGKSessionManager::connectionWithPeerFailed(string peerID, string errorDescription) {
    ofLogError() << "connection with " << peerID << " failed: " << errorDescription;
}

void ofxiGKSessionManager::fail(string errorDescription) {
    ofLogError() << "fail" << errorDescription;
}

void ofxiGKSessionManager::receiveConnectionRequest(string peerID) {
    ofLogVerbose() << "receive connection request from " << peerID;
    gameKitP2P->acceptConnection(peerID);
}

void ofxiGKSessionManager::peerAvailable(string peerID) {
    ofLogVerbose() << peerID << " is available.";
    if(gameKitP2P->getSessionMode() != OFXI_GKSESSION_MODE_SERVER) {
        gameKitP2P->connectToPeerID(peerID);
    }
}

void ofxiGKSessionManager::peerConnecting(string peerID) {
    ofLogVerbose() << "connecting to " << peerID;
}

void ofxiGKSessionManager::peerConnected(string peerID) {
    ofLogVerbose() << "connected to " << peerID;
}

void ofxiGKSessionManager::peerDisconnected(string peerID) {
    ofLogVerbose() << "disconnected from " << peerID;
}

void ofxiGKSessionManager::peerUnavailable(string peerID) {
    ofLogVerbose() << peerID << " is unavailable.";
}

// ==========================================================================================
#pragma mark -
#pragma mark ofxiGKSessionDefaultDataReceiver

class ofxiGKSessionDefaultDataReceiver : public ofxiGKSessionDataReceiver {
public:
    void receiveData(const ofBuffer &buffer) {
        ofLogNotice() << "receive: " << buffer.getText();
    }
};

// ==========================================================================================
#pragma mark -
#pragma mark ofxiGKSession

void ofxiGKSession::setup(string _displayName, string _sessionID){
    displayName = _displayName;
    sessionID = _sessionID;
    wrapper = [[ofxiGKSessionWrapper alloc] init];
}

void ofxiGKSession::setDataReceiver(ofxiGKSessionDataReceiver *_receiver) {
    receiver = _receiver;
}

void ofxiGKSession::setManager(ofxiGKSessionManager *_manager) {
    manager = _manager;
}

void ofxiGKSession::startServer(ofxiGKSessionMode mode) {
    if(manager == NULL) {
        manager = (new ofxiGKSessionManager(this));
    }
    if(receiver == NULL) {
        receiver = (new ofxiGKSessionDefaultDataReceiver());
    }
    [wrapper setManager:manager];
    [wrapper setDataReceiver:receiver];
    [wrapper startSessionForSessionMode:(GKSessionMode)mode
                              sessionID:convert(sessionID)
                            displayName:convert(displayName)];
}

void ofxiGKSession::connectToPeerID(string &peerID) {
    [[wrapper session] connectToPeer:convert(peerID)
                         withTimeout:5.0f];
}

void ofxiGKSession::disconnectPeerFromAllPeers(string &peerID) {
    [[wrapper session] disconnectPeerFromAllPeers:convert(peerID)];
}

void ofxiGKSession::disconnectFromAllPeers() {
    [[wrapper session] disconnectFromAllPeers];
}

void ofxiGKSession::acceptConnection(string peerID) {
    NSError *error;
    BOOL res = [[wrapper session] acceptConnectionFromPeer:convert(peerID)
                                                     error:&error];
    if(!res) {
        string errorMessage = convert([error description]);
        ofLogError() << errorMessage;
    }
}

void ofxiGKSession::denyConnection(string peerID) {
    [[wrapper session] denyConnectionFromPeer:convert(peerID)];
}

void ofxiGKSession::setEnable() {
    [wrapper availablize];
}

void ofxiGKSession::setDisable() {
    [wrapper unavailablize];
}


void ofxiGKSession::sendData(const string str) {
    [[wrapper session] sendDataToAllPeers:[convert(str) dataUsingEncoding:NSUTF8StringEncoding
                                                     allowLossyConversion:NO]
                             withDataMode:GKSendDataReliable
                                    error:nil];
}

void ofxiGKSession::sendData(const ofBuffer &buffer) {
    [[wrapper session] sendDataToAllPeers:convert(buffer)
                             withDataMode:GKSendDataReliable
                                    error:NULL];
}

const ofxiGKSessionMode ofxiGKSession::getSessionMode() const {
    return sessionMode;
}

vector<string> ofxiGKSession::getConnectedPeers() {
    return convertToVectorFromNSArray([wrapper connectedPeers], convertFromNSStringToStringBlocks);
}