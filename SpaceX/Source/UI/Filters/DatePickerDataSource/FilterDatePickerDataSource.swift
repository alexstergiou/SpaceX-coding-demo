//
//  FilterDatePickerDataSource.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

protocol DatePickerDataSourceProtocol {
    func set(startTextField: UITextField)
    func set(endTextField: UITextField)
}

final class DatePickerDataSource: NSObject, DatePickerDataSourceProtocol {
    weak var item: StartEndDateItem?
    weak var filtersManager: FiltersManagerProtocol?

    let minimumDate: Date
    let maximumDate: Date

    var startPickerMaximumDate: Date
    var endPickerMinimumDate: Date

    var currentMinimumDate: Date {
        didSet {
            endPickerMinimumDate = currentMinimumDate
            item?.startDate = currentMinimumDate
            reloadAndInformForFilterChange()
        }
    }
    
    var currentMaximumDate: Date {
        didSet {
            startPickerMaximumDate = currentMaximumDate
            item?.endDate = currentMaximumDate
            reloadAndInformForFilterChange()
        }
    }

    var startText: String {
        return L.Filters.start + currentMinimumDate.yearString
    }

    var endText: String {
        return L.Filters.end + currentMaximumDate.yearString
    }

    fileprivate let startPicker: UIPickerView = UIPickerView()
    fileprivate let endPicker: UIPickerView = UIPickerView()

    weak var startTextField: UITextField?
    weak var endTextField: UITextField?

    func set(startTextField: UITextField) {
        startTextField.inputView = startPicker
        self.startTextField = startTextField
        reloadTextFields()
    }

    func set(endTextField: UITextField) {
        endTextField.inputView = endPicker
        self.endTextField = endTextField
        reloadTextFields()
    }

    init(dateItem: StartEndDateItem, filtersManager: FiltersManagerProtocol) {
        self.item = dateItem
        self.filtersManager = filtersManager
        let minimumDate: Date = dateItem.minimumDate
        let maximumDate: Date = dateItem.maximumDate

        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.startPickerMaximumDate = maximumDate
        self.endPickerMinimumDate = minimumDate
        self.currentMinimumDate = minimumDate
        self.currentMaximumDate = maximumDate

        super.init()

        startPicker.dataSource = self
        startPicker.delegate = self
        endPicker.dataSource = self
        endPicker.delegate = self

        pickerValuesInitialSetup()
    }
}

extension DatePickerDataSource: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.startPicker {
            return startPickerRowCount
        } else {
            return endPickerRowCount
        }
    }
}

extension DatePickerDataSource: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.startPicker {
            return "\(startYear(for: row))"
        } else {
            return "\(endYear(for: row))"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.startPicker {
            currentMinimumDate = Date.with(year: startYear(for: row))
        } else {
            currentMaximumDate = Date.with(year: endYear(for: row))
        }
    }
}

extension DatePickerDataSource {
    func pickerValuesInitialSetup() {
        pickerView(startPicker, didSelectRow: startRow, inComponent: 0)
        startPicker.selectRow(startRow, inComponent: 0, animated: false)
        pickerView(endPicker, didSelectRow: endRow, inComponent: 0)
        endPicker.selectRow(endRow, inComponent: 0, animated: false)
    }

    func reloadTextFields() {
        startTextField?.text = startText
        endTextField?.text = endText
    }

    func reloadAndInformForFilterChange() {
        reloadTextFields()
        filtersManager?.filtersUpdated()
    }

    var startPickerRowCount: Int {
        return minimumDate.rangeOfYears(for: currentMaximumDate) + 1
    }

    var startRow: Int {
        guard let item = item else { return 0 }
        return item.startDate.year - minimumDate.year
    }

    var endPickerRowCount: Int {
        return currentMinimumDate.rangeOfYears(for: maximumDate) + 1
    }

    var endRow: Int {
        guard let item = item else { return endPickerRowCount - 1 }
        return endPickerRowCount - (maximumDate.year - item.endDate.year) - 1
    }

    func startYear(for row: Int) -> Int {
        return minimumDate.year + row
    }

    func endYear(for row: Int) -> Int {
        return endPickerMinimumDate.year + row
    }
}
