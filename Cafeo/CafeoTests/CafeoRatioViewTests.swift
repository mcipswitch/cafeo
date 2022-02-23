////
////  CafeoRatioViewTests.swift
////  CafeoTests
////
////  Created by Priscilla Ip on 2021-03-17.
////
//
//import ComposableArchitecture
//import SnapshotTesting
//import XCTest
//@testable import Cafeo
//
//class CafeoRatioViewTests: XCTestCase {
//    let scheduler = DispatchQueue.testScheduler
//
//    func testActiveRatioIdxChanged() throws {
//        // Setup
//        let waterAmount: Double = 250
//
//        let store = TestStore(
//            initialState: AppState(
//                coffeeAmount: waterAmount / 16,
//                waterAmount: waterAmount,
//                coffeeAmountIsLocked: false,
//                waterAmountIsLocked: true,
//                ratioCarouselActiveIdx: 0,
//                ratioDenominators: [14, 15, 16, 17]
//            ),
//            reducer: appReducer,
//            environment: AppEnvironment(
//                mainQueue: .failing
//            )
//        )
//
//        // Test + Validate
//        store.send(.form(.set(\.ratioCarouselActiveIdx, 1))) {
//            $0.ratioCarouselActiveIdx = 1
//            $0.coffeeAmount = waterAmount * $0.ratio
//            XCTAssertEqual($0.activeRatioDenominator, 15)
//        }
//
//        store.send(.form(.set(\.ratioCarouselActiveIdx, 2))) {
//            $0.ratioCarouselActiveIdx = 2
//            $0.coffeeAmount = waterAmount * $0.ratio
//            XCTAssertEqual($0.activeRatioDenominator, 16)
//        }
//
//        store.send(.form(.set(\.ratioCarouselActiveIdx, 3))) {
//            $0.ratioCarouselActiveIdx = 3
//            $0.coffeeAmount = waterAmount * $0.ratio
//            XCTAssertEqual($0.activeRatioDenominator, 17)
//        }
//    }
//}
