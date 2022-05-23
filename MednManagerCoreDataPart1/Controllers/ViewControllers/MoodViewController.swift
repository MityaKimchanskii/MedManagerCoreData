//
//  MoodViewController.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/20/22.
//

import UIKit

protocol MoodViewControllerDelegate: AnyObject {
    func moodButtonTapped(with emoji: String)
}

class MoodViewController: UIViewController {
    
    // MARK: - Properties
    var delegate: MoodViewControllerDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reminderFired),
                                               name: NSNotification.Name(rawValue: "medicationReminderReceived"),
                                               object: nil)
    }
    
    // MARK: - Actions
    @IBAction func moodButtonTapped(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text else { return }
        delegate?.moodButtonTapped(with: emoji)
        dismiss(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    @objc private func reminderFired() {
        print("\(#file) received the MEMO!")
        
    }
}
