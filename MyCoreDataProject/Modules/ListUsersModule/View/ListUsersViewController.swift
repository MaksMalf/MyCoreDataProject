//
//  ListUsersViewController.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import UIKit

class ListUsersViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBAction func pressButton(_ sender: Any) {
        let name = self.textField.text ?? ""
        self.presentor.saveData(name)
        self.updateTableView()
    }
    @IBOutlet weak var tableView: UITableView!

    var presentor: ListUsersViewPresenterProtocol!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ListUsersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presentor.users?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = self.presentor.users?.count == 0 ? "" : self.presentor.users?[indexPath.row].name

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let user = presentor.users?[indexPath.row] else { return }
        if editingStyle == .delete {
            tableView.beginUpdates()
            presentor.deleteUser(user)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presentor.users?[indexPath.row]
        presentor.tapOnTheUser(user: user)
    }
}

extension ListUsersViewController: ListUsersViewProtocol {

    func updateTableView() {
        self.presentor.getAllUsers()
        self.tableView.reloadData()
    }
}

