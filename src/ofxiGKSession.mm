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
    ofxiGKSessionDefaultManager(ofxiGKSession *p2p) : ofxiGKSessionManager(p2p) {}

    virtual virtual void receiveConnectionRequest(string peerID) override {
        Super::receiveConnectionRequest(peerID);
        gameKitP2P->acceptConnection(peerID);
    }

    virtual void peerAvailable(string peerID) override {
        Super::peerAvailable(peerID);
        gameKitP2P->connectToPeerID(peerID);
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

void ofxiGKSession::setup(string _displayName, string _sessionID){
    wrapper = [[ofxiGKSessionWrapper alloc] init];
    [wrapper setDisplayName:convert(_displayName)
               andSessionID:convert(_sessionID)];
}

void ofxiGKSession::setDataReceiver(ofxiGKSessionDataReceiver *_receiver) {
    receiver = _receiver;
}

void ofxiGKSession::setManager(ofxiGKSessionManager *_manager) {
    manager = _manager;
}

void ofxiGKSession::startServer(ofxiGKSessionMode mode) {
    [wrapper setManager:(manager ? manager : (manager = new ofxiGKSessionDefaultManager(this)))];
    [wrapper setDataReceiver:(receiver ? receiver : (receiver = (new ofxiGKSessionDefaultDataReceiver())))];
    [wrapper startSessionForSessionMode:(GKSessionMode)mode];
}

void ofxiGKSession::setSendDataMode(ofxiGKSessionSendDataMode _sendDataMode) {
    sendDataMode = _sendDataMode;
}

void ofxiGKSession::setEnable() {
    [[wrapper session] setAvailable:YES];
}

void ofxiGKSession::setDisable() {
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
#pragma mark get info

const ofxiGKSessionMode ofxiGKSession::getSessionMode() const {
    return (ofxiGKSessionMode)[[wrapper session] sessionMode];
}

const string ofxiGKSession::getDisplayName() const {
    return convert([[wrapper session] displayName]);
}

const string ofxiGKSession::getSessionID() const {
    return convert([[wrapper session] sessionID]);
}

vector<string> ofxiGKSession::getConnectedPeers() {
    return convertToVectorFromNSArray([wrapper connectedPeers], convertFromNSStringToStringBlocks);
}

vector<string> ofxiGKSession::getAvailablePeers() {
    return convertToVectorFromNSArray([wrapper availablePeers], convertFromNSStringToStringBlocks);
}