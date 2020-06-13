//
//  BST.swift
//  Swift-BST
//
//  Created by Dan Mitu on 6/8/20.
//  Copyright © 2020 Dan Mitu. All rights reserved.
//

import Foundation

class Node<T: Comparable> {
    init(data: T) { self.data = data }
    var data: T
    var left: Node<T>?
    var right: Node<T>?
}

class BST<T: Comparable> {
    
    private var root: Node<T>?
    
    // MARK: - Traverse In Order
    
    func traverseInOrder(_ onVisit: (T)->Void) {
        traverseInOrder(root, onVisit)
    }
    
    private func traverseInOrder(_ node: Node<T>?, _ onVisit: (T)->Void) {
        guard let node = node else { return }
        traverseInOrder(node.left, onVisit)
        onVisit(node.data)
        traverseInOrder(node.right, onVisit)
    }
    
    // MARK: - Trsverse Pre-Order
    
    func traversePreOrder(_ onVisit: (T)->Void) {
        traversePreOrder(root, onVisit)
    }
    
    private func traversePreOrder(_ node: Node<T>?, _ onVisit: (T)->Void) {
        guard let node = node else { return }
        onVisit(node.data)
        traversePreOrder(node.left, onVisit)
        traversePreOrder(node.right, onVisit)
    }
    
    // MARK: - Traverse Post-Order
    
    func traversePostOrder(_ onVisit: (T)->Void) {
        traversePostOrder(root, onVisit)
    }
    
    private func traversePostOrder(_ node: Node<T>?, _ onVisit: (T)->Void) {
        guard let node = node else { return }
        traversePostOrder(node.left, onVisit)
        traversePostOrder(node.right, onVisit)
        onVisit(node.data)
    }
    
    // MARK: - Traverse Level-Order
    
    func traverseLevelOrder(_ onVisit: (T)->Void) {
        var level = 1
        while traverseLevelOrder(root, level, onVisit) { level += 1 }
    }
    
    private func traverseLevelOrder(_ node: Node<T>?, _ level: Int, _ onVisit: (T)->Void) -> Bool {
        guard let node = node else { return false }
        guard level != 1 else { onVisit(node.data); return true }
        let left = traverseLevelOrder(node.left, level - 1, onVisit)
        let right = traverseLevelOrder(node.right, level - 1, onVisit)
        return left || right
    }
        
    // MARK: - Least and Greatest

    var least: T! { leastValue(root) }
    
    private func leastValue(_ root: Node<T>?) -> T? {
        guard let root = root else { return nil }
        var current = root
        while current.left != nil {
            current = current.left!
        }
        return current.data
    }
    
    var greatest: T! {
        guard let root = root else { return nil }
        var current = root
        while current.right != nil {
            current = current.right!
        }
        return current.data

    }
    
    // MARK: - Height
    
    var height: Int { height(root) }
    
    private func height(_ node: Node<T>?) -> Int {
        guard let node = node else { return 0 }
        
        return Swift.max(height(node.left), height(node.right)) + 1
    }
    
    // MARK: - Insert
    
    func insert(_ element: T) {
        if let root = root {
            insert(element, root)
        } else {
            root = Node(data: element)
        }
    }
    
    private func insert(_ element: T, _ node: Node<T>) {
        guard element != node.data else { return }
         if node.data > element {
            if let left = node.left {
                insert(element, left)
            } else {
                node.left = Node(data: element)
            }
        } else {
            if let right = node.right {
                insert(element, right)
            } else {
                node.right = Node(data: element)
            }
        }
    }
    
    // MARK: - Contains
    
    func contains(_ element: T) -> Bool {
        return find(element, root) != nil
    }
    
    private func find(_ element: T, _ node: Node<T>?) -> Node<T>? {
        guard let node = node else { return nil }
        if node.data == element { return node }
        if node.data > element {
            return find(element, node.left)
        } else {
            return find(element, node.right)
        }

    }
    
    // MARK: - Count
    
    var count: Int { count(root) }
    
    private func count(_ node: Node<T>?) -> Int {
        guard let node = node else { return 0 }
        return count(node.left) + count(node.right) + 1
    }
    
    // MARK: - Remove
    
    func remove(_ element: T) {
        root = remove(element, root)
    }
    
    func remove(_ element: T, _ node: Node<T>?) -> Node<T>? {
        /**
         Cases
         Case 1: Deleting a node with no children.
         Case 2: Deleting a node with one child.
         Case 3: Deleting a node with two children.
         */
        guard node != nil else { return nil }
        if element < node!.data {
            node!.left = remove(element, node!.left)
        } else if element > node!.data {
            node!.right = remove(element, node!.right)
        } else { // Found
            // Case 1 & 2: If one side is nil, replace it with the other side (2). If both sides are nil, then we just replaced with nil (1).
            if node?.left == nil {
                return node?.right
            } else if node?.right == nil {
                return node?.left
            } else { // Case 3: Two Children
                node!.data = leastValue(node!.right)!
                node!.right = remove(node!.data, node?.right)
            }
        }
        return node
    }
    
        
}
