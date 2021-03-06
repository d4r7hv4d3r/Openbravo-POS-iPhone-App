//
//  TableSelectionViewController.m
//  OpenbravoPOSApp
//
//  Created by Axel Ruder on 02.04.11.
//  Copyright 2011 msg systems ag. All rights reserved.
//

#import "TableSelectionViewController.h"
#import "TableItemsTableViewController.h"
#import "OpenbravoPOSAppAppDelegate.h"
#import "JSON.h"
#import "Table.h"
#import "UIAlertView+Blocks.h"

@implementation TableSelectionViewController


@synthesize selectedTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [busyTables release];
    [tableArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL) isTableBusy:(Table *)table {
    return [busyTables containsObject:table.id];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (tableArray == nil) {
        tableArray = [[NSMutableArray alloc] init];
    }
    if (busyImage == nil) {
        NSString *busyImageFile = [[NSBundle mainBundle] pathForResource:@"edit_group" ofType:@"png"];
        busyImage = [[UIImage alloc] initWithContentsOfFile:busyImageFile];
        NSString *emptyImageFile = [[NSBundle mainBundle] pathForResource:@"empty" ofType:@"png"];
        emptyImage = [[UIImage alloc] initWithContentsOfFile:emptyImageFile];
    }
    
    responseData = [[NSMutableData alloc] init];
    NSString *baseUrl = [OpenbravoPOSAppAppDelegate getWebAppURL];
    NSString *url = [NSString stringWithFormat:@"%@/tables", baseUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidUnload
{
    [busyImage release];
    [emptyImage release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    
    NSString *baseUrl = [OpenbravoPOSAppAppDelegate getWebAppURL];
    
    NSString *url = [NSString stringWithFormat:@"%@/tables/busyTables", baseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    NSError *error;
    [[OpenbravoPOSAppAppDelegate getInstance] requestNetworkActivityIndicator];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    [[OpenbravoPOSAppAppDelegate getInstance] releaseNetworkActivityIndicator];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *results = [responseString JSONValue];
    [responseString release];
    
    if (busyTables == nil) {
        busyTables = [[NSMutableArray alloc] init];
    } else {
        [busyTables removeAllObjects];
    }
    
    NSArray *localTables = results;
    for (int i=0; i < [localTables count]; i++) {
        NSDictionary* tableDict = [localTables objectAtIndex:i];        
        [busyTables addObject:[tableDict objectForKey:@"id"]];
    }
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Wiederholen"]) {
        NSString *baseUrl = [OpenbravoPOSAppAppDelegate getWebAppURL];
        NSString *url = [NSString stringWithFormat:@"%@/tables", baseUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error loading tables!" message:@"Could not retrieve tables from server!" delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Wiederholen", nil];
    [alertView show];
    [alertView release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    NSLog(@"Response: %@", responseString);
    
	NSArray *results = [responseString JSONValue];
    NSLog(@"Count: %d", [results count]);
    
    NSArray *localTables = results;
    for (int i=0; i < [localTables count]; i++) {
        NSDictionary* tableDict = [localTables objectAtIndex:i];
        Table *t = [[Table alloc] init];
        t.id = [tableDict objectForKey:@"id"];
        t.name = [tableDict objectForKey:@"name"];
        NSLog(@"Tisch: [id=%@, name=%@]", t.id, t.name);
        [tableArray addObject:t];
        NSLog(@"###Table count: %d", [tableArray count]);
        [t release];
        
    }
    [responseString release];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    if (tableArray != nil) {
        rowCount = [tableArray count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[tableArray objectAtIndex:indexPath.row] name];
    if ([self isTableBusy:[tableArray objectAtIndex:indexPath.row]]) {
        cell.imageView.image = busyImage;
    } else {
        cell.imageView.image = emptyImage;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTable = [tableArray objectAtIndex:indexPath.row];
}

@end
