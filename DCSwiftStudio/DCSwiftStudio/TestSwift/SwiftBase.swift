//
//  SwiftBase.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2020/10/29.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit



class SwiftBase: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SwiftBase"
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
//        if #available(iOS 13.0, *) {
//            print(UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//        }
//        if #available(iOS 11.0, *) {
//            print(UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero)
//
//        }
//        print(UIApplication.shared.statusBarFrame)
//        print(self.navigationController?.navigationBar.frame ?? CGRect.zero)
        
//        self.TestBase()
        
        self.testSet();
    }
    
    
    func testSet() {
        
        var firIntArr = Array<Int>()
        var secIntArr = [Int]()
        firIntArr.append(123)
        secIntArr.append(456)
        print("firIntArr:\(firIntArr), \nsecIntArr:\(secIntArr)")
        
        let fArray = Array.init(repeating: "Hello", count: 3)
        let sArray = Array.init(repeating: "Nice", count: 2)
        let tArray = fArray + sArray;
        print(tArray)
        
        
        var literalArray = ["sd", "df", "fg"]
        literalArray.append("hj")
        
        var lArray : [Int] = [6, 7]
        
        if !lArray.isEmpty {
            lArray.append(contentsOf: [8, 9, 10])
            lArray += firIntArr;
            lArray += secIntArr;
            print(lArray)
        }
        
        //let constArr = Array<Int>()
        var mutArr = Array<String>()
        mutArr.insert("Zero", at: 0)
        mutArr.insert("First", at: 1)
        
        mutArr[...1] = ["Replace"]
        mutArr[0..<0] = ["youhe"]
        
        print(mutArr)
        
        
        
    }
    
//    func TestBase() {
//
//        // 类型最值
//        let unsignedMinValue = UInt8.min
//        let unsignedMaxVlaue = UInt8.max
//
//        let minValue = Int8.min
//        let maxvalue = Int8.max
//
//        print("unsignedMinValue:\(unsignedMinValue)，unsignedMaxVlaue:\(unsignedMaxVlaue)，minValue:\(minValue)，maxvalue:\(maxvalue)")
//
//
//        // 类型强制转换
//        let twoThousand : UInt16 = 2000
//        let one : UInt8 = 1
//        let twoThousandAndOne = twoThousand + UInt16(one)
//
//        print("twoThousandAndOne: \(twoThousandAndOne)")
//
//
//        // 不同进制数进行表示（print均会按十进制显示）
//        let decimalInteger = 17
//        let binaryInteger = 0b10010
//        let octalInteger = 0o21
//        let hexadecimalInteger = 0x11
//
//        print("decimalInteger:\(decimalInteger), binaryInteger:\(binaryInteger), octalInteger:\(octalInteger), hexadecimalInteger:\(hexadecimalInteger), ")
//
//        // 指表示
//        let exponentDouble = 1.34e5
//        let hexadecimalDouble = 0xC.3p0
//
//        print("exponentDouble:\(exponentDouble), hexadecimalDouble:\(hexadecimalDouble)")
//
//        // 分隔符
//        let justOverOneMillion = 1_000_000.000_1
//        print("justOverOneMillion:\(justOverOneMillion)")
//
//        // 定义类型别名
//        typealias StringAlias = String
//
//        var string : StringAlias?
//        string = "haha"
//        let testString : StringAlias = "this is Alias of String"
//
//        print("typealias:\(testString)\ntypealias:\(string!)")
//
//        // 定义元组
//        let httpError = (401, "未授权", [1, 3], true)
//        print("元组:\(httpError)")
//
//        // 分解取出元组中的常量、变量
//        let (code, error, arr, bool) = httpError
//        print("code:\(code), error:\(error), arr:\(arr), bool:\(bool)")
//
//        let (code1,_,_,_) = httpError
//        print("code:\(code1), httpError:\(httpError)")
//
//        // let可选变量只允许初始化1次
//        let intNumber : Int?
//        intNumber = Int("12345")
//        // possiblenumber = 445 //报错！
//
//        if intNumber != nil {
//            print("possiblenumber:\(intNumber!)")
//        }
//
//        // 可选绑定
//        if let temp = intNumber {
//            print("可选绑定possiblenumber-temp:\(temp)")
//        } else {
//            print("可选绑定possiblenumber-temp没有值")
//        }
//
//        // 可选绑定及多条件
//        if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
//            print("\(firstNumber) < \(secondNumber) < 100")
//        } else {
//            print("不成立")
//        }
//        //等效的表达形式
//        if let firstNumber = Int("4") {
//            if let secondNumber = Int("42") {
//                if firstNumber < secondNumber && secondNumber < 100 {
//                    print("\(firstNumber) < \(secondNumber) < 100")
//                }
//            }
//        }
//
//
//        //var num: Int = nil //报错
//
//        var num: Int?
//        num = 10
//
//        if num is Optional<Int> {
//          print("它是可选类型")
//        } else {
//          print("它是Int类型")
//        }
//
//
////        // 强制解包
////        let optionalString : String? = "An optional string."
////        let forcedString : String = optionalString!
////
////        // 隐式解包
////        //! 2.定义了隐式解包的字符串类型的可选项，并赋初始值。
////        let assumedString : String! = "An implicitly unwrapped optional string."
////        let implicitString : String = assumedString
//
//        var name : String = "山南地北，天上云海"
//        name = String()
//        name.append("sd")
//
//        if name.isEmpty {
//            print("name为空nil")
//        } else {
//            print("name:\(name)")
//        }
//
//        for character in name {
//            print(character, terminator: "-")
//        }
//
//        let characters : [Character] = ["a", "b", "c", "d", "e", "f"]
//        let abcStr = String(characters)
//        print(abcStr)
//
//        name += characters
//        print(name)
//
//        let sdf = 3
//        let message = "\(sdf)sdfskdjfh\(sdf)"
//        print(message)
//
//
//    }
}
