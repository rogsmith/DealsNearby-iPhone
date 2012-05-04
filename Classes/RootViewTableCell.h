//
//  MainViewTableCell.h
//  PeepsAt
//
//  Created by roger on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewTableCell : UITableViewCell {
	NSString *pictureUrl;
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *expiresLabel;
	IBOutlet UILabel *sourceLabel;
}

@property (nonatomic, retain) NSString *pictureUrl;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *expiresLabel;
@property (nonatomic, retain) UILabel *sourceLabel;

- (void)setDetails:(NSDictionary *)friend;@end
