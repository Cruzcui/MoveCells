//
//  ViewController.m
//  MoveCell
//
//  Created by cuiyang on 14-5-23.
//  Copyright (c) 2014年 cuiyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate> {
    CGPoint startPoint;
    int x;
    int y;
    NSIndexPath * indexPath ;
    UITableViewCell * fakecell;
}
@property (nonatomic,weak) IBOutlet UITableView * mytableView;
@property (nonatomic,strong) UIImageView * fakeImage;
@property (nonatomic,weak) IBOutlet UILabel * box;
@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mytableView setDelegate:self];
    [self.mytableView setDataSource:self];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.mytableView addGestureRecognizer:longPressGr];
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19", nil];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.mytableView];
        indexPath = [self.mytableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        //add your code here
        
        fakecell = [self.mytableView cellForRowAtIndexPath:indexPath];
  
        //取出当前的cell
        UIGraphicsBeginImageContextWithOptions(fakecell.bounds.size, fakecell.opaque, 0.0);
        [fakecell.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        [fakecell setBackgroundColor:[UIColor darkGrayColor]];
        //在当前根视图添加一层UIImageView
        startPoint = [gesture locationInView:self.view];
        _fakeImage = [[UIImageView alloc] initWithImage:img];
        [_fakeImage setFrame:CGRectMake(0, startPoint.y, fakecell.frame.size.width, fakecell.frame.size.height)];
        _fakeImage.alpha = 0.7;
        [self.view addSubview:_fakeImage];
        x = startPoint.x - _fakeImage.center.x;
        y = startPoint.y - _fakeImage.center.y;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:self.view];
        //_fakeImage.center = point;
       
        CGPoint newPoint = CGPointMake(point.x - x, point.y - y);
        _fakeImage.center = newPoint;
        
        if (CGRectContainsPoint(self.box.frame, _fakeImage.center) ) {
            self.box.backgroundColor = [UIColor redColor];
        }else {
            self.box.backgroundColor = [UIColor clearColor];

        }
        

    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [_fakeImage removeFromSuperview];
        if (CGRectContainsPoint(self.box.frame, _fakeImage.center) ){
            [self delRows:indexPath.row];
        }else {
            [fakecell setBackgroundColor:[UIColor clearColor]];
        }
         self.box.backgroundColor = [UIColor clearColor];
        _fakeImage = nil;
        
    }
}
-(void) delRows:(int)row {
        [fakecell setBackgroundColor:[UIColor clearColor]];
        [self.dataSource removeObjectAtIndex:row];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                    inSection:0];
        [indexPaths addObject:indexPath];
        [self.mytableView beginUpdates];
    
        [self.mytableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
        [self.mytableView endUpdates];
        [self.mytableView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
     CGPoint point = [[touches anyObject]locationInView:self.view];
    _fakeImage.center = point;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   }
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
