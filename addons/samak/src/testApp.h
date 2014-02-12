#pragma once

#include "ofMain.h"
#include "ofxBox2d.h"
#include "ofxOpenCv.h"
#define _USE_LIVE_VIDEO

class testApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
    
        ofxBox2d                        box2d;			  //	the box2d world
        vector <ofPtr<ofxBox2dCircle> >	circles;		  //	default box2d circles
    
        #ifdef _USE_LIVE_VIDEO
            ofVideoGrabber 		vidGrabber;
        #else
            ofVideoPlayer 		vidPlayer;
        #endif
        ofxCvColorImage			colorImg;
        ofxCvGrayscaleImage 	grayImage;
        ofxCvGrayscaleImage 	grayBg;
        ofxCvGrayscaleImage 	grayDiff;
        ofxCvContourFinder      contourFinder;
        int                     threshold;
        bool                    bLearnBakground;
        int                     w;
        int                     h;
    float mx;
    float my;
};
