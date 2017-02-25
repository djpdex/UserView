//
//  UserDetailViewController.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    var viewModel: UserViewModel?
    
    // MARK:- Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let viewModel = viewModel {
            self.nameLabel.text = viewModel.name
            self.genderLabel.text = viewModel.gender
            self.dobLabel.text = viewModel.dob
            viewModel.userImage(completion: {[weak self] (image) in
                self?.userImageView.image = image
            })
        }
    }
}

extension DetailViewProtocol {
    func renderViewModel(viewModel: Any) {
        // TODO: Unused for now as using segue for time
    }
}
