//
//  ofxiGKSessionManager.h
//
//  Created by ISHII 2bit on 2013/08/10.
//
//

#pragma once

#include "ofMain.h"

class ofxiGKSession;

class ofxiGKSessionManager {
public:
#pragma mark override [if need]
    virtual void connectionWithPeerFailed(string peerID, string errorDescription);
    virtual void fail(string errorDescription);
    virtual void receiveConnectionRequest(string peerID);
    
    virtual void peerAvailable(string peerID);
    virtual void peerConnecting(string peerID);
    virtual void peerConnected(string peerID);
    virtual void peerDisconnected(string peerID);
    virtual void peerUnavailable(string peerID);
};