//
//  ofxiGKSession.h
//
//  Created by ISHII 2bit on 2013/08/08.
//
//

#pragma once

#import <GameKit/GameKit.h>
#include "ofMain.h"

#import "ofxiGKSessionManager.h"
#import "ofxiGKSessionDataReceiver.h"

@class ofxiGKSessionWrapper;

typedef enum {
    OFXI_GKSESSION_MODE_CLIENT = GKSessionModeClient,
    OFXI_GKSESSION_MODE_SERVER = GKSessionModeServer,
    OFXI_GKSESSION_MODE_PEER   = GKSessionModePeer
} ofxiGKSessionMode;

class ofxiGKSession {
public:
#pragma mark initialzie
    ofxiGKSession() {
        manager = NULL;
        receiver = NULL;
    }
    void setup(string displayName, string sessionID = "ofxiGKSession");
    void setDataReceiver(ofxiGKSessionDataReceiver *receiver);
    void setManager(ofxiGKSessionManager *manager);
    void startServer(ofxiGKSessionMode sessionMode);
    
    void setEnable();
    void setDisable();
    
#pragma mark callback
    void connectToPeerID(string &peerID);
    void disconnectPeerFromAllPeers(string &peerID);
    void disconnectFromAllPeers();
    void acceptConnection(string peerID);
    void denyConnection(string peerID);
    
#pragma mark sending
    void sendData(const string &str);
    void sendData(const ofBuffer &buffer);
    
    void sendData(const string &str, const vector<string> &peers);
    void sendData(const ofBuffer &buffer, const vector<string> &peers);
#pragma mark get info
    const ofxiGKSessionMode getSessionMode() const;
    const string getDisplayName() const;
    const string getSessionID() const;
    
    vector<string> getConnectedPeers();
    vector<string> getAvailablePeers();
private:
    ofxiGKSessionWrapper *wrapper;
    ofxiGKSessionManager *manager;
    ofxiGKSessionDataReceiver *receiver;
    ofxiGKSessionMode sessionMode;
};