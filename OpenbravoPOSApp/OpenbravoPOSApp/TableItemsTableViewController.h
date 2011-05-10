//
//  TableItemsViewController.h
//  OpenbravoPOSApp
//
//  Created by Axel Ruder on 02.04.11.
//  Copyright 2011 msg systems ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Table.h"
#import "Ticket.h"
#import "ItemSelectionTableViewController.h"


@interface TableItemsTableViewController : UITableViewController {
    
    Table* table;
    NSString *placeId;
    Ticket* ticket;
    NSMutableArray *addedItems;

    
    float sum;
    
    UITableViewCell *tableViewCell;
    ItemSelectionTableViewController *itemSelectViewController;
    
    IBOutlet UILabel *sumLabel;
    IBOutlet UIView *footerView;
    IBOutlet UIView *headerView;
    
}

-(void)prepareForTable:(Table *) table;
-(void)updateTicket;
-(void)readTicket:(NSDictionary*) dict;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;

@property(nonatomic, assign) IBOutlet UITableViewCell *tableViewCell;
@property(nonatomic, assign) IBOutlet UIView *headerView;
@property(nonatomic, assign) IBOutlet UIView *footerView;
@property(nonatomic, retain) Table* table;

@end