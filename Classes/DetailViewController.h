//
//  DetailViewController.h
//  DealsNearby
//
//  Created by Roger on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
}
@property (nonatomic, retain) UIWebView *webView;
@end
