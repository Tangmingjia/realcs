import UIKit

class Operation : UIView {
    
    var operationView : UIView?
    var useButton : UIButton?
    var dropButton : UIButton?
    var cancelButton : UIButton?
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.operationView = UIView()
        self.addSubview(operationView!)
        
        self.useButton = UIButton()
        self.operationView?.addSubview(useButton!)
        
        self.dropButton = UIButton()
        self.operationView?.addSubview(dropButton!)
        
        self.cancelButton = UIButton()
        self.operationView?.addSubview(cancelButton!)
        
        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
       
        self.operationView?.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        self.operationView?.backgroundColor = UIColor(patternImage: UIImage(named: "operationBg.png")!)
        
        self.useButton?.frame = CGRect(x: 20, y: 33, width: 80, height: 34)
        self.useButton?.setBackgroundImage(UIImage(named: "use.png"), for: .normal)
        
        self.dropButton?.frame = CGRect(x: 110, y: 33, width: 80, height: 34)
        self.dropButton?.setBackgroundImage(UIImage(named: "drop.png"), for: .normal)
        
        self.cancelButton?.frame = CGRect(x: 200, y: 33, width: 80, height: 34)
        self.cancelButton?.setBackgroundImage(UIImage(named: "cancel.png"), for: .normal)
        
    }
    
}
