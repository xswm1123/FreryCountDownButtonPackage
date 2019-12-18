//
//  FreryCountDownLabel.swift
//  MOSCTools
//
//  Created by Frery on 2019/12/16.
//  Copyright © 2019 Tima. All rights reserved.
//

import UIKit

class FreryCountDownLabel: UILabel {
    ///是否不存储倒计时进度，默认为否
    public var disableScheduleStore :Bool = false
    ///是否禁止倒计时停止时是否恢复到最初的状态（文字、文字颜色、文字背景色），默认为否
    public var disableResumeWhenEnd :Bool = false
    
    var orgText:String?
    var orgTextColor:UIColor?
    var orgBacColor:UIColor?
    var cdCore:CountDownButtonCore?
    
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
        self.orgText = self.text
        self.orgTextColor = self.textColor
        self.orgBacColor = self.backgroundColor
    }
    
    ///设置倒计时时间，倒计时标志，并回调block，ZXCountDown依据mark来分别存储不同倒计时任务剩余的倒计时时间
    public func setCountDown(countDown:Int,mark:String,resTextFormat:@escaping textFormBlock){
        self.cdCore = CountDownButtonCore()
        self.cdCore?.disableScheduleStore = self.disableScheduleStore
        self.cdCore?.setCountDown(countDown: countDown, mark: mark, textHandler: {[weak self] (remainSec) in
            if(remainSec > 0){
                self?.text = resTextFormat(remainSec);
            }else{
                if(self!.disableResumeWhenEnd){
                    self!.text = resTextFormat(remainSec);
                    return;
                }
                self!.resumeOrgStatus()
            }
        })
    }
    func resumeOrgStatus(){
        self.text = self.orgText
        self.textColor = self.orgTextColor
        self.backgroundColor = self.orgBacColor
    }
    ///开始倒计时
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
    deinit {
        invalidateTimer()
    }
}
