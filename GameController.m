//
//  GameController.m
//  MineSweeper
//
//  Created by t on 09/04/13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "CellButton.h"

#define MINE_COUNT          10
#define CELL_COUNT_COLUMN   8
#define CELL_COUNT_ROW      8

@implementation GameController

- (id) init
{
    if( self = [super init]){
        cells_ = [NSMutableArray array];
        [cells_ retain];
        isInitedCells = NO;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(actionRevealAllMinesButton:)] autorelease];
    }
    return self;
}

- (void) dealloc
{
    [cells_ release];
    [super dealloc];
}

- (void) initCells : (CellButton *) sender
{
    for(int i = 0; i < MINE_COUNT; i++){
        while(1){
            int rand = random() % [cells_ count];
            CellButton * cell = [cells_ objectAtIndex:rand];
            if(cell != sender && !cell.isMine){
                cell.isMine = YES;
                break;
            }
        }
    }
    isInitedCells = YES;
}

- (void) clickCell : (CellButton *) sender
{
    if(! isInitedCells) [self initCells: sender];
    [sender open];

    if (sender.isMine)
        [self displayMessage:@":-("];
   
    else if ([self isAllMinesDetected])
        [self displayMessage:@":-)"];
}

-(void)loadView
{
    [super loadView];
	
    UIView * contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    contentView.backgroundColor = [UIColor whiteColor];
    
    int WIDTH  = CELL_COUNT_COLUMN;
    int HEIGHT = CELL_COUNT_ROW;
    
    CGSize canvasSize = self.view.frame.size;
    canvasSize.height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    int cellWidth = canvasSize.width / WIDTH;
    int cellHeight = canvasSize.height / HEIGHT;
    
	for(int x = 0; x < WIDTH; x++)	{
		for(int y = 0; y < HEIGHT; y++){
			CellButton * cell = [[CellButton alloc] init];
			[cell setFrame:CGRectMake(x * cellWidth, y * cellHeight, cellWidth, cellHeight)];
			//[cell setCenter:CGPointMake(160.0f, 208.0f)];
			[cell addTarget:self action:@selector(clickCell:) forControlEvents:UIControlEventTouchUpInside];
			[contentView addSubview: cell];
            [cells_ addObject: cell];
            [cell release];
		}
	}
    
	for(int x = 0; x < WIDTH; x++)	{
		for(int y = 0; y < HEIGHT; y++){
            CellButton * cell = [cells_ objectAtIndex:(x + y * WIDTH)];
            for(int i = -1; i <= 1; i++){
                for(int j = -1; j <= 1; j++){
                    if(x + i < 0 || x + i >= WIDTH)  continue;
                    if(y + j < 0 || y + j >= HEIGHT) continue;
                    
                    CellButton * cell_to = [cells_ objectAtIndex:( (x+i) + (y+j) * WIDTH)];
                    [cell addRoundCell:cell_to];
                    if(i == 0 || y == 0){
                        [cell addAdjCell:cell_to];            
                    }
                }
            }
		}
	}		  
    
	self.view = contentView;
	[contentView release];
}

- (BOOL)isAllMinesDetected
{
    for (CellButton *cell  in cells_)
        if ((!cell.isMine && !cell.isOpened) || (cell.isMine && cell.isOpened))
            return NO;
    
    return YES;
}

- (void)actionRevealAllMinesButton:(id)sender
{
    if(! isInitedCells) [self initCells: sender];
    
    for (CellButton *cell  in cells_)
        if (cell.isMine)
            [cell open];
}

- (void)displayMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
}

@end
