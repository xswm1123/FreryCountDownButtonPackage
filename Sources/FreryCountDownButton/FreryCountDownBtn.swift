//
//  FreryCountDownBtn.swift
//  MOSCTools
//
//  Created by Frery on 2019/12/16.
//  Copyright © 2019 Tima. All rights reserved.
//

import UIKit
typealias textFormBlock = (_ count:Int)->String

class FreryCountDownBtn: UIButton {
   
    ///是否不存储倒计时进度，默认为否
    public var disableScheduleStore:Bool = false
    ///是否禁止倒计时停止时是否恢复到最初的状态（按钮文字、按钮文字颜色、按钮背景色），默认为否
    public var disableResumeWhenEnd:Bool = false
    
    var orgText:String?
    var orgTextColor :UIColor?
    var orgBacColor :UIColor?
    var cdCore : CountDownButtonCore?
    
    convenience  init(){
        self.init()
        initOperation()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initOperation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initOperation()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initOperation()
    }
    
    public func initOperation(){
        self.orgText = self.currentTitle;
        self.orgTextColor = self.titleLabel?.textColor;
        self.orgBacColor = self.backgroundColor;
    }
    /// ///设置倒计时时间，倒计时标志，并回调block,依据mark来分别存储不同倒计时任务剩余的倒计时时间
    /// - Parameters:
    ///   - countDown: 倒计时值
    ///   - mark: marki标记
    ///   - textHandler: 回调处理显示标题等
    public func setCountDown(countDown:Int,mark:String,textHandler:@escaping textFormBlock){
        self.cdCore = CountDownButtonCore()
        self.cdCore?.disableScheduleStore = self.disableScheduleStore;
        self.cdCore?.setCountDown(countDown: countDown, mark: mark, textHandler: {[weak self] (remainSec) in
            let btnTitle = textHandler(remainSec)
            if remainSec > 0{
                self?.setTitle(btnTitle, for: .normal)
                self?.isEnabled = false
            }else{
                self?.isEnabled = true
                if self!.disableResumeWhenEnd {
                    self!.setTitle(btnTitle, for: .normal)
                    return
                }
                self?.resumeOrgStatus()
            }
        })
        
    }
    func resumeOrgStatus(){
        self.setTitle(self.orgText, for: .normal)
        self.setTitleColor(self.orgTextColor, for: .normal)
        self.backgroundColor = self.orgBacColor;
    }
    /// 开始倒计时
    public func startCountDown(){
       initOperation()
        self.cdCore?.startCountDown()
    }
    ///重新开始倒计时
    public func reStartCountDown(){
        self.cdCore?.reStartCountDown()
    }
    ///结束倒计时
    public func stopCountDown(){
        self.cdCore?.stopCountDown()
    }
    ///关闭倒计时
    public func invalidateTimer(){
        self.cdCore?.invalidateTimer()
    }
    deinit{
        invalidateTimer()
    }
}
