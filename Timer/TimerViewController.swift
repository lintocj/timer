//
//  TimerViewController.swift
//  Timer
//
//  Created by linto jacob on 12/08/22.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startResumeButton: UIButton!
    @IBOutlet weak var resetStopButton: UIButton!

    var timerCounting:Bool = false
    var startTime:Date?
    var stopTime:Date?

    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"

    var scheduledTimer: Timer!

    var isResetStopButtonHidden: Bool = false {
        didSet {
            resetStopButton?.isHidden = isResetStopButtonHidden
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        isResetStopButtonHidden = true

        if timerCounting {
            isResetStopButtonHidden = false
            startTimer()
        } else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                    isResetStopButtonHidden = false
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }

    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startResumeButton.setTitle("PAUSE", for: .normal)
    }

    @objc func refreshValue() {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        } else {
            stopTimer()
            setTimeLabel(0)
        }
    }

    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeString
    }

    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }

    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }

    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
    }

    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }

    /// It will retrun the time difference start date and with stop date when it goes background/ Suspand state
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }

    /// Storing the stop time to Resume the timer
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }

    ///Set the current status of timer
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }

    // MARK: Button Action
    @IBAction func startResumeAction(_ sender: Any) {
        if timerCounting {
            setStopTime(date: Date())
            startResumeButton.setTitle("RESUME", for: .normal)
            stopTimer()
        }
        else {
            if let stop = stopTime {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            } else {
                isResetStopButtonHidden = false
                setStartTime(date: Date())
            }
            startTimer()
        }
    }

    @IBAction func resetStopAction(_ sender: Any) {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timeLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        startResumeButton.setTitle("START", for: .normal)
        isResetStopButtonHidden = true
        stopTimer()
    }

}

