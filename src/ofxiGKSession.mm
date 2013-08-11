//
//  ofxiGKSession.mm
//
//  Created by ISHII 2bit on 2013/08/08.
//
//

#include "ofxiGKSession.h"
#import "ofxObjective-C++Utility.h"
#import "ofxiGKSessionWrapper.h"

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
#pragma mark ofxiGKSessionDefaultManager

class ofxiGKSessionDefaultManager : public ofxiGKSessionManager {
private:
    typedef ofxiGKSessionManager Super;
public:
    ofxiGKSessionDefaultManager() {}

    virtual virtual void receiveConnectionRequest(string peerID) override {
        Super::receiveConnectionRequest(peerID);
        session->acceptConnection(peerID);
    }

    virtual void peerAvailable(string peerID) override {
        Super::peerAvailable(peerID);
        session->connectToPeerID(peerID);
    }
};

// ==========================================================================================
#pragma mark -
#pragma mark ofxiGKSession

#pragma mark -
#pragma mark initialzie

ofxiGKSession::ofxiGKSession() {
    manager = NULL;
    receiver = NULL;
    sendDataMode = OFXI_GKSESSION_SEND_DATA_RELIABLE;
}

void ofxiGKSession::setup(string _sessionID, string _displayName) {
    wrapper = [[ofxiGKSessionWrapper alloc] init];
    [wrapper setDisplayName:(_displayName == "") ? nil : convert(_displayName)
               andSessionID:convert(_sessionID)];
}

void ofxiGKSession::setDataReceiver(ofxiGKSessionDataReceiver *_receiver) {
    receiver = _receiver;
}

void ofxiGKSession::setManager(ofxiGKSessionManager *_manager) {
    manager = _manager;
}

void ofxiGKSession::startServer(ofxiGKSessionMode mode) {
    [wrapper setManager:(manager ? manager : (manager = new ofxiGKSessionDefaultManager()))];
    manager->setGKSession(this);
    
    [wrapper setDataReceiver:(receiver ? receiver : (receiver = (new ofxiGKSessionDefaultDataReceiver())))];
    
    [wrapper startSessionForSessionMode:(GKSessionMode)mode];
}

void ofxiGKSession::setSendDataMode(ofxiGKSessionSendDataMode _sendDataMode) {
    sendDataMode = _sendDataMode;
}

void ofxiGKSession::setAvailable() {
    [[wrapper session] setAvailable:YES];
}

void ofxiGKSession::setUnavailable() {
    [[wrapper session] setAvailable:NO];
}

#pragma mark -
#pragma mark callback

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

#pragma mark -
#pragma mark sending

void ofxiGKSession::sendData(const string &str) {
    [[wrapper session] sendDataToAllPeers:[convert(str) dataUsingEncoding:NSUTF8StringEncoding
                                                     allowLossyConversion:NO]
                             withDataMode:(GKSendDataMode)sendDataMode
                                    error:NULL];
}

void ofxiGKSession::sendData(const ofBuffer &buffer) {
    [[wrapper session] sendDataToAllPeers:convert(buffer)
                             withDataMode:(GKSendDataMode)sendDataMode
                                    error:NULL];
}

void ofxiGKSession::sendData(const string &str, const vector<string> &peers) {
    NSArray * array = convertToNSArrayFromVector(peers, convertFromStringToNSStringBlocks);
    [[wrapper session] sendData:[convert(str) dataUsingEncoding:NSUTF8StringEncoding]
                        toPeers:array
                   withDataMode:(GKSendDataMode)sendDataMode
                          error:NULL];
}

void ofxiGKSession::sendData(const ofBuffer &buffer, const vector<string> &peers) {
    NSArray * array = convertToNSArrayFromVector(peers, convertFromStringToNSStringBlocks);
    [[wrapper session] sendData:convert(buffer)
                        toPeers:array
                   withDataMode:(GKSendDataMode)sendDataMode
                          error:NULL];
}

#pragma mark -
#pragma mark get information

const ofxiGKSessionMode ofxiGKSession::getSessionMode() const {
    return (ofxiGKSessionMode)[[wrapper session] sessionMode];
}

const string ofxiGKSession::getDisplayName() const {
    return convert([[wrapper session] displayName]);
}

const string ofxiGKSession::getDisplayName(string peer) const {
    return convert([[wrapper session] displayNameForPeer:convert(peer)]);
}

const string ofxiGKSession::getSessionID() const {
    return convert([[wrapper session] sessionID]);
}

const string ofxiGKSession::getConnectedPeer(string displayName) const {
    NSString *peerID = [wrapper connectedPeerIdForDisplayName:convert(displayName)];
    return peerID ? convert(peerID) : "";
}

vector<string> ofxiGKSession::getConnectedPeers() {
    return convertToVectorFromNSArray([wrapper connectedPeers], convertFromNSStringToStringBlocks);
}

vector<string> ofxiGKSession::getConnectedDisplayNames() {
    return convertToVectorFromNSArray([wrapper connectedDisplayNames], convertFromNSStringToStringBlocks);
}

vector<string> ofxiGKSession::getAvailablePeers() {
    return convertToVectorFromNSArray([wrapper availablePeers], convertFromNSStringToStringBlocks);
}

vector<string> ofxiGKSession::getAvailableDisplayNames() {
    return convertToVectorFromNSArray([wrapper availableDisplayNames], convertFromNSStringToStringBlocks);
}