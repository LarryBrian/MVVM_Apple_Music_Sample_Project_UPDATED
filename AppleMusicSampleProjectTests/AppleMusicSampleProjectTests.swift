//
//  AppleMusicSampleProjectTests.swift
//  AppleMusicSampleProjectTests
//
//  Created by Brian King on 5/16/21.
//

import XCTest
@testable import AppleMusicSampleProject

class AppleMusicSampleProjectTests: XCTestCase {

    var viewModel: AlbumsViewModel!
    var sut: AlbumsViewController!
    
    override func setUp() {
        viewModel = .init()
        sut = AlbumsViewController()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }
    
    func testAppleMusicTopAlbumsUrlIsCorrect() {
        XCTAssertEqual(viewModel.topAlbumsURL, Constants().appleMusicTopAlbumsURL)
    }
}
