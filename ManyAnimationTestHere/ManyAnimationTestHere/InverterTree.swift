//
//  InverterTree.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/5/9.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

class InverterTree: NSObject {

}



public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

public class ListNode
{
    public var val: Int
    public var next: ListNode?
    
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {
    
    
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        
        var nums = [Int]()
        var i = 0 , j = 0;
        
        while i < nums1.count && j < nums2.count {
            if nums1[i] < nums2[j] {
                nums.append(nums1[i])
                i += 1
            }
            else {
                nums.append(nums2[j])
                j += 1
            }
        }
        
        if i == nums1.count {
             nums = nums + nums2[j..<nums2.count]
        }
        else {
            nums = nums + nums1[i..<nums1.count]
        }
        
        
        let median: Double = nums.count % 2 == 1 ? Double(nums[nums.count / 2]) : (Double(nums[nums.count / 2 - 1]) + Double(nums[nums.count / 2])) / 2
        
        print(median)

        return median
    }
    
    func lengthOfLongestSubstring(_ s: String) -> Int {
        
        let chars         = Array(s.characters)
        var subString     = [Character]()
        var longestLength = 0

        for char in chars {
            if subString.contains(char) {
                subString.append(char)
                subString.removeFirst(subString.index(of: char)! + 1)
            }
            else {
                subString.append(char)
            }
            
            if subString.count > longestLength {
                longestLength = subString.count
                //print(longestLength)
            }
        }
        
        //print(longestLength)
        return longestLength
    }
    
    
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        ///*
        guard l1 != nil, l2 != nil else {
            fatalError("missing nodes.")
        }
        
        var list1 = l1
        var list2 = l2
        
        var sumNodes = [ListNode]()
        var leftValue = 0
        
        while let n1 = list1, let n2 = list2
        {
            let sum  = n1.val + n2.val + leftValue
            let next = ListNode(sum % 10)
            
            if let current = sumNodes.last {
                current.next = next
            }

            sumNodes.append(next)
            leftValue = sum / 10
        
            list1 = n1.next
            list2 = n2.next
        }
        
        var validList = list1 ?? list2
        
        while let n1 = validList {
            let sum  = n1.val + leftValue
            let next = ListNode(sum % 10)
            
            if let current = sumNodes.last {
                current.next = next
            }
            
            sumNodes.append(next)
            leftValue = sum / 10
            
            validList = n1.next
        }
        
        if leftValue > 0 {
            let next = ListNode(leftValue)
            
            if let current = sumNodes.last {
                current.next = next
            }
            
            sumNodes.append(next)
        }
        
        return sumNodes[0]
        
        
        // */
        /*
        guard let list1 = l1, let list2 = l2 else {
            fatalError("missing nodes")
        }
        
        var val1 = [list1.val]
        var val2 = [list2.val]
        
        var temp1 = list1
        var temp2 = list2
        
        while let l1Next = temp1.next {
            val1.append(l1Next.val)
            temp1 = l1Next
        }
        
        while let l2Next = temp2.next {
            val2.append(l2Next.val)
            temp2 = l2Next
        }
        
        //val1 = [2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,9]
        //val2 = [5,6,4,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,9,9,9,9]
        
        //val1 = [1,8]
        //val2 = [0]

        //val1 = [3,4,2]
        //val2 = [5,6,4]
        
        val1 = [1]
        val2 = [9,9]
        
        val1 = Array(val1.reversed())
        val2 = Array(val2.reversed())
        
        print(val1)
        print(val2)
        
        val1.count != val2.count && val1.count < val2.count ?
            val1.insert(contentsOf: Array(repeating: 0, count: val2.count - val1.count), at: 0) : val2.insert(contentsOf: Array(repeating: 0, count: val1.count - val2.count), at: 0)
        print(val1)
        print(val2)
        
        var result = [0]
        for i in 0..<val1.count
        {
            let sum = val1[i] + val2[i]
            if sum >= 10 {
                result[i] += 1
                result.append( sum % 10 )
            }
            else {
                result.append(sum)
            }
        }
        
        print(result)
        
        for i in (0..<result.count).reversed() {
            
            if result[i] > 9 {
                
                result[i] = result[i] % 10
                
                if i == 0 {
                    result.insert(1, at: 0)
                }
                else {
                    result[i-1] += 1
                }
            }
        }
        
        result = Array(result.reversed())
        
        if result.last == 0 {
            result.removeLast()
        }
    
        var resultNodes = [ListNode]()
        
        for i in 0..<result.count {
            resultNodes.append(ListNode(result[i]))
            if i > 0 {
                resultNodes[i-1].next = resultNodes[i]
            }
        }
        
        for node in resultNodes {
            print(node.val)
        }
        
        return resultNodes[0]
    // */
    }
    
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard let node = root else {
            return root
        }
        
        let left = invertTree(node.left)
        let right = invertTree(node.right)
        
        node.left = right
        node.right = left
        
        return node
    }
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        var result = [Int]()
        var hashMap = [Int: Int]()
        
        for i in 0...nums.count-1 {
            
            let augend = target - nums[i]
            if let index = hashMap[augend] {
                result.append(index)
                result.append(i)
                return result
            }
            else {
                hashMap[nums[i]] = i
            }
        }
        
        fatalError("Number not found!")
    }
    
    /*
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        if nums.count == 2 {
            return [0, 1]
        }
        
        var addends = nums
        var indexs = [Int]()
        
        for index in 0 ..< nums.count
        {
            let augend = nums[index]
            let addend = target - augend
            addends.removeFirst()
            
            if addends.contains(addend)
            {
                indexs.append(contentsOf: [index, addends.index(of: addend)! + index + 1])
                break
            }
        }
        
        return indexs
    }
    // */
}
