//
//  RegionCodeCell.m
//  RussiaRoutes
//

#import "RegionCodeCell.h"

@implementation RegionCodeCell

@synthesize regionCode;
@synthesize regionName;

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
	[regionCode release];
    [regionName release];
	
    [super dealloc];
}

@end
