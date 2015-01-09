//
//  SeriesTableViewController.m
//  Mosalsalaty
//
//  Created by Osama Rabie on 1/10/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "SeriesTableViewController.h"
#import "EposidesTableViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SeriesTableViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@end

@implementation SeriesTableViewController
{
    NSMutableData* responseData;
    NSMutableArray* dataSource;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"epSeg"])
    {
        EposidesTableViewController* dts = (EposidesTableViewController*)[segue destinationViewController];
        [dts setSeries:[dataSource objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    responseData = [[NSMutableData alloc]init];
    dataSource = [[NSMutableArray alloc]init];
    
    NSString *post = @"";
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSURL *url = [NSURL URLWithString:@"http://osamalogician.com/arabDevs/mosalsalaty/getSeries.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:90.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
   NSURLConnection* getSeriesConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self    startImmediately:NO];
    
    [getSeriesConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                          forMode:NSDefaultRunLoopMode];
    [getSeriesConnection start];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"seriesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];


    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary* series = [dataSource objectAtIndex:indexPath.row];
    
    UIImageView* oldImage = (UIImageView*)[ cell.contentView viewWithTag:1];

    [oldImage setImage:[UIImage imageNamed:@"loading.png"]];
    
    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[series objectForKey:@"image"]]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                    {
                        UIImageView* oldImage = (UIImageView*)[ updateCell.contentView viewWithTag:1];
                        [oldImage setImage:image];
                    }
                });
            }
        }
    });
    
       
    
    [(UILabel*)[cell viewWithTag:2] setText:[series objectForKey:@"name"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"epSeg" sender:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error2;
    
    dataSource = [[NSMutableArray alloc]initWithArray:[NSJSONSerialization
                                                       JSONObjectWithData:responseData
                                                       options:kNilOptions
                                                       error:&error2]];

    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

@end
