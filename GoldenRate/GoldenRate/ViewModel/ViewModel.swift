//
//  ViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 3/28/25.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func tranform(input: Input) -> Output
}
