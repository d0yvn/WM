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
        
        let input = "keyword"
        
        self.searchLogRepository.update(keyword: input)
            .sink {
                Logger.print($0)
            } receiveValue: {
                XCTAssertEqual($0, input)
            }
            .store(in: &cancellable)
    }
    
    func test_delete_searchLog() {
        
        let input = "keyword"
        
        self.searchLogRepository.delete(keyword: input)
            .sink {
                Logger.print($0)
            } receiveValue: { [weak self] in
                
                if let self {
                    XCTAssertFalse(self.isContain(logs: $0, find: input))
                }
            }
            .store(in: &cancellable)
    }
    
    private func isContain(logs: [SearchLog], find: String) -> Bool {
        for log in logs {
            if log.keyword == find {
                return true
            }
        }
        return false
    }
}
