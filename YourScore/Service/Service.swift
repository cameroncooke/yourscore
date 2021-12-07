//
//  Service.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import Combine

enum ServiceError: Error {
    case networkError
    case serverError(underlyingError: Error)
}

final class Service {

    typealias Completion = (Result<Model, ServiceError>) -> Void

    var fetch: (_ completion: @escaping Completion) -> Void

    init(fetch: @escaping (@escaping Completion) -> Void) {
        self.fetch = fetch
    }
}

extension Service {

    static let live: Service = {

        var cancellable: AnyCancellable?
        let url = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")!

        return Service(
            fetch: { completion in

                cancellable = URLSession.shared
                    .dataTaskPublisher(for: url)
                    .tryMap {
                        guard let httpResponse = $0.response as? HTTPURLResponse,
                              httpResponse.statusCode >= 200,
                              httpResponse.statusCode <= 299 else {
                            throw URLError(.badServerResponse)
                        }
                        return $0.data
                    }
                    .decode(type: Model.self, decoder: JSONDecoder())
                    .mapError { ServiceError.serverError(underlyingError: $0) }
                    .receive(on: DispatchQueue.main)
                    .sink(
                        receiveCompletion: {
                            switch $0 {
                            case .failure(let error):
                                completion(.failure(error))
                            default:
                                // no-op
                                break
                            }
                        },
                        receiveValue: { model in
                            completion(.success(model))
                        }
                    )
            }
        )
    }()
}

extension Service {

    static let stub = Service(
        fetch: { completion in
            completion(.success(
                Model(
                    score: 578,
                    minScore: 0,
                    maxScore: 700
                )
            ))
        }
    )

    static let loading = Service(
        fetch: { _ in
            // no op
        }
    )

    static let stubWithDelay = Service(
        fetch: { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2300)) {
                Service.stub.fetch(completion)
            }
        }
    )

    static let failing = Service(
        fetch: { completion in
            completion(.failure(ServiceError.networkError))
        }
    )

    static let failingWithDelay = Service(
        fetch: { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
                Service.failing.fetch(completion)
            }
        }
    )
}
