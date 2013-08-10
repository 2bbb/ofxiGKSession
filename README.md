#ofxiGKSession (iOS)

Wrapper of GKSession for openframeworks on iOS

## How to use

1. Add GameKit.framework to your project
2. Add ofxiGKSession & ofxObjective-C++Utility to your project and include ofxiGKSession.h
3. Open Project Setting -> TARGETS -> Build Phases -> Compile Sources, and add flag "-x objective-c++" for all file of .cpp

## Dependencies

ofxObjective-C++Utility [__https://github.com/2bbb/ofxObjective-C--Utility__]

## API

### ofxiGKSession

* void setup(string sessionID = "ofxiGKSession", string displayName = "")

_sessionID_ is using for detect service group. and if _displayName_ is empty string "", then _displayName_ be device name.

* void setDataReceiver(ofxiGKSessionDataReceiver *receiver);

_receiver_ is a instance of the subclass inherited _ofxiGKSessionDataReceiver_.
_ofxiGKSessionDataReceiver_ is implementd the method that process received data.

* void setManager(ofxiGKSessionManager *manager)

_manager_ is a instance of the subclass inherited _ofxiGKSessionManager_.
_ofxiGKSessionManager_ manages connection while devices.

* void startServer(ofxiGKSessionMode sessionMode = OFXI_GKSESSION_MODE_PEER)

start the bluetooth service.
sessionMode is select from _OFXI_GKSESSION_MODE_SERVER_, _OFXI_GKSESSION_MODE_CLIENT_ or _OFXI_GKSESSION_MODE_PEER_.

* void setSendDataMode(ofxiGKSessionSendDataMode mode)

__TODO__

* void setAvailable();
* void setUnavailable();

__TODO__

* void connectToPeerID(string &peerID)
* void disconnectPeerFromAllPeers(string &peerID)
* void disconnectFromAllPeers()
* void acceptConnection(string peerID)
* void denyConnection(string peerID)
    
__TODO__

* void sendData(const string &str)
* void sendData(const ofBuffer &buffer)
* void sendData(const string &str, const vector<string> &peers)
* void sendData(const ofBuffer &buffer, const vector<string> &peers)

send datas.

* const ofxiGKSessionMode getSessionMode() const;
* const string getDisplayName() const;
* const string getDisplayName(string peer) const;
* const string getSessionID() const;
* vector<string> getConnectedPeers();
* vector<string> getAvailablePeers();

__TODO__

### ofxiGKSessionDataReceiver (Interface about receive data)

* void receiveData(const ofBuffer &buffer)

this method is call when receive data.

### ofxiGKSession (Interface about managing the connection)

* virtual void connectionWithPeerFailed(string peerID, string errorDescription)
* virtual void fail(string errorDescription)
* virtual void receiveConnectionRequest(string peerID)

__TODO__

* virtual void peerAvailable(string peerID)
* virtual void peerConnecting(string peerID)
* virtual void peerConnected(string peerID)
* virtual void peerDisconnected(string peerID)
* virtual void peerUnavailable(string peerID)
* 
__TODO__

## Update history

### 2013/08/10 ver 0.01 beta release

## License

MIT License.

## Author

* ISHII 2bit [bufferRenaiss co., ltd.]
* ishii[at]buffer-renaiss.com