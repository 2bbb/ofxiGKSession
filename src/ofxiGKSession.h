//
//  ofxiGKSession.h
//
//  Created by ISHII 2bit on 2013/08/08.
//
//

#ifndef __ofxiGKSession__
#define __ofxiGKSession__

#include "ofMain.h"

#import <GameKit/GameKit.h>

@class ofxiGKSessionWrapper;

class ofxiGKSession;

class ofxiGKSessionManager {
public:
    ofxiGKSessionManager(ofxiGKSession *p2p);
    
    virtual void connectionWithPeerFailed(string peerID, string errorDescription);
    virtual void fail(string errorDescription);
    virtual void receiveConnectionRequest(string peerID);
    
    virtual void peerAvailable(string peerID);
    virtual void peerConnecting(string peerID);
    virtual void peerConnected(string peerID);
    virtual void peerDisconnected(string peerID);
    virtual void peerUnavailable(string peerID);
private:
    ofxiGKSession *gameKitP2P;
};

class ofxiGKSessionDataReceiver {
public:
    virtual void receiveData(const ofBuffer &buffer) = 0;
};

typedef enum {
    OFXI_GKSESSION_MODE_CLIENT = GKSessionModeClient,
    OFXI_GKSESSION_MODE_SERVER = GKSessionModeServer,
    OFXI_GKSESSION_MODE_PEER   = GKSessionModePeer
} ofxiGKSessionMode;

class ofxiGKSession {
public:
    ofxiGKSession() {
        manager = NULL;
        receiver = NULL;
    }
    void setup(string displayName, string sessionID = "ofxiGKSession");
    void setDataReceiver(ofxiGKSessionDataReceiver *receiver);
    void setManager(ofxiGKSessionManager *manager);
    void startServer(ofxiGKSessionMode sessionMode);
    void connectToPeerID(string &peerID);
    void disconnectPeerFromAllPeers(string &peerID);
    void disconnectFromAllPeers();
    void acceptConnection(string peerID);
    void denyConnection(string peerID);
    
    void setEnable();
    void setDisable();
    
    void sendData(const string str);
    void sendData(const ofBuffer &buffer);
    
    const ofxiGKSessionMode getSessionMode() const;
    
    vector<string> getConnectedPeers();
private:
    string displayName;
    string sessionID;
    ofxiGKSessionWrapper *wrapper;
    ofxiGKSessionManager *manager;
    ofxiGKSessionDataReceiver *receiver;
    ofxiGKSessionMode sessionMode;
};


#endif /* defined(__ofxiGKSession__) */
