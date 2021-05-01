//
//  DatePickerDataSourceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class MockStartEndDateItem: StartEndDateItem {
    var title: String = "Title"

    var minimumDate: Date

    var maximumDate: Date

    var startDate: Date

    var endDate: Date

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        self.minimumDate = startDate
        self.maximumDate = endDate
    }
}

final class DatePickerDataSourceTests: XCTestCase {

    var start: Date!
    var end: Date!
    var filterManager: MockFiltersManager!
    var item: MockStartEndDateItem!
    var subject: DatePickerDataSource!

    override func setUpWithError() throws {
        start = Date(timeIntervalSince1970: 3600)
        end = start.byAdding(years: 10)

        item = MockStartEndDateItem(startDate: start, endDate: end)
        filterManager = MockFiltersManager()
        subject = DatePickerDataSource(dateItem: item, filtersManager: filterManager)
    }

    override func tearDownWithError() throws {
        start = nil
        end = nil
        subject = nil
        item = nil
        filterManager = nil
    }

    func testInit() {
        XCTAssertNotNil(subject.item)
        XCTAssertNotNil(subject.filtersManager)

        XCTAssertNotNil(subject.startPicker.dataSource)
        XCTAssertNotNil(subject.startPicker.delegate)

        XCTAssertNotNil(subject.endPicker.dataSource)
        XCTAssertNotNil(subject.endPicker.delegate)

        XCTAssertEqual(subject.minimumDate, start)
        XCTAssertEqual(subject.maximumDate, end)

        XCTAssertEqual(subject.startPicker.selectedRow(inComponent: 0), 0)
        XCTAssertEqual(subject.endPicker.selectedRow(inComponent: 0), 10)
    }

    func testPickerDataSourceDelegate() {
        XCTAssertEqual(subject.numberOfComponents(in: subject.startPicker), 1)
        XCTAssertEqual(subject.numberOfComponents(in: subject.endPicker), 1)
        XCTAssertEqual(subject.pickerView(subject.startPicker, numberOfRowsInComponent: 0), 10)
        XCTAssertEqual(subject.pickerView(subject.endPicker, numberOfRowsInComponent: 0), 11)

        XCTAssertEqual(subject.pickerView(subject.startPicker, titleForRow: 0, forComponent: 0), "1970")
        XCTAssertEqual(subject.pickerView(subject.endPicker, titleForRow: 0, forComponent: 0), "1970")

        subject.pickerView(subject.startPicker, didSelectRow: 2, inComponent: 0)
        XCTAssertEqual(subject.currentMinimumDate.year, 1972)

        subject.pickerView(subject.endPicker, didSelectRow: 2, inComponent: 0)
        XCTAssertEqual(subject.currentMaximumDate.year, 1974)


    }

    func testReloadAndFilterChange() {
        let startField: UITextField = UITextField()
        let endField: UITextField = UITextField()
        subject.set(startTextField: startField)
        subject.set(endTextField: endField)
        subject.reloadAndInformForFilterChange()
        XCTAssertEqual(subject.startTextField?.text, "Start: 1970")
        XCTAssertEqual(subject.endTextField?.text, "End: 1980")
        XCTAssertTrue(filterManager.filtersUpdatedCalled)
    }
}
