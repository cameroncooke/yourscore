//
//  ScoreViewViewModel.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class ScoreViewViewModel {

    enum State: Equatable {
        case loading
        case loaded(model: ScoreLabelsViewModel)
        case failed
    }

    var state: State { stateSubject.value }

    private var stateSubject = CurrentValueSubject<State, Never>(.loading)
    var statePublisher: AnyPublisher<State, Never> { stateSubject.eraseToAnyPublisher() }

    private var retrySubject = PassthroughSubject<Void, Never>()
    var retryPublisher: AnyPublisher<Void, Never> { retrySubject.eraseToAnyPublisher() }

    let animated: Bool

    init(animated: Bool = true) {
        self.animated = animated
    }

    func loaded(model: Model) {
        let viewModel = ScoreLabelsViewModel(model: model)
        stateSubject.send(.loaded(model: viewModel))
    }

    func failed() {
        stateSubject.send(.failed)
    }

    func retryAction() {
        retrySubject.send()
    }

    var percentageComplete: CGFloat {
        switch state {
        case .loading:
            return 0

        case .loaded(let model):
            return CGFloat(model.score) / CGFloat(model.maxScore)

        case .failed:
            return 1
        }
    }
}
