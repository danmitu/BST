//
//  BSTTests.swift
//  BSTTests
//
//  Created by Dan Mitu on 6/8/20.
//  Copyright © 2020 Dan Mitu. All rights reserved.
//

import XCTest

class BSTTests: XCTestCase {
    
    func randomIntSet(n: Int, min: Int, max: Int) -> Set<Int> {
        precondition(n < max)
        precondition(n >= 0)
        precondition(min <= max)
        return Set(Array((min...max)).shuffled().prefix(n))
    }
    
    func testTraverseInOrder() {
        let bst = BST<Int>()
        randomIntSet(n: 10, min: 0, max: 100).forEach { bst.insert($0) }
        var elements = [Int]()
        bst.traverseInOrder { elements.append($0) }
        let sortedElements = elements.sorted()
        XCTAssertEqual(sortedElements, elements)
    }

    func testTraversePreOrder() {
        let bst = BST<Int>()
        [6, 2, 1, 4, 3, 5, 7, 9, 8].forEach { bst.insert($0 )}
        let expectedValue = [6, 2, 1, 4, 3, 5, 7, 9, 8]
        var traverseOrder = [Int]()
        bst.traversePreOrder({ traverseOrder.append($0) })
        XCTAssert(expectedValue == traverseOrder)
    }
    
    func testTraversePostOrder() {
        let bst = BST<Int>()
        [6, 2, 1, 4, 3, 5, 7, 9, 8].forEach { bst.insert($0) }
        let expectedValue = [1, 3, 5, 4, 2, 8, 9, 7, 6]
        var traverseOrder = [Int]()
        bst.traversePostOrder({ traverseOrder.append($0) })
        XCTAssert(expectedValue == traverseOrder)
    }
    
    func testTraverseLevelOrder() {
        let bst = BST<Int>()
        [4, 2, 1, 3, 6, 5, 7].forEach { bst.insert($0) }
        var traverseOrder = [Int]()
        bst.traverseLevelOrder({ traverseOrder.append($0) })
        let expectedValue = [4, 2, 6, 1, 3, 5, 7]
        print(traverseOrder)
        XCTAssert(expectedValue == traverseOrder)
    }
    
    func testLeast() {
        let bst = BST<Int>()
        let input = randomIntSet(n: 10, min: 0, max: 100)
        let least = input.sorted().first
        input.forEach { bst.insert($0) }
        XCTAssertEqual(least, bst.least)
    }
    
    func testGreatest() {
        let bst = BST<Int>()
        let input = randomIntSet(n: 10, min: 0, max: 100)
        let greatest = input.sorted().last
        input.forEach { bst.insert($0) }
        XCTAssertEqual(greatest, bst.greatest)
    }

    func testContainsTrue() {
        let bst = BST<Int>()
        let input = randomIntSet(n: 1000, min: 0, max: 10000)
        input.forEach { bst.insert($0) }
        // --
        let smallest = 0
        bst.insert(smallest)
        // --
        let biggest = input.sorted().last! + 1
        bst.insert(biggest)
        // --
        let random = input.randomElement()!
        // --
        XCTAssert(bst.contains(smallest))
        XCTAssert(bst.contains(biggest))
        XCTAssert(bst.contains(random))
    }
    
    func testContainsFalse() {
        let bst = BST<Int>()
        var input = randomIntSet(n: 1000, min: 0, max: 10000)
        let testCase = Int.random(in: 0...10000)
        input.remove(testCase)
        input.forEach { bst.insert($0) }
        XCTAssertFalse(bst.contains(testCase))
    }
    
    func testCount() {
        for _ in (0..<10) {
            let bst = BST<Int>()
            let n = Int.random(in: 0...50)
            randomIntSet(n: n, min: 0, max: 100).forEach { bst.insert($0) }
            XCTAssert(bst.count == n)
        }
    }
    
    func testRemove1() {
        // Remove a leaf
        let bst = BST<Int>()
        bst.insert(2)
        bst.insert(1)
        bst.insert(3)
        bst.remove(1)
        XCTAssert(!bst.contains(1))
        XCTAssert(bst.count == 2)
        var visits = [Int]()
        bst.traverseInOrder { visits.append($0) }
        XCTAssert(visits.sorted() == visits)
    }
    
    func testRemove2() {
        // Remove only-child on the left
        let bst = BST<Int>()
        bst.insert(3)
        bst.insert(2)
        bst.insert(1)
        bst.remove(2)
        XCTAssert(!bst.contains(2))
        XCTAssert(bst.count == 2)
        var visits = [Int]()
        bst.traverseInOrder { visits.append($0) }
        XCTAssert(visits.sorted() == visits)
    }
    
    func testRemove3() {
        // Remove only-child on the right
        let bst = BST<Int>()
        bst.insert(1)
        bst.insert(2)
        bst.insert(3)
        bst.remove(2)
        XCTAssert(!bst.contains(2))
        XCTAssert(bst.count == 2)
        var visits = [Int]()
        bst.traverseInOrder { visits.append($0) }
        XCTAssert(visits.sorted() == visits)
    }
    
    func testRemove4() {
        // Remove node with two children
        let bst = BST<Int>()
        bst.insert(2)
        bst.insert(1)
        bst.insert(5)
        bst.insert(4)
        bst.insert(3)
        bst.insert(6)
        bst.remove(2)
        let expectedValues = Set([1, 3, 4, 5, 6])
        var realValues = Set<Int>()
        bst.traverseInOrder({ realValues.insert($0) })
        XCTAssert(expectedValues == realValues)
    }
    
    func testHeight1() {
        // Full Tree with 3 nodes
        let bst = BST<Int>()
        XCTAssert(bst.height == 0)
        bst.insert(2)
        XCTAssert(bst.height == 1)
        bst.insert(1)
        bst.insert(3)
        XCTAssert(bst.height == 2)
    }
    
    func testHeight2() {
        // Left subtree is greater than the right subtree
        let bst = BST<Int>()
        bst.insert(4)
        bst.insert(3)
        bst.insert(2)
        bst.insert(1)
        bst.insert(5)
        bst.insert(6)
        XCTAssert(bst.height == 4)
    }
    
}
