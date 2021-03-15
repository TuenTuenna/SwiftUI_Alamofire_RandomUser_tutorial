//
//  RandomUserViewModel.swift
//  RandomUserApi
//
//  Created by Jeff Jeong on 2021/03/10.
//

import Foundation
import Combine
import Alamofire

class RandomUserViewModel: ObservableObject {
    
    //MARK: Properties
    var subscription = Set<AnyCancellable>()
    
    @Published var randomUsers = [RandomUser]()
    
    @Published var pageInfo : Info? {
        didSet {
            print("pageInfo: \(pageInfo)")
        }
    }
    
    @Published var isLoading : Bool = false
    
    var refreshActionSubject = PassthroughSubject<(), Never>()
    var fetchMoreActionSubject = PassthroughSubject<(), Never>()
    
    init() {
        print(#fileID, #function, #line, "")
        fetchRandomUsers()
        
        refreshActionSubject.sink{ [weak self] _ in
            guard let self = self else { return }
            print("RandomUserViewModel - init - refreshActionSubject")
            self.fetchRandomUsers()
        }.store(in: &subscription)
        
        fetchMoreActionSubject.sink{[weak self] _ in
            guard let self = self else { return }
            print("RandomUserViewModel - init - refreshActionSubject")
            if !self.isLoading {
                self.fetchMore()
            }
        }.store(in: &subscription)
            
    }
    
    fileprivate func fetchMore(){
        print(#fileID, #function, #line, "")
        guard let currentPage = pageInfo?.page else {
            print("페이지 정보가 없습니다.")
            return
        }
        self.isLoading = true
        let pageToLoad = currentPage + 1
        AF.request(RandomUserRouter.getUsers(page: pageToLoad))
            .publishDecodable(type: RandomUserResponse.self)
            .compactMap{ $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료 ")
                self.isLoading = false
            }, receiveValue: { receivedValue in
                print("받은 값 : \(receivedValue.results.count)")
                self.randomUsers += receivedValue.results
                self.pageInfo = receivedValue.info
            }).store(in: &subscription)
    }
    
    fileprivate func fetchRandomUsers(){
        print(#fileID, #function, #line, "")
        AF.request(RandomUserRouter.getUsers())
            .publishDecodable(type: RandomUserResponse.self)
            .compactMap{ $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료 ")
            }, receiveValue: { receivedValue in
                print("받은 값 : \(receivedValue.results.count)")
                self.randomUsers = receivedValue.results
                self.pageInfo = receivedValue.info
            }).store(in: &subscription)
    }
    
}
