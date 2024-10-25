//
//  ViewController.swift
//  Reminder App
//
//  Created by Habibur Rahman on 10/25/24.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        navigationItem.title = "Reminder App"
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) {(permissionGranted, error) in
            if permissionGranted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    // MARK: Button Tapped
    @IBAction func addButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            let title = self.nameTextField.text!
            let message = self.descriptionTextField.text!
            let date = self.datePicker.date
            notificationCenter.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = .default
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error:" + error.debugDescription)
                            return
                        }
                    }
                    print("Reminder added successfully")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Reminder added", message: "Your reminder has been added successfully.", preferredStyle: .alert)
                        let action = UIAlertAction(
                            title: "OK",
                            style: .default) { _ in
                                self.nameTextField.text = ""
                                self.descriptionTextField.text = ""
                                self.nameTextField.resignFirstResponder()
                                self.descriptionTextField.resignFirstResponder()
                            }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    print("Reminder not added")
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Enaable notifications?", message: "To use this feature you must enable notifications in your device settings.", preferredStyle: .alert)
                        let config = UIAlertAction(
                            title: "Settings",
                            style: .default) { _ in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                        alert.addAction(config)
                        let action = UIAlertAction(
                            title: "Cancel",
                            style: .cancel
                        )
                        alert.addAction(action)
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            }
        }
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    // MARK: Show Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

