//
//  RegionCodeCell.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>


@interface RegionCodeCell : UITableViewCell {
    UILabel *regionCode;
    UILabel *regionName;
}

@property (nonatomic, retain) IBOutlet UILabel *regionCode;
@property (nonatomic, retain) IBOutlet UILabel *regionName;

@end
