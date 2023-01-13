//
//  SearchLogStorageTests.swift
//  WorksMobileTests
//
//  Created by USER on 2023/01/13.
//

import Combine
import DataLayer
import DomainLayer
import XCTest

final class SearchLogStorageTests: XCTestCase {

    private var searchLogStorage: SearchLogStorage!
    private var cancellable: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.searchLogStorage = DefaultSearchLogStorage(coreDataService: CoreDataService(.inMemory))
        self.cancellable = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        searchLogStorage = nil
        cancellable = nil
    }

    func test_create_searchLog() {
        let expectation = expectation(description: "test_create_searchLog")
        searchLogStorage.update(keyword: "keyword")
            .combineLatest(searchLogStorage.update(keyword: "test"))
            .flatMap { _ in self.searchLogStorage.fetch() }
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
        
        self.searchLogStorage.delete(keyword: "keyword")
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { [weak self] in
                guard let self else { return }
                let items = $0.map { $0.toModel() }
                XCTAssertFalse(self.isContain(logs: items, find: "keyword"))
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
