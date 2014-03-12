//
//  ResultCell.m
//  RussiaRoutes
//

#import "ResultCell.h"

@implementation ResultCell

@synthesize cityName;
@synthesize routeName;
@synthesize distance;
@synthesize diffDistance;
@synthesize time;
@synthesize diffTime;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[cityName release];
	[routeName release];
	[distance release];
	[diffDistance release];
    [time release];
    [diffTime release];
	[image release];
	
    [super dealloc];
}


@end
