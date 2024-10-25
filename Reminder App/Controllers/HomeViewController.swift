//
//  HomeViewController.swift
//  Reminder App
//
//  Created by Habibur Rahman on 10/25/24.
//

import UIKit

struct Reminder {
    let name: String
    let description: String
    let date: String
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddReminderDelegate {

    var reminders = [Reminder]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(goToAddReminder)
        )
    }
    

    
    func addReminder(name: String, description: String, date: String) {
        reminders.append(Reminder(name: name, description: description, date: date))
        self.tableView.reloadData()
    }
    
    @objc func goToAddReminder() {
        if let vc = storyboard?.instantiateViewController(identifier: "AddReminderVC") as? AddReminderViewController {
            vc.addReminderDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        cell.textLabel?.text = reminders[indexPath.row].name
        cell.detailTextLabel?.text = "At \(reminders[indexPath.row].date)"
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
