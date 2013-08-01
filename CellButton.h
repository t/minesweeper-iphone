//
//  CellButton.h
//  MineSweeper
//
//  Created by t on 09/04/18.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellButton : UIButton {
  NSMutableArray * round_cells_;
  NSMutableArray * adj_cells_;  
  BOOL isMine;
  BOOL isOpened;
}

@property (readwrite) BOOL isMine;
@property (readonly) BOOL isOpened;

- (void) addAdjCell: (CellButton *) cell;
- (void) addRoundCell: (CellButton *) cell;
- (int)  open;
- (void) markFlag;

@end
