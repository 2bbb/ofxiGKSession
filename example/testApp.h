#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxiGKSession.h"

class testApp : public ofxiPhoneApp, public ofxiGKSessionDataReceiver {
public:
    void setup();
    void update();
    void draw();
    void exit();

    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    void receiveData(const ofBuffer &buffer) {
        const string bufferString = buffer.getText();
        ofLogVerbose() << bufferString;
        vector<string> points = ofSplitString(bufferString, ",");
        int x = ofToInt(points[0]), y = ofToInt(points[1]);
        ofSetColor(255, 255, 255);
        ofCircle(x, y, 8);
    }
private:
    ofxiGKSession gkSession;
};


