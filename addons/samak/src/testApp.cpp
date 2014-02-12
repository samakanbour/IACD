#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    w = ofGetWidth();
    h = ofGetHeight();
    ofSetVerticalSync(true);
	ofBackgroundHex(0x333333);
	ofSetLogLevel(OF_LOG_NOTICE);
	ofDisableAntiAliasing();
    
	box2d.init();
	box2d.setGravity(0, 0);
	box2d.setFPS(30.0);
    
	for (int i=0; i<50; i++) {
		float r = ofRandom(5, 10);
		ofPtr<ofxBox2dCircle> circle = ofPtr<ofxBox2dCircle>(new ofxBox2dCircle);
		circle.get()->setPhysics(3.0, 0.53, 0.9);
		circle.get()->setup(box2d.getWorld(), ofGetWidth()/2, ofGetHeight()/2, r);
		circles.push_back(circle);
	}
    
    #ifdef _USE_LIVE_VIDEO
        vidGrabber.setVerbose(true);
        vidGrabber.initGrabber(w,h);
    #else
        vidPlayer.loadMovie("fingers.mov");
        vidPlayer.play();
    #endif

    colorImg.allocate(w,h);
    grayImage.allocate(w,h);
    grayBg.allocate(w,h);
	grayDiff.allocate(w,h);
    
    bLearnBakground = true;
    threshold = 80;
}

//--------------------------------------------------------------
void testApp::update(){
    
    bool bNewFrame = false;
    #ifdef _USE_LIVE_VIDEO
        vidGrabber.update();
        bNewFrame = vidGrabber.isFrameNew();
    #else
        vidPlayer.update();
        bNewFrame = vidPlayer.isFrameNew();
    #endif
    
	if (bNewFrame){
        #ifdef _USE_LIVE_VIDEO
            colorImg.setFromPixels(vidGrabber.getPixels(), w, h);
        #else
            colorImg.setFromPixels(vidPlayer.getPixels(), w, h);
        #endif
        grayImage = colorImg;
		if (bLearnBakground == true){
			grayBg = grayImage;
			bLearnBakground = false;
		}
		grayDiff.absDiff(grayBg, grayImage);
		grayDiff.threshold(threshold);
		contourFinder.findContours(grayDiff, 40, (w*h)/3, 10, false);
        
        my=1000;
        if (contourFinder.nBlobs > 0) {
            for (int i = 0; i < contourFinder.blobs[0].pts.size(); i++){
                if (contourFinder.blobs[0].pts[i].y < my){
                    my = contourFinder.blobs[0].pts[i].y;
                    mx = contourFinder.blobs[0].pts[i].x;
                }
            }
                
            //for (int i = 0; i < contourFinder.nBlobs; i++){
            //mx = contourFinder.blobs[0].pts[0].x;
            //my = contourFinder.blobs[0].boundingRect.y;
            cout << mx << ", " << my << endl;
        }
        box2d.update();
        ofVec2f mouse(mx, my);
        float minDis = ofGetMousePressed() ? 100 : 50;
        for(int i=0; i<circles.size(); i++) {
            float dis = mouse.distance(circles[i].get()->getPosition());
            if(dis < minDis) circles[i].get()->addRepulsionForce(mouse, 9);
            else circles[i].get()->addAttractionPoint(mouse, 4.0);
        }
    }
}

//--------------------------------------------------------------
void testApp::draw() { 
	ofSetHexColor(0xffffff);
    contourFinder.draw(0,0);
    for(int i=0; i<circles.size(); i++) {
		ofFill();
		ofSetHexColor(0xf6c738);
		circles[i].get()->draw();
	}
	box2d.drawGround();    
}

//--------------------------------------------------------------
void testApp::keyPressed(int key) {
	if(key == 'c') {
		float r = ofRandom(5, 10);
		ofPtr<ofxBox2dCircle> circle = ofPtr<ofxBox2dCircle>(new ofxBox2dCircle);
		circle.get()->setPhysics(3.0, 0.53, 0.9);
		circle.get()->setup(box2d.getWorld(), mouseX, mouseY, r);
		circles.push_back(circle);
	}
	if(key == 't') ofToggleFullscreen();
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 

}
