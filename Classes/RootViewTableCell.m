//
//  MainViewTableCell.m
//  PeepsAt
//
//  Created by roger on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewTableCell.h"


@implementation RootViewTableCell
@synthesize pictureUrl, titleLabel, sourceLabel, expiresLabel, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)setDetails:(NSDictionary *)friend{
	self.titleLabel.text = [friend objectForKey:@"announcement_title"];
	self.expiresLabel.text = [friend objectForKey:@"expiration_date_text"];
	self.sourceLabel.text = [friend objectForKey:@"source"];
	self.pictureUrl = [friend objectForKey:@"small_image_url"];
	//[self setRemoteImage:[friend objectForKey:@"picture"]];
	if(self.pictureUrl != nil && [self.pictureUrl length] != 0){
		NSOperationQueue *queue = [NSOperationQueue new];
		NSInvocationOperation *operation = [[NSInvocationOperation alloc]
											initWithTarget:self
											selector:@selector(loadImage)
											object:nil];
		[queue addOperation:operation];
		[operation release];
	}else{
		//self.imageView.image = [UIImage imageNamed:@"silhouette.png"];
	}
}

- (void)loadImage {
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.pictureUrl]];
	UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
	[imageData release];
	[self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)image {
	[self.imageView setImage:image]; //UIImageView
	[self.imageView setNeedsLayout];
	[self setNeedsLayout];
}

- (void)setRemoteImage:(NSString *)profilePic{
	//if we are online and they have a profile image
	if(profilePic != nil && [profilePic length] != 0){
		self.imageView.image = [[UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: profilePic]]] retain];
	}else{
		//self.imageView.image = [UIImage imageNamed:@"silhouette.png"];
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
