//
//  ListTableViewController.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    private let kDetailSegue = "DetailSegue"
    private let kCellIdentifier = "UserCell"
    fileprivate var viewModels: [UserViewModel] = []
    private lazy var presenter: ListPresenterProtocol = {
        let presenter = ListViewPresenter(view: self)
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewWasDisplayed()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        self.performSegue(withIdentifier: kDetailSegue, sender: viewModel)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        let viewModel = viewModels[indexPath.row]
        
        // Configure the cell
        cell.textLabel?.text = viewModel.name
        
        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let viewModel = sender as? UserViewModel,
            let detailsViewController = segue.destination as? UserDetailViewController else {
                return
        }
        
        detailsViewController.viewModel = viewModel
    }
}

extension ListTableViewController: ListViewProtocol {
    func showLoadingState(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    func displayError(error: NSError) {
        displayAlertViewFor(error: error)
    }
    
    func renderViewModels(viewModels: [UserViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}

