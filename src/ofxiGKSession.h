//
//  ofxiGKSession.h
//
//  Created by ISHII 2bit on 2013/08/08.
//
//

#pragma once

#import <GameKit/GameKit.h>
#include "ofMain.h"

#import "ofxiGKSessionDataReceiver.h"
#import "ofxiGKSessionManager.h"

@class ofxiGKSessionWrapper;

typedef enum {
    OFXI_GKSESSION_MODE_SERVER = GKSessionModeServer,
    OFXI_GKSESSION_MODE_CLIENT = GKSessionModeClient,
    OFXI_GKSESSION_MODE_PEER   = GKSessionModePeer
} ofxiGKSessionMode;

typedef enum {
    OFXI_GKSESSION_SEND_DATA_RELIABLE = GKSendDataReliable,
    OFXI_GKSESSION_SEND_DATA_UNRELIABLE = GKSendDataUnreliable
} ofxiGKSessionSendDataMode;

class ofxiGKSession {
public:
#pragma mark initialzie
    ofxiGKSession();
    void setup(string sessionID = "ofxiGKSession", string displayName = "");
    void setDataReceiver(ofxiGKSessionDataReceiver *receiver);
    void setManager(ofxiGKSessionManager *manager);
    void startServer(ofxiGKSessionMode sessionMode = OFXI_GKSESSION_MODE_PEER);
    
    void setSendDataMode(ofxiGKSessionSendDataMode mode);
    
    void setAvailable();
    void setUnavailable();
    
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
    const string getDisplayName(string peer) const;
    const string getSessionID() const;
    
    const string getConnectedPeer(string displayName) const;
    
    vector<string> getConnectedPeers();
    vector<string> getConnectedDisplayNames();
    vector<string> getAvailablePeers();
    vector<string> getAvailableDisplayNames();
private:
    ofxiGKSessionWrapper *wrapper;
    ofxiGKSessionManager *manager;
    ofxiGKSessionDataReceiver *receiver;
    
    ofxiGKSessionSendDataMode sendDataMode;
};