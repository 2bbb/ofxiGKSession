//
//  ofxiGKSessionManager.mm
//
//  Created by ISHII 2bit on 2013/08/10.
//
//

#import "ofxiGKSessionManager.h"
#import "ofxiGKSession.h"

void ofxiGKSessionManager::connectionWithPeerFailed(string peerID, string errorDescription) {
    ofLogError() << "connection with " << peerID << " failed: " << errorDescription;
}

void ofxiGKSessionManager::fail(string errorDescription) {
    ofLogError() << "fail" << errorDescription;
}

void ofxiGKSessionManager::receiveConnectionRequest(string peerID) {
    ofLogVerbose() << "receive connection request from " << peerID;
}

void ofxiGKSessionManager::peerAvailable(string peerID) {
    ofLogVerbose() << peerID << " is available.";
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

