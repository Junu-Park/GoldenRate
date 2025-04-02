//
//  HomeCollectionViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import Foundation

enum HomeCollectionViewSection {
    case chart
    case ranking
}

enum HomeCollectionViewItem: Hashable {
    case chart(item: [RateChartEntity])
    case ranking(depositItem: [DepositProductEntity], savingItem: [SavingProductEntity])
}
