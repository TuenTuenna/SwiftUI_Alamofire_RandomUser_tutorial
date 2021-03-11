//
//  ContentView.swift
//  RandomUserApi
//
//  Created by Jeff Jeong on 2021/03/10.
//

import SwiftUI
import UIKit
import Introspect

class RefreshControlHelper {
    
    //MARK: Properties
    var parentContentView : ContentView?
    var refreshControl : UIRefreshControl?
    
    @objc func didRefresh(){
        print(#fileID, #function, #line, "")
        guard let parentContentView = parentContentView,
              let refreshControl = refreshControl else {
            print("parentContentView, refreshControl 가 nil 입니다")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            print("리프레시가 되었다")
            //MARK: - TODO : Api 다시 땡기기
//            parentContentView.randomUserViewModel.fetchRandomUsers()
            parentContentView.randomUserViewModel.refreshActionSubject.send()
            refreshControl.endRefreshing()
        })
    }
    
}

struct ContentView: View {
    
    @ObservedObject var randomUserViewModel = RandomUserViewModel()
    
    let refreshControlHelper = RefreshControlHelper()
    
    var body: some View {
        
        List(randomUserViewModel.randomUsers){ aRandomUser in
            RandomUserRowView(aRandomUser)
        }
        .introspectTableView{ self.configureRefreshControl($0) }
//        .introspectTableView{ tableView in
//            self.configureRefreshControl(tableView)
//        }
        
    }
    
}

//MARK: - Helper Methods
extension ContentView {
    fileprivate func configureRefreshControl(_ tableView: UITableView){
        print(#fileID, #function, #line, "")
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = #colorLiteral(red: 1, green: 0.5433388929, blue: 0, alpha: 1)
        refreshControlHelper.refreshControl = myRefresh
        refreshControlHelper.parentContentView = self
        myRefresh.addTarget(refreshControlHelper, action: #selector(RefreshControlHelper.didRefresh), for: .valueChanged)
        tableView.refreshControl = myRefresh
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
