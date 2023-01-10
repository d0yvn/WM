//
//  SearchLogRepositoryTests.swift
//  WorksMobileTests
//
//  Created by USER on 2023/01/10.
//
import Combine
import DataLayer
import DomainLayer
import Utils
import XCTest

final class SearchLogRepositoryTests: XCTestCase {

    private var cancellable: Set<AnyCancellable>!
    private var searchLogRepository: SearchLogRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.searchLogRepository = DefaultSearchLogRepository()
        self.cancellable = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.cancellable = nil
        self.searchLogRepository = nil
    }

    func test_create_searchLog() {
        
        let expectation = expectation(description: "test_create_searchLog")
        self.searchLogRepository.update(keyword: "keyword")
            .combineLatest(searchLogRepository.update(keyword: "test"))
            .flatMap { _ in self.searchLogRepository.fetchSearchLog() }
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { logs in
                XCTAssertEqual(logs.count, 2, "검색된 히스토리는 현재\(logs.count)개입니다. \(logs)")
            })
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 3)
    }
    
    func test_delete_searchLog() {
        let expectation = expectation(description: "test_create_searchLog")
        self.searchLogRepository.delete(keyword: "keyword")
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { [weak self] in
                guard let self else { return }
                XCTAssertFalse(self.isContain(logs: $0, find: "keyword"))
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 3)
    }
    
    private func isContain(logs: [SearchLog], find: String) -> Bool {
        for log in logs where log.keyword == find {
            return true
        }
        return false
    }
}
