//
//  MedicationTableViewCell.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/16/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool)
}

class MedicationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: MedicationTableViewCellDelegate?
    private var medication: Medication?
    private var wasTakenToday: Bool = false

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeOfDayLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!
    
    // MARK: - Actions
    @IBAction func wasTakenButtonTapped(_ sender: Any) {
        guard let medication = medication else { return }
        
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday)
    }
    
    // MARK: - Helper Methods
    func configure(with medication: Medication) {
        self.medication = medication
        wasTakenToday = medication.wasTakenToday()
        
        nameLabel.text = medication.name
        timeOfDayLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
    }
}
