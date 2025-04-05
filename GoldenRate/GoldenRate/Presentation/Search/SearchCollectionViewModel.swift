//
//  SearchCollectionViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 4/5/25.
//

import Foundation

enum SearchCollectionViewSection {
    case main
}

enum SearchCollectionViewItem: Hashable {
    case deposit(item: DepositProductEntity)
    case saving(item: SavingProductEntity)
    case skeleton(id: UUID)
}
