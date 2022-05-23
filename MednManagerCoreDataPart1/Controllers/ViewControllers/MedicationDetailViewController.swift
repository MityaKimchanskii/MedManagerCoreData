//
//  MedicationDetailViewController.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/16/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {
    
    // MARK: - Properties
    var medication: Medication?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired),
                                               name: NSNotification.Name(rawValue: "medicationReminderReceived"),
                                               object: nil)
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let timeOfDay = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: timeOfDay)
        } else {
            MedicationController.shared.createMedication(name: name, timeOfDay: timeOfDay)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        if let medication = medication {
            title = "Detail Medication"
            nameTextField.text = medication.name
            datePicker.date = medication.timeOfDay ?? Date()
        } else {
            title = "Add New Medication"
        }
    }
    
    @objc private func reminderFired() {
        print("\(#file) received the MEMO!")
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .white
        }
    }
}
