//
//  DetailProtocols.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import Foundation

protocol DetailViewProtocol: class {
    func renderViewModel(viewModel: Any)
}

protocol DetailPresenterProtocol: class {
    func viewWasDisplayed()
}
