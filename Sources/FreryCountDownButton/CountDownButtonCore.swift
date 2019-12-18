//
//  CountDownButtonCore.swift
//  MOSCTools
//
//  Created by Frery on 2019/12/16.
//  Copyright © 2019 Tima. All rights reserved.
//

import Foundation

typealias countDownBlock = (Int)->Void

let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
let CountDownButtonMark = "CountDownButtonMarkDefault"


class CountDownButtonCore{
    
   public var disableScheduleStore :Bool = false

    var timer: DispatchSource?
    var mark :String?
    var didStart:Bool?
    var inRunLoop :Bool?
    var countDownSec:Int?
    var timeout:Int?
    var orgCountDownSec:Int?
    var endTimestamp:Int?
    var markDic:Dictionary<String, Any>?
    var resBlock:countDownBlock?
    
    /// ///设置倒计时时间，倒计时标志，并回调block,依据mark来分别存储不同倒计时任务剩余的倒计时时间
    /// - Parameters:
    ///   - countDown: 倒计时值
    ///   - mark: marki标记
    ///   - textHandler: 回调处理显示标题等
    public func setCountDown(countDown:Int,mark:String, textHandler:@escaping countDownBlock){
        if mark.count == 0 {
            return
        }
        self.resBlock = textHandler;
        invalidateTimer()
        let disTime = getDisTimeWith(mark: mark);
        if self.orgCountDownSec == nil{
            self.orgCountDownSec = countDown;
        }
        if(disTime > 0 && !self.disableScheduleStore){
            countDownSec = disTime;
        }
        self.countDownSec = countDown;
        self.mark = mark;
        if self.timer == nil {
            self.timeout = countDown;
            if self.timeout!  != 0 {
                self.timer = DispatchSource.makeTimerSource() as? DispatchSource
                self.timer?.schedule(deadline: .now(), repeating: 1)
                self.timer?.setEventHandler(handler: { [weak self] in
                    if self!.inRunLoop ?? true {
                        self!.coreRunLoop()
                    }
                })
            }
            self.timer!.resume()
            if(disTime > 0 && !self.disableScheduleStore){
                startCountDown()
            }
        }
    }
    /// 开始倒计时
    public func startCountDown(){
        if self.timer != nil{
            if !self.didStart!{
                refreshMarkDic()
                self.endTimestamp = Date.timeStamp() + self.countDownSec!;
                self.markDic = ["\(self.endTimestamp!)" : self.mark!]
                saveDataLocally(object: self.markDic!)
                coreRunLoop()
                self.inRunLoop = true;
            }
            self.didStart = true;
        }else{
            reStartCountDown()
        }
    }
    ///重新开始倒计时
    public func reStartCountDown(){
        stopCountDown()
        setCountDown(countDown: self.orgCountDownSec!, mark: self.mark!, textHandler: self.resBlock!)
        startCountDown()
    }
    ///结束倒计时
    public func stopCountDown(){
        invalidateTimer()
        refreshMarkDic()
        if  self.markDic != nil{
        if  self.markDic!.keys.contains(self.mark!){
            self.markDic![self.mark!] = 0;
            saveDataLocally(object: self.markDic!)
        }
        }
    }
    ///关闭倒计时
    public func invalidateTimer(){
        if self.timer != nil{
            self.timer!.cancel()
            self.inRunLoop = false;
            self.timer = nil;
            self.didStart = false;
        }
    }
    func coreRunLoop(){
        if self.timeout! <= 0 {
            invalidateTimer()
        }else{
            let  timeStamp = Date.timeStamp()
            self.timeout = (self.endTimestamp ?? 0 - timeStamp) < 0 ? 0 : self.endTimestamp! - timeStamp
        }
        DispatchQueue.main.async {
            self.resBlock!(self.timeout!)
        }
    }
    //MARK:刷新markDic，从沙盒中获取最新的markDic
    func refreshMarkDic(){
        let countDownMarkDic = readDataLocally()
        self.markDic = countDownMarkDic
    }
    //MARK:private method
    //MARK:获取距离结束时间
    func getDisTimeWith(mark:String) -> Int {
        if self.markDic != nil{
        if  self.markDic!.keys.contains(mark){
            let endTimeStamp = self.markDic![mark] as! Int
            let currentTimeStamp = Date.timeStamp()
            if currentTimeStamp<endTimeStamp {
                let disSec = endTimeStamp - currentTimeStamp
                return disSec
            }
        }
        }
        return 0
    }
    //MARK:存档
    func saveDataLocally(object:Dictionary<String,Any>){
        let userDefault = UserDefaults.standard
        userDefault.set(object, forKey: CountDownButtonMark)
        userDefault.synchronize()
    }
    //MARK:读档
    func readDataLocally()->Dictionary<String,Any>{
        let userDefault = UserDefaults.standard
        return userDefault.object(forKey: CountDownButtonMark) as? Dictionary<String, Any> ?? [:]
    }
}
