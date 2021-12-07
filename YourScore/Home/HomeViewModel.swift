//
//  HomeViewModel.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit
import Combine

final class HomeViewModel {

    let scoreViewModel: ScoreViewViewModel
    let service: Service
    private var cancellables = Set<AnyCancellable>()

    init(
        service: Service,
        scoreViewModel: ScoreViewViewModel = ScoreViewViewModel()
    ) {
        self.service = service
        self.scoreViewModel = scoreViewModel

        subscribeToRetryPublisher()
    }

    func fetchScore() {
        service.fetch { result in
            switch result {
            case .success(let model):
                self.scoreViewModel.loaded(model: model)

            case .failure(let error):
                self.scoreViewModel.failed()
                debugPrint(error.localizedDescription)
                break
            }
        }
    }

    private func subscribeToRetryPublisher() {
        scoreViewModel.retryPublisher
            .sink { [weak self] in
                self?.fetchScore()
            }
            .store(in: &cancellables)
    }
}
