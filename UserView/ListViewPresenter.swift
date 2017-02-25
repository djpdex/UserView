//
//  ListViewPresenter.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import Foundation

class ListViewPresenter {

    let userPageSize = 20
    var users: [User] = []
    
    // MARK:- Properties
    weak var view: ListViewProtocol?
    let getUserInteractor: GetRemoteUserInteractor
    
    // MARK:- Init
    init(view: ListViewProtocol,
         getUserInteractor: GetRemoteUserInteractor = GetRemoteUserInteractor()) {
        self.view = view
        self.getUserInteractor = getUserInteractor
    }
}

extension ListViewPresenter: ListPresenterProtocol {
    
    func viewWasDisplayed() {
        getUsers()
    }
    
    func userWasSelected(user: Any) {
        // TODO: Using segue for now as didn't have time
    }
    
    private func getUsers() {
        
        // View to indicate async activity
        self.view?.showLoadingState(show: true)
        
        getUserInteractor.getRemoteUsers(numberOfUsers: userPageSize) {[weak self] result in
            
            guard let `self` = self else {return}
            
            self.view?.showLoadingState(show: false)
            
            switch result {
            case .success(let users):
                let viewModels = self.generateViewModels(users: users)
                
                if viewModels.count == 0 {
                    self.view?.displayError(error: self.noUsersError())
                } else {
                    self.view?.renderViewModels(viewModels: viewModels)
                }
            case .failure(let error):
                self.view?.displayError(error: error)
            }
        }
    }
    
    private func generateViewModels(users: [User]) -> [UserViewModel] {
        return users.map{UserViewModel(user:$0)}
    }
    
    private func noUsersError() -> NSError {
        return NSError(domain: "ListPresenter",
                       code: 0,
                       userInfo: [NSLocalizedDescriptionKey:"No users found"])
    }
}
