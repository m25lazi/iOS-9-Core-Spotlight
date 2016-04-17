//
//  CreateViewController.m
//  Spotlight Search Example
//
//  Created by Mohammed Lazim on 17/04/16.
//  Copyright © 2016 iostreamh. All rights reserved.
//

#import "CreateViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *identifier;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *datatype;
@property (weak, nonatomic) IBOutlet UISegmentedControl *devicetype;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"CreatedSegue"]){
        NSLog(@"Title : %@", _identifier.text);
        NSLog(@"Description : %@", _desc.text);
        NSLog(@"Device Type : %ld", (long)_devicetype.selectedSegmentIndex );
        NSLog(@"Data Type : %ld", (long)_datatype.selectedSegmentIndex );
        
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[_identifier.text] = @{
                                   @"description" : _desc.text,
                                   @"datatype" : [NSNumber numberWithInteger:_datatype.selectedSegmentIndex],
                                   @"devicetype" : [NSNumber numberWithInteger:_devicetype.selectedSegmentIndex]
                                   };
        NSUserDefaults *nsud = [NSUserDefaults standardUserDefaults];
        [nsud setObject:data[_identifier.text] forKey:_identifier.text];
        [nsud synchronize];
        
        CSSearchableItemAttributeSet *attributeSet;
        attributeSet = [[CSSearchableItemAttributeSet alloc]
                        initWithItemContentType:(NSString *)kUTTypeImage];
        
        attributeSet.title = _identifier.text;
        attributeSet.contentDescription = _desc.text;
        
        attributeSet.keywords = @[@"bloqs",@"appliance", @"sensor", _identifier.text];
        
//        UIImage *image = [UIImage imageNamed:@"searchIcon.png"];
//        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
//        attributeSet.thumbnailData = imageData;
        
        CSSearchableItem *item = [[CSSearchableItem alloc]
                                  initWithUniqueIdentifier:nil
                                  domainIdentifier:@"thebloqs.device.something"
                                  attributeSet:attributeSet];
        
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
                                                       completionHandler: ^(NSError * __nullable error) {
                                                           if (!error)
                                                               NSLog(@"Search item indexed");
                                                       }];
    }
}


@end
