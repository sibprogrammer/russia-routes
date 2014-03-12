//
//  ResultCell.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>


@interface ResultCell : UITableViewCell {
	UILabel *cityName;
	UILabel *routeName;
	UILabel *distance;
	UILabel *diffDistance;
    UILabel *time;
    UILabel *diffTime;
	UIImageView *image;
}

@property (nonatomic, retain) IBOutlet UILabel *cityName;
@property (nonatomic, retain) IBOutlet UILabel *routeName;
@property (nonatomic, retain) IBOutlet UILabel *distance;
@property (nonatomic, retain) IBOutlet UILabel *diffDistance;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UILabel *diffTime;
@property (nonatomic, retain) IBOutlet UIImageView *image;

@end
