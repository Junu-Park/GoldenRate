//
//  CalculatorViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 4/12/25.
//

import Combine

struct CalculatorViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
