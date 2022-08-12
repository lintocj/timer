//
//  TimerViewControllerTests.swift
//  TimerTests
//
//  Created by linto jacob on 12/08/22.
//

import XCTest
@testable import Timer

class TimerViewControllerTests: XCTestCase {
    var timerVC: TimerViewController!

    func test_UIData() throws {
        XCTAssertNotNil(timerVC, "TimerViewController is nil")
        XCTAssertNotNil(timerVC.startResumeButton, "startResumeButton is nil")
        XCTAssertNotNil(timerVC.resetStopButton, "resetStopButton is nil")
        XCTAssertNotNil(timerVC.timeLabel, "timeLabel is nil")
        XCTAssertEqual(timerVC.timeLabel.text, "00:00:00")
    }

    func test_startResumeButtonAction() throws {
        let startResumeButtonAction = buttonActions(button: timerVC.startResumeButton)
        XCTAssertNotNil(startResumeButtonAction)
        guard let startResumeButtonAction = startResumeButtonAction else {
            return
        }
        let isActionValidForStart = startResumeButtonAction.contains("startResumeAction:")
        XCTAssert(isActionValidForStart)
        timerVC.startResumeButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(timerVC.startResumeButton.titleLabel?.text, "PAUSE")
        XCTAssertEqual(timerVC.isResetStopButtonHidden, false)
        XCTAssertEqual(timerVC.startResumeButton.isHidden, false)
    }
    
    func test_resetStopAction() throws {
        let resetStopButtonAction = buttonActions(button: timerVC.resetStopButton)
        XCTAssertNotNil(resetStopButtonAction)
        guard let resetStopButtonAction = resetStopButtonAction else {
            return
        }
        let isActionValidForStop = resetStopButtonAction.contains("resetStopAction:")
        XCTAssert(isActionValidForStop)
        timerVC.resetStopButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(timerVC.resetStopButton.titleLabel?.text, "STOP/RESET")
        XCTAssertEqual(timerVC.isResetStopButtonHidden, true)
        XCTAssertEqual(timerVC.resetStopButton.isHidden, true)
        XCTAssertEqual(timerVC.timeLabel.text, "00:00:00")
    }

    func buttonActions(button: UIButton?) -> [String]? {
        return button?.actions(forTarget: timerVC, forControlEvent: .touchUpInside)
    }

    override func setUpWithError() throws {
        /// Create an instance of UIStoryboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        /// Instantiate UIViewController with Storyboard ID
        timerVC = storyboard.instantiateViewController(withIdentifier: "TimerViewController") as? TimerViewController
        /// Make the viewDidLoad() execute.
        timerVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        timerVC = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
