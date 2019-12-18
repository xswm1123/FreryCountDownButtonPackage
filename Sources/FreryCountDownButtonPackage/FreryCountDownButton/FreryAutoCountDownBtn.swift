//
//  FreryAutoCountDownBtn.swift
//  MOSCTools
//
//  Created by Frery on 2019/12/16.
//  Copyright © 2019 Tima. All rights reserved.
//
import UIKit
import Foundation

class FreryAutoCountDownBtn: FreryCountDownBtn{
    ///是否终止倒计时，默认为否(每次点击倒计时按钮仅终止这一次的操作，如希望点击倒计时按钮均不执行自动倒计时，请使用FreryCountDownBtn)
    public var terminateCountDown :Bool = false
    var countDownMark :String?
    var countDownSec :Int?
    var enAbleAutoCountDown:Bool?
    var textFormat : textFormBlock?
    
    override func initOperation() {
        super.initOperation()
    }
    
///启用自动倒计时按钮，实现类似点击获取验证码效果，countDownSec为倒计时时间，mark为FreryCountDownBtn用于区分不同倒计时操作的标识，并回调结果
    public func enableAutoCountDown(countDown:Int,mark:String,resTextFormat:@escaping textFormBlock){
        self.countDownMark = mark
        self.countDownSec = countDown
        self.enAbleAutoCountDown = true
        self.textFormat = resTextFormat
        let core = CountDownButtonCore()
        let disTime = core.getDisTimeWith(mark: mark)
        if(disTime > 0 && !self.disableScheduleStore){
            startCountDown()
        }
    }
    ///重置倒计时按钮
    public func resume(){
        stopCountDown()
        self.isEnabled = true
        self.setTitle(self.value(forKey: "orgText") as? String, for: .normal)
        self.setTitleColor(self.value(forKey: "orgTextColor") as? UIColor, for: .normal)
        self.backgroundColor = self.value(forKey: "orgBacColor") as? UIColor
    }
    override func startCountDown() {
        if self.isEnabled{
            self.setCountDown(countDown: self.countDownSec!, mark: self.countDownMark!) {[weak self] (remainSec) -> String in
                if remainSec > 0{
                                   self?.isEnabled = false
                               }else{
                                   self?.isEnabled = true
                               }
                if((self) != nil){
                    return self!.textFormat!(remainSec)
                               }else{
                                   return "";
                               }
            }
            super.startCountDown()
        }
    }
    deinit {
        invalidateTimer()
    }
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        if(!self.terminateCountDown){
                startCountDown()
            }
            self.terminateCountDown = false
        }
    }
