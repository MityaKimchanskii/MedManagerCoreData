//
//  ViewController.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/16/22.
//

import UIKit

class MedicationListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moodButton: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MedicationController.shared.fetchMedication()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired),
                                               name: NSNotification.Name(rawValue: "medicationReminderReceived"),
                                               object: nil)
        
        guard let mood = MoodController.shared.fetchMood() else { return }
        
        moodButton.setTitle(mood.mentalState, for: .normal)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func surveyButtonTapped(_ sender: Any) {
        guard let moodViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "moodViewController") as? MoodViewController else { return }
        
        moodViewController.delegate = self
        navigationController?.present(moodViewController, animated: true)
        
    }
    
    // MARK: - Helper Methods
    @objc private func reminderFired() {
        print("\(#file) received the MEMO!")
        tableView.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tableView.backgroundColor = .systemBackground
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailMedication",
           let indexPath = tableView.indexPathForSelectedRow,
           let destinationVC = segue.destination as? MedicationDetailViewController {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            destinationVC.medication = medication
        }
    }
}

// MARK: - Extensions
extension MedicationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            MedicationController.shared.deleteMedication(medication)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension MedicationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MedicationController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell() }
        
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        cell.configure(with: medication)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Not Taken"
        } else if section == 1 {
            return "Taken"
        } else {
            return nil
        }
    }
}

extension MedicationListViewController: MedicationTableViewCellDelegate {
    
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool) {
        MedicationController.shared.markMedicationTaken(medication: medication, wasTaken: wasTaken)
        tableView.reloadData()
    }
}

extension MedicationListViewController: MoodViewControllerDelegate {
    func moodButtonTapped(with emoji: String) {
        MoodController.shared.didTapMoodEmoji(emoji)
        moodButton.setTitle(emoji, for: .normal)
    }
}

