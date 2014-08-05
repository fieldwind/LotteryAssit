//
//  GSWebViewController.m
//  EOffice
//
//  Created by ios on 14-7-1.
//  Copyright (c) 2014年 Su. All rights reserved.
//

#import "GSWebViewController.h"
#import "GSProjectHeader.h"
#import "UserDataManager.h"
#import "GIMapViewController.h"

@interface GSWebViewController (){
    UIActivityIndicatorView* _indView;
    BOOL _isGotoNextPage;
}

@property (nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBar;

@end

@implementation GSWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.urlString = Server_URL_Login;

    _indView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     //12.0;
    CGFloat width = 20, height = 20;
//    CGFloat _offsetX = self.view.frame.size.width/2 - width/2;
//    CGFloat _offsetY = self.view.frame.size.height/2 - height/2;
    CGFloat _offsetX = self.view.frame.size.height/2 - width/2;
    CGFloat _offsetY = self.view.frame.size.width/2 - height/2;

//    CGRect rect = CGRectMake(_offsetX, _offsetY, self.view.frame.size.width-_offsetX*2, self.view.frame.size.height-_offsetY*2);
    CGRect rect = CGRectMake(_offsetX, _offsetY, width, height);
    
    _indView.frame = rect;
    [self.view addSubview:_indView];
    [_indView setHidden:YES];
    
    //[self configureWebView];
    [self loadAddressURL];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

    [super viewWillAppear:animated];
    _isGotoNextPage = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}

- (void)loadAddressURL {
    NSURL *requestURL = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    
//    UIBarButtonItem *backItem;
//    backItem =[[UIBarButtonItem alloc]init];
//    backItem.title=@"11";
//    //self.navigationController.navigationBar.backItem.leftBarButtonItem = backItem;
//    self.navigationController.navigationItem.backBarButtonItem = backItem;
//    //self.navigationController.navigationBar.backItem.leftBarButtonItem.title = @"后退";
    
    //dbg code
#if 0
    WSSite* st = [[WSSite alloc]init];
    st.siteID = @"4028810e42784a570142786cdff50084";
    NSArray* testarr = [NSArray arrayWithObjects:st, nil];
    [self performSegueWithIdentifier:@"web2Map" sender:[NSArray arrayWithObjects:testarr, @"杭州",nil]];
    return;
#endif
    
    [_indView setHidden:NO];
    [_indView startAnimating];
}


#pragma mark - Configuration

- (void)configureWebView {
    if(!self.webView){
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    }
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];

}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_indView stopAnimating];
    [_indView setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Report the error inside the web view.
//    NSString *localizedErrorMessage = NSLocalizedString(@"An error occured:", nil);
//    NSString *errorFormatString = @"<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">%@%@</div></body></html>";
//    
//    NSString *errorHTML = [NSString stringWithFormat:errorFormatString, localizedErrorMessage, error.localizedDescription];
//    [self.webView loadHTMLString:errorHTML baseURL:nil];
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest:%@",request.URL);
    
    if([request.URL.absoluteString isEqualToString:Server_URL_AfterLogin]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[UserDataManager sharedManager]accessCurrUser];
            if(![UserDataManager sharedManager].isSentDeviceToken){
                dispatch_after(1.0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[UserDataManager sharedManager]sendDevcieToken];
                });
            }

        });
    }
    

    
#if 1
    NSString* prefix = [NSString stringWithFormat:@"%@%@",Server_BaseURL,Server_BroswerSitesURL];
    if(!_isGotoNextPage
       && ([request.URL.absoluteString hasPrefix:prefix]
       ))
#else
    //below is dbg condition
    if(!_isGotoNextPage
       && ([request.URL.absoluteString hasSuffix:Server_BroswerSitesURL]
           || [request.URL.absoluteString hasSuffix:@"gogis.html"]
           || [request.URL.absoluteString hasSuffix:@"welcome.html#"]
           ))
#endif
    {
        _isGotoNextPage = YES;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[UserDataManager sharedManager]accessSites:^(NSArray *array, NSError *error) {
                if(!error && array){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString* code = @"杭州";
                        NSRange range = [request.URL.absoluteString rangeOfString:@"org_name="];
                        if(NSNotFound != range.location){
                            NSString* fullcodeString = [request.URL.absoluteString substringFromIndex:range.location];
                            if(fullcodeString){
                                code = [fullcodeString substringFromIndex:[@"org_name=" length]];
                            }
                        }
                        
                        
                        
//                        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
//                        GIMapViewController* mapVC = [sb instantiateViewControllerWithIdentifier:@"GIMapViewController"];
//                        mapVC.dateSource = array;
//                        [self.navigationController pushViewController:mapVC animated:YES];
                        
                        
                        
                        [self performSegueWithIdentifier:@"web2Map" sender:[NSArray arrayWithObjects:array, code,nil]];

                    });
                }
            } userID:[UserDataManager sharedManager].currUser];
            
        });
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)loadWebContent:(NSURL *)url
{
    NSURL *requestURL = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [self.webView loadRequest:request];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if([segue.identifier isEqualToString:@"web2Map"]){
        self.navigationController.navigationBarHidden = NO;
        GIMapViewController* mapVC = [segue destinationViewController];
        NSArray* params = (NSArray*)sender;
        mapVC.dateSource = [params objectAtIndex:0];
        mapVC.orgCode = [params objectAtIndex:1];
    }
}

@end
