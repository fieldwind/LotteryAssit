//
//  ColViewController.m
//  test31ScrollCollectionView
//
//  Created by frank weng on 21/6/14.
//  Copyright (c) 2014 frank weng. All rights reserved.
//

#import "ColViewController.h"
#import "ColCellView.h"
#import "ColCellViewController.h"
#import "AppModules.h"


@interface ColViewController (){
    CGPoint _startPoint;
}
@property (strong,atomic) NSMutableArray* colCellArray;
@end

@implementation ColViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    
    self.colCellArray = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!self.colCellArray){
        self.colCellArray = [NSMutableArray array];
    }
    
    
}

-(void)uiInit
{
    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scr.tag = 1;
    scr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:scr];
    
    CGFloat everWidth  = self.view.frame.size.width/3;
    CGFloat everHeight = self.view.frame.size.height/3;
    //    everHeight = 108; //dbg
    
    long itemNum = [self.dataSource count];
    for(long i=0; i<itemNum; i++){
        
        CGFloat startX = i%3*everWidth;
        CGFloat startY = i/3*everHeight;
        
        //ColCellViewController* cellVC = [[ColCellViewController alloc]initWithNibName:@"ColCellViewController" bundle:nil];
        ColCellViewController* cellVC = [[ColCellViewController alloc]init];
        AppModules* item = [self.dataSource objectAtIndex:i];
        cellVC.itemIcon = item.icon;
        cellVC.itemTitle = item.cname;
        cellVC.appItem = item;
        cellVC.delegate = self.delegate;
        cellVC.tag = i;
        
        cellVC.view.frame = CGRectMake(startX, startY, everWidth, everHeight);
        [cellVC uiInit];
        [scr addSubview:cellVC.view];
        
        //        ColCellView* cellview = [[ColCellView alloc]initWithFrame:CGRectMake(startX, startY, everWidth, everHeight)];
        //        [scr addSubview:cellview];
        [self.colCellArray addObject:cellVC];
    }
    
    //self.view.backgroundColor = [UIColor redColor];
    //UIScrollView
    
    [scr setContentSize:CGSizeMake(self.view.frame.size.width, (((itemNum-1)/3+1)*everHeight))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view edit support


-(void)moveView:(NSUInteger)oldIndex toPostion:(NSUInteger)newIndex
{
    if(oldIndex == newIndex)
        return;
    
    ColCellViewController* oldCellVC = [[self.colCellArray objectAtIndex:oldIndex] copy];
    ColCellViewController* newCellVC = [[self.colCellArray objectAtIndex:newIndex] copy];
    
    CGRect temp = newCellVC.view.frame;
    newCellVC.view.frame = oldCellVC.view.frame;
    oldCellVC.view.frame = temp;

//    if(oldIndex > newIndex){
//        for(NSUInteger i=newIndex; i<oldIndex; i++){
//            ColCellViewController *curCellVC = [self.colCellArray objectAtIndex:i];
//            ColCellViewController *nextCellVC = [self.colCellArray objectAtIndex:i+1];
//            
//            curCellVC.view.frame = nextCellVC.view.frame;
//        }
//    }else{
//        for(NSUInteger i=oldIndex; i<newIndex; i++){
//            ColCellViewController *curCellVC = [self.colCellArray objectAtIndex:i];
//            ColCellViewController *nextCellVC = [self.colCellArray objectAtIndex:i+1];
//            
//            curCellVC.view.frame = nextCellVC.view.frame;
//        }
//    }
    
    [self.colCellArray replaceObjectAtIndex:oldIndex withObject:newCellVC];
    [self.colCellArray replaceObjectAtIndex:newIndex withObject:oldCellVC];
    
    return;
}

-(void)reloadViewWithRemoveSubView:(NSUInteger)index
{
    
    ColCellViewController* removeCellVC = [self.colCellArray objectAtIndex:index];
    //ColCellViewController* lastCellVC = [self.colCellArray objectAtIndex:[self.colCellArray count]-1];

    [UIView animateWithDuration:0.2 animations:^{
        CGRect removeFrame = removeCellVC.view.frame;
        CGRect curFrame;
        for (int i=index; i < [self.colCellArray count]; i++) {
            UIView *temp = [self.colCellArray objectAtIndex:i];
            curFrame = temp.frame;
            [temp setFrame:removeFrame];
            removeFrame = curFrame;
            temp.tag = i;
        }
    }];
    [removeCellVC.view removeFromSuperview];
    
    [self.colCellArray removeObjectAtIndex:index];
}

@end
