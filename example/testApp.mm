#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
    ofBackground(255, 255, 255);
    ofSetBackgroundAuto(false);
    
    ofSetLogLevel(OF_LOG_VERBOSE);
    
    gkSession.setup("ofxiGKSessionExample");
    gkSession.setDataReceiver(this);
    gkSession.startServer(OFXI_GKSESSION_MODE_PEER);
}

//--------------------------------------------------------------
void testApp::update(){
    
}

//--------------------------------------------------------------
void testApp::draw(){
    
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    string str = ofToString(touch.x) + "," + ofToString(touch.y);
    gkSession.sendData(str);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    string str = ofToString(touch.x) + "," + ofToString(touch.y);
    gkSession.sendData(str);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    string str = ofToString(touch.x) + "," + ofToString(touch.y);
    gkSession.sendData(str);
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

