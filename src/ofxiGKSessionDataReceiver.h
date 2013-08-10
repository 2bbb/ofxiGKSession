//
//  ofxiGKSessionDataReceiver.h
//  ofxiGameKitP2PExmaple
//
//  Created by ISHII Tsuubito on 2013/08/10.
//
//

#pragma once

#include "ofMain.h"

class ofxiGKSessionDataReceiver {
public:
    virtual void receiveData(const ofBuffer &buffer) = 0;
};