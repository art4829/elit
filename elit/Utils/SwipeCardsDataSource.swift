//
//  SwipeCardsDataSource.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/7/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
}

protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView)
}
