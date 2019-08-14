import UIKit
var SaveNum : String = ""
class Save : UIView,UITextFieldDelegate {
    
    var saveBg : UIView?
    var label1 : UILabel?
    var label2 : UILabel?
    var label3 : UILabel?
    var label4 : UILabel?
    var label5 : UILabel?
    var label6 : UILabel?
    var label7 : UILabel?
    var label8 : UILabel?
    var labelarray : Array = [UILabel]()
    var keyboard : UIView?
    var btn0 : UIButton?
    var btn1 : UIButton?
    var btn2 : UIButton?
    var btn3 : UIButton?
    var btn4 : UIButton?
    var btn5 : UIButton?
    var btn6 : UIButton?
    var btn7 : UIButton?
    var btn8 : UIButton?
    var btn9 : UIButton?
    var backbtn : UIButton?
    var cancelbtn : UIButton?
    var okbtn : UIButton?
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.saveBg = UIView()
        self.addSubview(saveBg!)
        
        self.label1 = UILabel()
        self.saveBg?.addSubview(label1!)
        
        self.label2 = UILabel()
        self.saveBg?.addSubview(label2!)
        
        self.label3 = UILabel()
        self.saveBg?.addSubview(label3!)
        
        self.label4 = UILabel()
        self.saveBg?.addSubview(label4!)
        
        self.label5 = UILabel()
        self.saveBg?.addSubview(label5!)
        
        self.label6 = UILabel()
        self.saveBg?.addSubview(label6!)
        
        self.label7 = UILabel()
        self.saveBg?.addSubview(label7!)
        
        self.label8 = UILabel()
        self.saveBg?.addSubview(label8!)
        
        self.keyboard = UIView()
        self.saveBg?.addSubview(keyboard!)
        
        self.btn0 = UIButton()
        self.keyboard?.addSubview(btn0!)
        
        self.btn1 = UIButton()
        self.keyboard?.addSubview(btn1!)
        
        self.btn2 = UIButton()
        self.keyboard?.addSubview(btn2!)
        
        self.btn3 = UIButton()
        self.keyboard?.addSubview(btn3!)
        
        self.btn4 = UIButton()
        self.keyboard?.addSubview(btn4!)
        
        self.btn5 = UIButton()
        self.keyboard?.addSubview(btn5!)
        
        self.btn6 = UIButton()
        self.keyboard?.addSubview(btn6!)
        
        self.btn7 = UIButton()
        self.keyboard?.addSubview(btn7!)
        
        self.btn8 = UIButton()
        self.keyboard?.addSubview(btn8!)
        
        self.btn9 = UIButton()
        self.keyboard?.addSubview(btn9!)
        
        self.backbtn = UIButton()
        self.keyboard?.addSubview(backbtn!)
        
        self.cancelbtn = UIButton()
        self.keyboard?.addSubview(cancelbtn!)
        
        self.okbtn = UIButton()
        self.keyboard?.addSubview(okbtn!)
        
        setUI()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.saveBg?.frame = CGRect(x: 0, y: 0, width: 490, height: 250)
        self.saveBg?.backgroundColor = UIColor(patternImage: UIImage(named: "textbg.png")!)
        
        self.label1?.frame = CGRect(x: 10, y: 30, width: 50, height: 50)
        self.label1?.layer.borderColor = UIColor.white.cgColor
        self.label1?.layer.borderWidth = 1
        self.label1?.layer.cornerRadius = 5
        self.label1?.layer.masksToBounds = true
        self.label1?.textColor = UIColor.white
        self.label1?.textAlignment = .center
        self.label1?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label1!)
        
        self.label2?.frame = CGRect(x: 70, y: 30, width: 50, height: 50)
        self.label2?.layer.borderColor = UIColor.white.cgColor
        self.label2?.layer.borderWidth = 1
        self.label2?.layer.cornerRadius = 5
        self.label2?.layer.masksToBounds = true
        self.label2?.textColor = UIColor.white
        self.label2?.textAlignment = .center
        self.label2?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label2!)
        
        self.label3?.frame = CGRect(x: 130, y: 30, width: 50, height: 50)
        self.label3?.layer.borderColor = UIColor.white.cgColor
        self.label3?.layer.borderWidth = 1
        self.label3?.layer.cornerRadius = 5
        self.label3?.layer.masksToBounds = true
        self.label3?.textColor = UIColor.white
        self.label3?.textAlignment = .center
        self.label3?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label3!)
        
        self.label4?.frame = CGRect(x: 190, y: 30, width: 50, height: 50)
        self.label4?.layer.borderColor = UIColor.white.cgColor
        self.label4?.layer.borderWidth = 1
        self.label4?.layer.cornerRadius = 5
        self.label4?.layer.masksToBounds = true
        self.label4?.textColor = UIColor.white
        self.label4?.textAlignment = .center
        self.label4?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label4!)
        
        self.label5?.frame = CGRect(x: 250, y: 30, width: 50, height: 50)
        self.label5?.layer.borderColor = UIColor.white.cgColor
        self.label5?.layer.borderWidth = 1
        self.label5?.layer.cornerRadius = 5
        self.label5?.layer.masksToBounds = true
        self.label5?.textColor = UIColor.white
        self.label5?.textAlignment = .center
        self.label5?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label5!)
        
        self.label6?.frame = CGRect(x: 310, y: 30, width: 50, height: 50)
        self.label6?.layer.borderColor = UIColor.white.cgColor
        self.label6?.layer.borderWidth = 1
        self.label6?.layer.cornerRadius = 5
        self.label6?.layer.masksToBounds = true
        self.label6?.textColor = UIColor.white
        self.label6?.textAlignment = .center
        self.label6?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label6!)
        
        self.label7?.frame = CGRect(x: 370, y: 30, width: 50, height: 50)
        self.label7?.layer.borderColor = UIColor.white.cgColor
        self.label7?.layer.borderWidth = 1
        self.label7?.layer.cornerRadius = 5
        self.label7?.layer.masksToBounds = true
        self.label7?.textColor = UIColor.white
        self.label7?.textAlignment = .center
        self.label7?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label7!)
        
        self.label8?.frame = CGRect(x: 430, y: 30, width: 50, height: 50)
        self.label8?.layer.borderColor = UIColor.white.cgColor
        self.label8?.layer.borderWidth = 1
        self.label8?.layer.cornerRadius = 5
        self.label8?.layer.masksToBounds = true
        self.label8?.textColor = UIColor.white
        self.label8?.textAlignment = .center
        self.label8?.font = UIFont.systemFont(ofSize: 18)
        labelarray.append(label8!)
        
        self.keyboard?.frame = CGRect(x: 40, y: 100, width: 410, height: 110)
        self.keyboard?.backgroundColor = UIColor.clear
        
        self.btn1?.frame = CGRect(x: 30, y: 0, width: 50, height: 50)
        self.btn1?.setBackgroundImage(UIImage(named: "01_2.png"), for: .normal)
        self.btn1?.setBackgroundImage(UIImage(named: "01_1.png"), for: .highlighted)
        self.btn1?.tag = 1
        self.btn1?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn2?.frame = CGRect(x: 90, y: 0, width: 50, height: 50)
        self.btn2?.setBackgroundImage(UIImage(named: "02_2.png"), for: .normal)
        self.btn2?.setBackgroundImage(UIImage(named: "02_1.png"), for: .highlighted)
        self.btn2?.tag = 2
        self.btn2?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn3?.frame = CGRect(x: 150, y: 0, width: 50, height: 50)
        self.btn3?.setBackgroundImage(UIImage(named: "03_2.png"), for: .normal)
        self.btn3?.setBackgroundImage(UIImage(named: "03_1.png"), for: .highlighted)
        self.btn3?.tag = 3
        self.btn3?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn4?.frame = CGRect(x: 210, y: 0, width: 50, height: 50)
        self.btn4?.setBackgroundImage(UIImage(named: "04_2.png"), for: .normal)
        self.btn4?.setBackgroundImage(UIImage(named: "04_1.png"), for: .highlighted)
        self.btn4?.tag = 4
        self.btn4?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn5?.frame = CGRect(x: 270, y: 0, width: 50, height: 50)
        self.btn5?.setBackgroundImage(UIImage(named: "05_2.png"), for: .normal)
        self.btn5?.setBackgroundImage(UIImage(named: "05_1.png"), for: .highlighted)
        self.btn5?.tag = 5
        self.btn5?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.backbtn?.frame = CGRect(x: 330, y: 0, width: 50, height: 50)
        self.backbtn?.setBackgroundImage(UIImage(named: "Backspace_2.png"), for: .normal)
        self.backbtn?.setBackgroundImage(UIImage(named: "Backspace_1.png"), for: .highlighted)
        self.backbtn?.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        self.btn6?.frame = CGRect(x: 0, y: 60, width: 50, height: 50)
        self.btn6?.setBackgroundImage(UIImage(named: "06_2.png"), for: .normal)
        self.btn6?.setBackgroundImage(UIImage(named: "06_1.png"), for: .highlighted)
        self.btn6?.tag = 6
        self.btn6?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn7?.frame = CGRect(x: 60, y: 60, width: 50, height: 50)
        self.btn7?.setBackgroundImage(UIImage(named: "07_2.png"), for: .normal)
        self.btn7?.setBackgroundImage(UIImage(named: "07_1.png"), for: .highlighted)
        self.btn7?.tag = 7
        self.btn7?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn8?.frame = CGRect(x: 120, y: 60, width: 50, height: 50)
        self.btn8?.setBackgroundImage(UIImage(named: "08_2.png"), for: .normal)
        self.btn8?.setBackgroundImage(UIImage(named: "08_1.png"), for: .highlighted)
        self.btn8?.tag = 8
        self.btn8?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn9?.frame = CGRect(x: 180, y: 60, width: 50, height: 50)
        self.btn9?.setBackgroundImage(UIImage(named: "09_2.png"), for: .normal)
        self.btn9?.setBackgroundImage(UIImage(named: "09_1.png"), for: .highlighted)
        self.btn9?.tag = 9
        self.btn9?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.btn0?.frame = CGRect(x: 240, y: 60, width: 50, height: 50)
        self.btn0?.setBackgroundImage(UIImage(named: "10_2.png"), for: .normal)
        self.btn0?.setBackgroundImage(UIImage(named: "10_1.png"), for: .highlighted)
        self.btn0?.tag = 0
        self.btn0?.addTarget(self, action: #selector(clickNum(sender:)), for: .touchUpInside)
        
        self.cancelbtn?.frame = CGRect(x: 300, y: 60, width: 50, height: 50)
        self.cancelbtn?.setBackgroundImage(UIImage(named: "no_2.png"), for: .normal)
        self.cancelbtn?.setBackgroundImage(UIImage(named: "no_1.png"), for: .highlighted)
        self.cancelbtn?.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        self.okbtn?.frame = CGRect(x: 360, y: 60, width: 50, height: 50)
        self.okbtn?.setBackgroundImage(UIImage(named: "yes_2.png"), for: .normal)
        self.okbtn?.setBackgroundImage(UIImage(named: "yes_1.png"), for: .highlighted)
    }
    
    @objc func clickNum(sender: UIButton){
        for i in 0...7 {
            if labelarray[i].text == nil {
                labelarray[i].text = "\(sender.tag)"
                SaveNum.append("\(sender.tag)")
                return
            }
        }
    }
    
    @objc func back(){
        for i in (0...7).reversed() {  //倒序遍历
            if labelarray[i].text != nil {
                labelarray[i].text = nil
                SaveNum.removeLast()
                return
            }
        }
    }
    
    @objc func cancel(){
        for i in 0...7 {
            labelarray[i].text = nil
        }
        SaveNum.removeAll()
    }
}
