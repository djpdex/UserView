//
//  ListProtocols.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import Foundation

protocol ListViewProtocol: class {
    func showLoadingState(show: Bool)
    func displayError(error: NSError)
    func renderViewModels(viewModels: [UserViewModel])
}

protocol ListPresenterProtocol: class {
    func viewWasDisplayed()
    func userWasSelected(user: Any)
}
