//
//  SpyURLProtocol.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation

final class SpyURLProtocol: URLProtocol {

    enum Response {
       case success(data: Data, statusCode: Int)
       case failure(_ error: Error)
    }

    static var didStartLoading: ((URLRequest) -> Response)?
    static var canHandleRequest: ((URLRequest) -> Bool)?

    override func startLoading() {

        guard let response  = Self.didStartLoading?(request) else {
            fatalError("You must set didStartLoading before registering this protocol")
        }

        switch response {
        case .success(let data, let statusCode):

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: [:]
            )

            self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)

        case .failure(let error):
            self.client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let handler = canHandleRequest else { return false }
        return handler(request)
    }

    override func stopLoading() {
        // no-op
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
