//
//  LunarSunConverterTests.swift
//  LunarSunConverterTests
//
//  Created by SwiftMan on 2022/12/04.
//

import XCTest
@testable import LunarSunConverter

class LunarSunConverterTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testConvertSunToLunar() throws {
    var date = Date()
    date.year = 2022
    date.month = 12
    date.day = 26
    
    var lunar = Date()
    lunar.year = 2022
    lunar.month = 12
    lunar.day = 4
    
    let c = KoreanLunarConverter()
    c.solarDate(solarYear: 2022, solarMonth: 12, solarDay: 26)
    
    print("UnicodeScalar : \u{ac11}")
    
    print(c.lunarIsoFormat)
    print(c.gapJaString)
    
    let c2 = KoreanLunarConverter()
    c2.lunarDate(lunarYear: 1956, lunarMonth: 1, lunarDay: 21, isIntercalation: false)
    
    print(c2.solarIsoFormat)
    print(c2.gapJaString)
    print(c2.chineseGapJaString)
    
    
//    let sun = LunarSunConverter().lunar(fromSun: date)
//    print(sun)
//    XCTAssertTrue(lunar === sun)
//
//    let objc = SunLunar().convertSun(toLunar: TimeSL(day: 26, month: 12, year: 2022),
//                                     timeZone: Int32(numberOfLocalTimeZone))
//
//    print(objc)
//    XCTAssertTrue(sun.year == objc.year)
//    XCTAssertTrue(sun.month == objc.month)
//    XCTAssertTrue(sun.day == objc.day)
  }
  
//  func testConvertSunToLunar2() throws {
//    var date = Date()
//    date.year = 2022
//    date.month = 2
//    date.day = 4
//
//    var lunar = Date()
//    lunar.year = 2022
//    lunar.month = 1
//    lunar.day = 4
//
//    let sun = LunarSunConverter().lunar(fromSun: date)
//    print(sun)
//    XCTAssertTrue(lunar === sun)
//
//    let objc = SunLunar().convertSun(toLunar: TimeSL(day: 4, month: 2, year: 2022),
//                                     timeZone: Int32(numberOfLocalTimeZone))
//
//    print(objc)
//    XCTAssertTrue(sun.year == objc.year)
//    XCTAssertTrue(sun.month == objc.month)
//    XCTAssertTrue(sun.day == objc.day)
//  }
//
//  private var numberOfLocalTimeZone: Int {
//    let date = Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = .current
//    dateFormatter.dateFormat = "Z"
//
//    let string = dateFormatter.string(from: date).replacingOccurrences(of: "0", with: "")
//    let tz = Int(string)
//    return tz ?? 0
//  }
}

extension Date {
  fileprivate static func === (lhs: Self, rhs: Self) -> Bool {
    return lhs.year == rhs.year &&
    lhs.month == rhs.month &&
    lhs.day == rhs.day
  }
  
  
  fileprivate var calendar: Calendar { Calendar.current }
  
  fileprivate var year: Int {
    get {
      return calendar.component(.year, from: self)
    }
    set {
      guard newValue > 0 else { return }
      let currentYear = calendar.component(.year, from: self)
      let yearsToAdd = newValue - currentYear
      if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
        self = date
      }
    }
  }
  
  /// SwifterSwift: Month.
  ///
  ///   Date().month -> 1
  ///
  ///   var someDate = Date()
  ///   someDate.month = 10 // sets someDate's month to 10.
  ///
  fileprivate var month: Int {
    get {
      return calendar.component(.month, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .month, in: .year, for: self)!
      guard allowedRange.contains(newValue) else { return }
      
      let currentMonth = calendar.component(.month, from: self)
      let monthsToAdd = newValue - currentMonth
      if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
        self = date
      }
    }
  }
  
  /// SwifterSwift: Day.
  ///
  ///   Date().day -> 12
  ///
  ///   var someDate = Date()
  ///   someDate.day = 1 // sets someDate's day of month to 1.
  ///
  fileprivate var day: Int {
    get {
      return calendar.component(.day, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .day, in: .month, for: self)!
      guard allowedRange.contains(newValue) else { return }
      
      let currentDay = calendar.component(.day, from: self)
      let daysToAdd = newValue - currentDay
      if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
        self = date
      }
    }
  }
}
