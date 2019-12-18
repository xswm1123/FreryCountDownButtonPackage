# FreryCountDownButtonPackage

自动倒计时按钮-swift版本
如何使用
1、该控件支持纯代码，xib，storyboard
2、初始化
    请在viewDidLoad中初始化
///设置触发时间只能在viewDidLoad中，方可以实现页面被压栈再回来，还可以继续倒计时
    button.setCountDown(countDown: 20, mark: "code") { (countDownSec) -> String in
        return "\(countDownSec)秒后重发"
    }
3、使用
        在button的点击事件中，触发函数
        startCountDown()即可实现倒计时;
        其他事件：
         reStartCountDown() //重置倒计时
         stopCountDown()//技术倒计时
4、控件支持自动倒计时，包括button和label
