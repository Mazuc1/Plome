//
//  TaskLoaderManagerTests.swift
//  TaskLoaderManagerTests
//
//  Created by Loic Mazuc on 28/12/2022.
//

@testable import Gateway
import XCTest

@MainActor
final class TaskLoaderManagerTests: XCTestCase {
    private var taskLoaderManager: TaskLoaderManager!
    
    override func setUp() {
        super.setUp()
        taskLoaderManager = TaskLoaderManager.shared
    }
    
    func testWhenAddsTaskThenActivityIndicatorIsAnimated() {
        // Act
        taskLoaderManager.addTask()
        
        // Assert
        XCTAssertTrue(taskLoaderManager.taskLoaderView.activityIndicator.isAnimating)
    }
    
    func testWhenStopsTaskThenActivityIndicatorIsNotAnimated() {
        // Arrange
        /// We add task to change the animation status to true before remove task and then stop the animation
        taskLoaderManager.addTask()
        
        // Act
        taskLoaderManager.endTask()
        
        // Assert
        XCTAssertFalse(taskLoaderManager.taskLoaderView.activityIndicator.isAnimating)
    }
}
