//
//  RSSViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/14/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "RSSViewController.h"
#import "MethodsCache.h"
#import "Constants.h"
#import "RSSDetailViewController.h"

@interface RSSViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;
@property (weak, nonatomic) IBOutlet UILabel *rssLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *forecastButton;
@property (weak, nonatomic) IBOutlet UIButton *todoButton;

@property (weak, nonatomic) IBOutlet UIButton *rssButtonA;
@property (weak, nonatomic) IBOutlet UIButton *rssButtonB;
@property (weak, nonatomic) IBOutlet UIButton *rssButtonC;
@property (weak, nonatomic) IBOutlet UIButton *rssButtonD;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIView *overlayContainer;
@property (weak, nonatomic) IBOutlet UIButton *category1;
@property (weak, nonatomic) IBOutlet UIButton *category2;
@property (weak, nonatomic) IBOutlet UIButton *category3;
@property (weak, nonatomic) IBOutlet UIButton *category4;

@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSMutableString *rssTitle;
@property (strong, nonatomic) NSMutableString *rssLink;
@property (strong, nonatomic) NSString *element;

@property MethodsCache *method;
@property NSInteger category;

- (IBAction)category1Tapped:(id)sender;
- (IBAction)category2Tapped:(id)sender;
- (IBAction)category3Tapped:(id)sender;
- (IBAction)category4Tapped:(id)sender;

- (IBAction)buttonATapped:(id)sender;
- (IBAction)buttonBTapped:(id)sender;
- (IBAction)buttonCTapped:(id)sender;
- (IBAction)buttonDTapped:(id)sender;
- (IBAction)closeTapped:(id)sender;

- (IBAction)homeTapped:(id)sender;
- (IBAction)todoTapped:(id)sender;

@end

@implementation RSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.method = [MethodsCache new];
    
    self.forecastButton.hidden = YES;
    
    self.backgroundImage.image = [UIImage imageNamed:@"rss background"];
    self.backgroundImage.alpha = 0.8;
    
    [self.homeButton setBackgroundImage:[UIImage imageNamed:@"home button"] forState:UIControlStateNormal];
    [self.todoButton setBackgroundImage:[UIImage imageNamed:@"todo button"] forState:UIControlStateNormal];
    [self.method buttonBorderColor:[UIColor whiteColor] andWidth:1.0 forArray:[self buttonArray]];
    [self.method roundButtonCorners:8.0 forArray:[self buttonArray]];
    
    [self.closeButton setTitle:@"B\nA\nC\nK" forState:UIControlStateNormal];
    [self.category1 setTitle:@"World News" forState:UIControlStateNormal];
    [self.category2 setTitle:@"Science &\nTechnology" forState:UIControlStateNormal];
    [self.category3 setTitle:@"Business News" forState:UIControlStateNormal];
    [self.category4 setTitle:@"Entertainment" forState:UIControlStateNormal];
    [self.method centerButtonText:[self rssButtonArray]];
    [self.method buttonBorderColor:[UIColor whiteColor] andWidth:2.0 forArray:[self rssButtonArray]];
    [self.method roundButtonCorners:8.0 forArray:[self rssButtonArray]];
    [self.method addTopBorderWithColor:[UIColor whiteColor] andWidth:2.0 to:self.labelContainer];
    [self.method addBottomBorderWithColor:[UIColor whiteColor] andWidth:2.0 to:self.labelContainer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)rssButtonArray
{
    NSArray *buttons = @[self.category1, self.category2, self.category3, self.category4, self.rssButtonA, self.rssButtonB, self.rssButtonC, self.rssButtonD, self.closeButton];
    return  buttons;
}

-(NSArray *)buttonArray
{
    NSArray *buttons = @[self.homeButton, self.todoButton];
    return buttons;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.feeds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rssCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [[self.feeds objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor = [UIColor clearColor];
    
    [self.method addBottomBorderWithColor:[UIColor whiteColor] andWidth:0.5 to:cell];
    
    //Changes the selected cell's highlight color
    UIView *highlightCell = [UIView new];
    [highlightCell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    cell.selectedBackgroundView = highlightCell;
    
    return cell;
}

#pragma mark - XMLParser Methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.element = elementName;
    
    if ([self.element isEqualToString:@"item"])
    {
        self.item = [[NSMutableDictionary alloc]init];
        self.rssTitle = [[NSMutableString alloc]init];
        self.rssLink = [[NSMutableString alloc]init];
        
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        [self.item setObject:self.rssTitle forKey:@"title"];
        [self.item setObject:self.rssLink forKey:@"link"];
        
        [self.feeds addObject:[self.item copy]];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.element isEqualToString:@"title"])
    {
        [self.rssTitle appendString:string];
    } else if ([self.element isEqualToString:@"link"])
    {
        [self.rssLink appendString:string];
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
    
}

- (void)loadRSSFeedWithURLString:(NSString *)urlString
{
    self.feeds = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:urlString];
    self.parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    self.parser.delegate = self;
    self.parser.shouldResolveExternalEntities = NO;
    [self.parser parse];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"rssDetailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [self.feeds[indexPath.row]objectForKey:@"link"];
        [[segue destinationViewController]setUrl:string];
//        RSSDetailViewController *rssDetailVC = [segue destinationViewController];
//        rssDetailVC.url = string;
    }
}


-(void)categorySelected
{
    switch (self.category)
    {
        case 1:
            [self.rssButtonA setTitle:@"BBC News\nWorld" forState:UIControlStateNormal];
            [self.rssButtonB setTitle:@"Reuters\nWorld" forState:UIControlStateNormal];
            [self.rssButtonC setTitle:@"NY Post\nWorld" forState:UIControlStateNormal];
            [self.rssButtonD setTitle:@"Huffington Post\nWorld" forState:UIControlStateNormal];
            break;
        case 2:
            [self.rssButtonA setTitle:@"BBC News\nTechnology" forState:UIControlStateNormal];
            [self.rssButtonB setTitle:@"Reuters\nScience" forState:UIControlStateNormal];
            [self.rssButtonC setTitle:@"NY Post\nTechnology" forState:UIControlStateNormal];
            [self.rssButtonD setTitle:@"Huffington Post\nScience" forState:UIControlStateNormal];
            break;
        case 3:
            [self.rssButtonA setTitle:@"BBC News\nBusiness" forState:UIControlStateNormal];
            [self.rssButtonB setTitle:@"Reuters\nBusiness" forState:UIControlStateNormal];
            [self.rssButtonC setTitle:@"NY Post\nBusiness" forState:UIControlStateNormal];
            [self.rssButtonD setTitle:@"Huffington Post\nBusiness" forState:UIControlStateNormal];
            break;
        case 4:
            [self.rssButtonA setTitle:@"BBC News\nEntertainment" forState:UIControlStateNormal];
            [self.rssButtonB setTitle:@"Reuters\nEntertainment" forState:UIControlStateNormal];
            [self.rssButtonC setTitle:@"NY Post\nEntertainment" forState:UIControlStateNormal];
            [self.rssButtonD setTitle:@"Huffington Post\nEntertainment" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    self.overlayContainer.hidden = YES;
}

- (IBAction)category1Tapped:(id)sender
{
    self.category = 1;
    [self categorySelected];
}

- (IBAction)category2Tapped:(id)sender
{
    self.category = 2;
    [self categorySelected];
}

- (IBAction)category3Tapped:(id)sender
{
    self.category = 3;
    [self categorySelected];
}

- (IBAction)category4Tapped:(id)sender
{
    self.category = 4;
    [self categorySelected];
}

- (IBAction)buttonATapped:(id)sender
{
    switch (self.category)
    {
        case 1:
            [self loadRSSFeedWithURLString:BBC_WORLD_URL];
            self.rssLabel.text = @"BBC News: World";
            break;
        case 2:
            [self loadRSSFeedWithURLString:BBC_TECH_URL];
            self.rssLabel.text = @"BBC News: Technology";
            break;
        case 3:
            [self loadRSSFeedWithURLString:BBC_BUSINESS_URL];
            self.rssLabel.text = @"BBC News: Business";
            break;
        case 4:
            [self loadRSSFeedWithURLString:BBC_ENTERTAIN_URL];
            self.rssLabel.text = @"BBC News: Entertainment & Arts";
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonBTapped:(id)sender
{
    switch (self.category)
    {
        case 1:
            [self loadRSSFeedWithURLString:REUTERS_WORLD_URL];
            self.rssLabel.text = @"Reuters: World News";
            break;
        case 2:
            [self loadRSSFeedWithURLString:REUTERS_SCI_URL];
            self.rssLabel.text = @"Reuters: Science News";
            break;
        case 3:
            [self loadRSSFeedWithURLString:REUTERS_BUSINESS_URL];
            self.rssLabel.text = @"Reuters: Business News";
            break;
        case 4:
            [self loadRSSFeedWithURLString:REUTERS_ENTERTAIN_URL];
            self.rssLabel.text = @"Reuters: Entertainment News";
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonCTapped:(id)sender
{
    switch (self.category)
    {
        case 1:
            [self loadRSSFeedWithURLString:NYP_WORLD_URL];
            self.rssLabel.text = @"New York Post: News";
            break;
        case 2:
            [self loadRSSFeedWithURLString:NYP_TECH_URL];
            self.rssLabel.text = @"New York Post: Technology";
            break;
        case 3:
            [self loadRSSFeedWithURLString:NYP_BUSINESS_URL];
            self.rssLabel.text = @"New York Post: Business";
            break;
        case 4:
            [self loadRSSFeedWithURLString:NYP_ENTERTAIN_URL];
            self.rssLabel.text = @"New York Post: Entertainment";
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonDTapped:(id)sender
{
    switch (self.category)
    {
        case 1:
            [self loadRSSFeedWithURLString:HUFF_WORLD_URL];
            self.rssLabel.text = @"Huffington Post: World News";
            break;
        case 2:
            [self loadRSSFeedWithURLString:HUFF_SCI_URL];
            self.rssLabel.text = @"Huffington Post: Science News";
            break;
        case 3:
            [self loadRSSFeedWithURLString:HUFF_BUSINESS_URL];
            self.rssLabel.text = @"Huffington Post: Business News";
            break;
        case 4:
            [self loadRSSFeedWithURLString:HUFF_ENTERTAIN_URL];
            self.rssLabel.text = @"Huffington Post: Entertainment News";
            break;
            
        default:
            break;
    }
}

- (IBAction)closeTapped:(id)sender
{
    self.overlayContainer.hidden = NO;
}

- (IBAction)homeTapped:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)todoTapped:(id)sender
{
    
}















@end
