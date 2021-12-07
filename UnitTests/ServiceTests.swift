//
//  ServiceTests.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import XCTest
@testable import YourScore

final class ServiceTests: XCTestCase {

    private static let expectedURL = "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values"

    override class func setUp() {
        super.setUp()
        URLProtocol.registerClass(SpyURLProtocol.self)
    }

    override class func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(SpyURLProtocol.self)
    }

    func testFetchStartsURLSessionDataTaskWithExpectedURL() {

        let expectation = self.expectation(description: "urls are set by the handler")

        var urls: [URL?]? = []
        SpyURLProtocol.canHandleRequest = { request in
            return true
        }

        SpyURLProtocol.didStartLoading = { request in
            urls?.append(request.url)
            return .failure(URLError(.cancelled))
        }

        let service: Service = .live
        service.fetch { _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertTrue(
            try XCTUnwrap(urls).contains(
                where: { $0?.absoluteString == Self.expectedURL }
            )
        )
    }

    func testFetchFailsWithServerErrorForNon200RangeStatusCode() {

        let expectation = self.expectation(description: "result is set ")

        SpyURLProtocol.canHandleRequest = { request in
            return request.url?.absoluteString == Self.expectedURL
        }

        SpyURLProtocol.didStartLoading = { request in
            return .success(data: Data(), statusCode: 500)
        }

        var result: Result<Model, ServiceError>?

        let service: Service = .live
        service.fetch {
            result = $0
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(
            try XCTUnwrap(result),
            .failure(.serverError(underlyingError: URLError(.badServerResponse)))
        )
    }

    func testFetchSucceedsWithExpectedModel() throws {

        let expectation = self.expectation(description: "result is set")

        let model = Model(score: 222, minScore: 111, maxScore: 333)
        let data = try JSONEncoder().encode(model)

        SpyURLProtocol.canHandleRequest = { request in
            return request.url?.absoluteString == Self.expectedURL
        }

        SpyURLProtocol.didStartLoading = { request in
            return .success(data: data, statusCode: 200)
        }

        var result: Result<Model, ServiceError>?

        let service: Service = .live
        service.fetch {
            result = $0
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(try XCTUnwrap(result), .success(model))
    }
}

extension ServiceError: Equatable {

    public static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError, .networkError):
            return true
        case (.serverError(let lhsError), .serverError(let rhsError)):

            guard let lhsError = lhsError as? URLError,
                  let rhsError = rhsError as? URLError else {
                      return false
                  }

            return lhsError.code == rhsError.code
        default:
            return false
        }
    }
}


extension Model: Encodable {

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        var infoContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .creditReportInfo)

        try infoContainer.encode(score, forKey: .score)
        try infoContainer.encode(minScore, forKey: .minScore)
        try infoContainer.encode(maxScore, forKey: .maxScore)
    }
}
