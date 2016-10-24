//  LoadingView.swift
//  Ping
//
//  Code generated using QuartzCode 1.40.0 on 2016-08-10.
//  www.quartzcodeapp.com
//
//  Created by Jeff Eom on 2016-08-10.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingView: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupProperties()
        setupLayers()
    }
    
    
    
    func setupProperties(){
        
    }
    
    func setupLayers(){
        let LoadingAnimationGroup = CALayer()
        LoadingAnimationGroup.frame = CGRect(x: 118.07, y: 127, width: 168.93, height: 146)
        self.layer.addSublayer(LoadingAnimationGroup)
        layers["LoadingAnimationGroup"] = LoadingAnimationGroup
        let Phone = CALayer()
        Phone.frame = CGRect(x: 0, y: 0.04, width: 83.85, height: 145.96)
        LoadingAnimationGroup.addSublayer(Phone)
        layers["Phone"] = Phone
        let roundedRect = CAShapeLayer()
        roundedRect.frame = CGRect(x: 0, y: 0, width: 83.85, height: 145.96)
        roundedRect.path = roundedRectPath().cgPath
        Phone.addSublayer(roundedRect)
        layers["roundedRect"] = roundedRect
        let rectangle = CAShapeLayer()
        rectangle.frame = CGRect(x: 9.73, y: 9.95, width: 64.39, height: 116.05)
        rectangle.path = rectanglePath().cgPath
        Phone.addSublayer(rectangle)
        layers["rectangle"] = rectangle
        let oval = CAShapeLayer()
        oval.frame = CGRect(x: 36.69, y: 132.19, width: 10.47, height: 9.89)
        oval.path = ovalPath().cgPath
        Phone.addSublayer(oval)
        layers["oval"] = oval
        let Lines = CALayer()
        Lines.frame = CGRect(x: 15.85, y: 21.68, width: 52.15, height: 92.6)
        Phone.addSublayer(Lines)
        layers["Lines"] = Lines
        let path = CAShapeLayer()
        path.frame = CGRect(x: 0, y: 0, width: 52.15, height: 0)
        path.path = pathPath().cgPath
        Lines.addSublayer(path)
        layers["path"] = path
        let path2 = CAShapeLayer()
        path2.frame = CGRect(x: 0, y: 11.08, width: 41.39, height: 0)
        path2.path = path2Path().cgPath
        Lines.addSublayer(path2)
        layers["path2"] = path2
        let path3 = CAShapeLayer()
        path3.frame = CGRect(x: 0, y: 20.86, width: 52.15, height: 0)
        path3.path = path3Path().cgPath
        Lines.addSublayer(path3)
        layers["path3"] = path3
        let path4 = CAShapeLayer()
        path4.frame = CGRect(x: 0, y: 30.31, width: 52.15, height: 0)
        path4.path = path4Path().cgPath
        Lines.addSublayer(path4)
        layers["path4"] = path4
        let path5 = CAShapeLayer()
        path5.frame = CGRect(x: 0, y: 41.71, width: 41.39, height: 0)
        path5.path = path5Path().cgPath
        Lines.addSublayer(path5)
        layers["path5"] = path5
        let path6 = CAShapeLayer()
        path6.frame = CGRect(x: 0, y: 51.16, width: 24.44, height: 0)
        path6.path = path6Path().cgPath
        Lines.addSublayer(path6)
        layers["path6"] = path6
        let path7 = CAShapeLayer()
        path7.frame = CGRect(x: 0, y: 60.61, width: 52.15, height: 0)
        path7.path = path7Path().cgPath
        Lines.addSublayer(path7)
        layers["path7"] = path7
        let path8 = CAShapeLayer()
        path8.frame = CGRect(x: 0, y: 70.06, width: 41.39, height: 0)
        path8.path = path8Path().cgPath
        Lines.addSublayer(path8)
        layers["path8"] = path8
        let path9 = CAShapeLayer()
        path9.frame = CGRect(x: 0, y: 82.66, width: 52.15, height: 0)
        path9.path = path9Path().cgPath
        Lines.addSublayer(path9)
        layers["path9"] = path9
        let path10 = CAShapeLayer()
        path10.frame = CGRect(x: 0, y: 92.6, width: 24.44, height: 0)
        path10.path = path10Path().cgPath
        Lines.addSublayer(path10)
        layers["path10"] = path10
        let Phone2 = CALayer()
        Phone2.frame = CGRect(x: 84.93, y: 0, width: 84, height: 146)
        LoadingAnimationGroup.addSublayer(Phone2)
        layers["Phone2"] = Phone2
        let roundedRect2 = CAShapeLayer()
        roundedRect2.frame = CGRect(x: 0, y: 0, width: 84, height: 146)
        roundedRect2.path = roundedRect2Path().cgPath
        Phone2.addSublayer(roundedRect2)
        layers["roundedRect2"] = roundedRect2
        let rectangle2 = CAShapeLayer()
        rectangle2.frame = CGRect(x: 9.75, y: 9.95, width: 64.51, height: 116.08)
        rectangle2.path = rectangle2Path().cgPath
        Phone2.addSublayer(rectangle2)
        layers["rectangle2"] = rectangle2
        let oval2 = CAShapeLayer()
        oval2.frame = CGRect(x: 36.76, y: 132.22, width: 10.49, height: 9.9)
        oval2.path = oval2Path().cgPath
        Phone2.addSublayer(oval2)
        layers["oval2"] = oval2
        let Lines2 = CALayer()
        Lines2.frame = CGRect(x: 17.68, y: 20.84, width: 48.65, height: 91.59)
        Phone2.addSublayer(Lines2)
        layers["Lines2"] = Lines2
        let path11 = CAShapeLayer()
        path11.frame = CGRect(x: 0, y: 0, width: 48.65, height: 0)
        path11.path = path11Path().cgPath
        Lines2.addSublayer(path11)
        layers["path11"] = path11
        let path12 = CAShapeLayer()
        path12.frame = CGRect(x: 0, y: 10.96, width: 38.61, height: 0)
        path12.path = path12Path().cgPath
        Lines2.addSublayer(path12)
        layers["path12"] = path12
        let path13 = CAShapeLayer()
        path13.frame = CGRect(x: 0, y: 20.63, width: 48.65, height: 0)
        path13.path = path13Path().cgPath
        Lines2.addSublayer(path13)
        layers["path13"] = path13
        let path14 = CAShapeLayer()
        path14.frame = CGRect(x: 0, y: 29.98, width: 48.65, height: 0)
        path14.path = path14Path().cgPath
        Lines2.addSublayer(path14)
        layers["path14"] = path14
        let path15 = CAShapeLayer()
        path15.frame = CGRect(x: 0, y: 41.26, width: 38.61, height: 0)
        path15.path = path15Path().cgPath
        Lines2.addSublayer(path15)
        layers["path15"] = path15
        let path16 = CAShapeLayer()
        path16.frame = CGRect(x: 0, y: 50.61, width: 22.8, height: 0)
        path16.path = path16Path().cgPath
        Lines2.addSublayer(path16)
        layers["path16"] = path16
        let path17 = CAShapeLayer()
        path17.frame = CGRect(x: 0, y: 59.95, width: 48.65, height: 0)
        path17.path = path17Path().cgPath
        Lines2.addSublayer(path17)
        layers["path17"] = path17
        let path18 = CAShapeLayer()
        path18.frame = CGRect(x: 0, y: 69.3, width: 38.61, height: 0)
        path18.path = path18Path().cgPath
        Lines2.addSublayer(path18)
        layers["path18"] = path18
        let path19 = CAShapeLayer()
        path19.frame = CGRect(x: 0, y: 81.76, width: 48.65, height: 0)
        path19.path = path19Path().cgPath
        Lines2.addSublayer(path19)
        layers["path19"] = path19
        let path20 = CAShapeLayer()
        path20.frame = CGRect(x: 0, y: 91.59, width: 22.8, height: 0)
        path20.path = path20Path().cgPath
        Lines2.addSublayer(path20)
        layers["path20"] = path20
        let Signal = CALayer()
        Signal.frame = CGRect(x: 9.93, y: 59.8, width: 23.66, height: 26.4)
        LoadingAnimationGroup.addSublayer(Signal)
        layers["Signal"] = Signal
        let oval3 = CAShapeLayer()
        oval3.frame = CGRect(x: 0, y: 6.98, width: 2.02, height: 11.86)
        oval3.path = oval3Path().cgPath
        Signal.addSublayer(oval3)
        layers["oval3"] = oval3
        let oval4 = CAShapeLayer()
        oval4.frame = CGRect(x: 9.66, y: 3.3, width: 3.28, height: 19.21)
        oval4.path = oval4Path().cgPath
        Signal.addSublayer(oval4)
        layers["oval4"] = oval4
        let oval5 = CAShapeLayer()
        oval5.frame = CGRect(x: 19.01, y: 0, width: 4.64, height: 26.4)
        oval5.path = oval5Path().cgPath
        Signal.addSublayer(oval5)
        layers["oval5"] = oval5
        let Signal2 = CALayer()
        Signal2.frame = CGRect(x: 54.77, y: 57.71, width: 22.92, height: 30.62)
        LoadingAnimationGroup.addSublayer(Signal2)
        layers["Signal2"] = Signal2
        let oval6 = CAShapeLayer()
        oval6.frame = CGRect(x: 0, y: 8.1, width: 1.96, height: 13.76)
        oval6.path = oval6Path().cgPath
        Signal2.addSublayer(oval6)
        layers["oval6"] = oval6
        let oval7 = CAShapeLayer()
        oval7.frame = CGRect(x: 9.36, y: 3.83, width: 3.17, height: 22.29)
        oval7.path = oval7Path().cgPath
        Signal2.addSublayer(oval7)
        layers["oval7"] = oval7
        let oval8 = CAShapeLayer()
        oval8.frame = CGRect(x: 18.42, y: 0, width: 4.5, height: 30.62)
        oval8.path = oval8Path().cgPath
        Signal2.addSublayer(oval8)
        layers["oval8"] = oval8
        
        let text = CATextLayer()
        text.frame = CGRect(x: 72.35, y: 102.8, width: 175.3, height: 48.4)
        self.layer.addSublayer(text)
        layers["text"] = text
        
        resetLayerPropertiesForLayerIdentifiers(nil)
    }
    
    func resetLayerPropertiesForLayerIdentifiers(_ layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("roundedRect"){
            let roundedRect = layers["roundedRect"] as! CAShapeLayer
            roundedRect.fillColor   = UIColor.black.cgColor
            roundedRect.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("rectangle"){
            let rectangle = layers["rectangle"] as! CAShapeLayer
            rectangle.fillColor   = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).cgColor
            rectangle.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("oval"){
            let oval = layers["oval"] as! CAShapeLayer
            oval.fillColor   = UIColor.black.cgColor
            oval.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("Lines"){
            let Lines = layers["Lines"] as! CALayer
            Lines.opacity = 0
            
        }
        if layerIds == nil || layerIds.contains("path"){
            let path = layers["path"] as! CAShapeLayer
            path.opacity     = 0.66
            path.fillColor   = nil
            path.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path2"){
            let path2 = layers["path2"] as! CAShapeLayer
            path2.opacity     = 0.66
            path2.fillColor   = nil
            path2.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path3"){
            let path3 = layers["path3"] as! CAShapeLayer
            path3.opacity     = 0.66
            path3.fillColor   = nil
            path3.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path4"){
            let path4 = layers["path4"] as! CAShapeLayer
            path4.opacity     = 0.66
            path4.fillColor   = nil
            path4.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path5"){
            let path5 = layers["path5"] as! CAShapeLayer
            path5.opacity     = 0.66
            path5.fillColor   = nil
            path5.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path6"){
            let path6 = layers["path6"] as! CAShapeLayer
            path6.opacity     = 0.66
            path6.fillColor   = nil
            path6.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path7"){
            let path7 = layers["path7"] as! CAShapeLayer
            path7.opacity     = 0.66
            path7.fillColor   = nil
            path7.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path8"){
            let path8 = layers["path8"] as! CAShapeLayer
            path8.opacity     = 0.66
            path8.fillColor   = nil
            path8.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path9"){
            let path9 = layers["path9"] as! CAShapeLayer
            path9.opacity     = 0.66
            path9.fillColor   = nil
            path9.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path10"){
            let path10 = layers["path10"] as! CAShapeLayer
            path10.opacity     = 0.66
            path10.fillColor   = nil
            path10.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("Phone2"){
            let Phone2 = layers["Phone2"] as! CALayer
            Phone2.opacity = 0
            
        }
        if layerIds == nil || layerIds.contains("roundedRect2"){
            let roundedRect2 = layers["roundedRect2"] as! CAShapeLayer
            roundedRect2.fillColor   = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).cgColor
            roundedRect2.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("rectangle2"){
            let rectangle2 = layers["rectangle2"] as! CAShapeLayer
            rectangle2.fillColor   = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).cgColor
            rectangle2.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("oval2"){
            let oval2 = layers["oval2"] as! CAShapeLayer
            oval2.fillColor   = UIColor(red:0.922, green: 0.922, blue:0.922, alpha:1).cgColor
            oval2.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("Lines2"){
            let Lines2 = layers["Lines2"] as! CALayer
            Lines2.opacity = 0
            
        }
        if layerIds == nil || layerIds.contains("path11"){
            let path11 = layers["path11"] as! CAShapeLayer
            path11.opacity     = 0.67
            path11.fillColor   = nil
            path11.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path12"){
            let path12 = layers["path12"] as! CAShapeLayer
            path12.opacity     = 0.67
            path12.fillColor   = nil
            path12.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path13"){
            let path13 = layers["path13"] as! CAShapeLayer
            path13.opacity     = 0.67
            path13.fillColor   = nil
            path13.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path14"){
            let path14 = layers["path14"] as! CAShapeLayer
            path14.opacity     = 0.67
            path14.fillColor   = nil
            path14.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path15"){
            let path15 = layers["path15"] as! CAShapeLayer
            path15.opacity     = 0.67
            path15.fillColor   = nil
            path15.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path16"){
            let path16 = layers["path16"] as! CAShapeLayer
            path16.opacity     = 0.67
            path16.fillColor   = nil
            path16.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path17"){
            let path17 = layers["path17"] as! CAShapeLayer
            path17.opacity     = 0.67
            path17.fillColor   = nil
            path17.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path18"){
            let path18 = layers["path18"] as! CAShapeLayer
            path18.opacity     = 0.67
            path18.fillColor   = nil
            path18.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path19"){
            let path19 = layers["path19"] as! CAShapeLayer
            path19.opacity     = 0.67
            path19.fillColor   = nil
            path19.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("path20"){
            let path20 = layers["path20"] as! CAShapeLayer
            path20.opacity     = 0.67
            path20.fillColor   = nil
            path20.strokeColor = UIColor.blue.cgColor
        }
        if layerIds == nil || layerIds.contains("Signal"){
            let Signal = layers["Signal"] as! CALayer
            Signal.opacity = 0
            
        }
        if layerIds == nil || layerIds.contains("oval3"){
            let oval3 = layers["oval3"] as! CAShapeLayer
            oval3.fillColor   = nil
            oval3.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("oval4"){
            let oval4 = layers["oval4"] as! CAShapeLayer
            oval4.fillColor   = nil
            oval4.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("oval5"){
            let oval5 = layers["oval5"] as! CAShapeLayer
            oval5.anchorPoint = CGPoint(x: 0.5, y: 0)
            oval5.frame       = CGRect(x: 19.01, y: 0, width: 4.64, height: 26.4)
            oval5.fillColor   = nil
            oval5.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("Signal2"){
            let Signal2 = layers["Signal2"] as! CALayer
            Signal2.setValue(-180 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
            Signal2.opacity = 0
            
        }
        if layerIds == nil || layerIds.contains("oval6"){
            let oval6 = layers["oval6"] as! CAShapeLayer
            oval6.fillColor   = nil
            oval6.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("oval7"){
            let oval7 = layers["oval7"] as! CAShapeLayer
            oval7.fillColor   = nil
            oval7.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("oval8"){
            let oval8 = layers["oval8"] as! CAShapeLayer
            oval8.anchorPoint = CGPoint(x: 0.5, y: 0)
            oval8.frame       = CGRect(x: 18.42, y: 0, width: 4.5, height: 30.62)
            oval8.fillColor   = nil
            oval8.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:1).cgColor
        }
        if layerIds == nil || layerIds.contains("text"){
            let text = layers["text"] as! CATextLayer
            text.opacity         = 0
            text.contentsScale   = UIScreen.main.scale
            text.string          = "Ping"
            text.font            = "Helvetica-Bold" as CFTypeRef?
            text.fontSize        = 40
            text.alignmentMode   = kCAAlignmentCenter;
            text.foregroundColor = UIColor(red:0.44, green:0.96, blue:0.82, alpha:1.0).cgColor;
            text.shadowColor     = UIColor(red:0, green: 0, blue:0, alpha:0.69).cgColor
            text.shadowOpacity = 0.69
            text.shadowOffset  = CGSize(width: 4, height: 4)
            text.shadowRadius  = 5
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addLoadingAnimationGroupAnimation(){
        addLoadingAnimationGroupAnimationCompletionBlock(nil)
    }
    
    func addLoadingAnimationGroupAnimationCompletionBlock(_ completionBlock: ((_ finished: Bool) -> Void)?){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 7.145
            completionAnim.delegate = self
            completionAnim.setValue("LoadingAnimationGroup", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.add(completionAnim, forKey:"LoadingAnimationGroup")
            if let anim = layer.animation(forKey: "LoadingAnimationGroup"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = kCAFillModeForwards
        
        ////LoadingAnimationGroup animation
        let LoadingAnimationGroupOpacityAnim = CAKeyframeAnimation(keyPath:"opacity")
        LoadingAnimationGroupOpacityAnim.values = [1, 0]
        LoadingAnimationGroupOpacityAnim.keyTimes = [0, 1]
        LoadingAnimationGroupOpacityAnim.duration = 1.02
        LoadingAnimationGroupOpacityAnim.beginTime = 3.98
        
        let LoadingAnimationGroupLoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([LoadingAnimationGroupOpacityAnim], fillMode:fillMode)
        layers["LoadingAnimationGroup"]?.add(LoadingAnimationGroupLoadingAnimationGroupAnim, forKey:"LoadingAnimationGroupLoadingAnimationGroupAnim")
        
        ////Phone animation
        let PhoneOpacityAnim       = CABasicAnimation(keyPath:"opacity")
        PhoneOpacityAnim.fromValue = 0;
        PhoneOpacityAnim.toValue   = 1;
        PhoneOpacityAnim.duration  = 0.989
        
        let PhonePositionAnim       = CABasicAnimation(keyPath:"position")
        PhonePositionAnim.fromValue = NSValue(cgPoint: CGPoint(x: 41.926, y: 73.018));
        PhonePositionAnim.toValue   = NSValue(cgPoint: CGPoint(x: -38.519, y: 73.018));
        PhonePositionAnim.duration  = 1
        PhonePositionAnim.beginTime = 1.09
        
        let PhoneLoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([PhoneOpacityAnim, PhonePositionAnim], fillMode:fillMode)
        layers["Phone"]?.add(PhoneLoadingAnimationGroupAnim, forKey:"PhoneLoadingAnimationGroupAnim")
        
        ////Lines animation
        let LinesOpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        LinesOpacityAnim.values    = [0, 1]
        LinesOpacityAnim.keyTimes  = [0, 1]
        LinesOpacityAnim.duration  = 1
        LinesOpacityAnim.beginTime = 2.98
        
        let LinesLoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([LinesOpacityAnim], fillMode:fillMode)
        layers["Lines"]?.add(LinesLoadingAnimationGroupAnim, forKey:"LinesLoadingAnimationGroupAnim")
        
        ////Phone2 animation
        let Phone2OpacityAnim       = CABasicAnimation(keyPath:"opacity")
        Phone2OpacityAnim.fromValue = 0;
        Phone2OpacityAnim.toValue   = 1;
        Phone2OpacityAnim.duration  = 1
        Phone2OpacityAnim.beginTime = 1.09
        
        let Phone2LoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([Phone2OpacityAnim], fillMode:fillMode)
        layers["Phone2"]?.add(Phone2LoadingAnimationGroupAnim, forKey:"Phone2LoadingAnimationGroupAnim")
        
        ////Lines2 animation
        let Lines2OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        Lines2OpacityAnim.values    = [0, 1]
        Lines2OpacityAnim.keyTimes  = [0, 1]
        Lines2OpacityAnim.duration  = 1
        Lines2OpacityAnim.beginTime = 2.98
        
        let Lines2LoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([Lines2OpacityAnim], fillMode:fillMode)
        layers["Lines2"]?.add(Lines2LoadingAnimationGroupAnim, forKey:"Lines2LoadingAnimationGroupAnim")
        
        ////Signal animation
        let SignalOpacityAnim            = CABasicAnimation(keyPath:"opacity")
        SignalOpacityAnim.fromValue      = 0;
        SignalOpacityAnim.toValue        = 1;
        SignalOpacityAnim.duration       = 0.638
        SignalOpacityAnim.beginTime      = 2.09
        SignalOpacityAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        let SignalLoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([SignalOpacityAnim], fillMode:fillMode)
        layers["Signal"]?.add(SignalLoadingAnimationGroupAnim, forKey:"SignalLoadingAnimationGroupAnim")
        
        ////Signal2 animation
        let Signal2OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        Signal2OpacityAnim.values    = [0, 1]
        Signal2OpacityAnim.keyTimes  = [0, 1]
        Signal2OpacityAnim.duration  = 0.348
        Signal2OpacityAnim.beginTime = 2.38
        
        let Signal2LoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([Signal2OpacityAnim], fillMode:fillMode)
        layers["Signal2"]?.add(Signal2LoadingAnimationGroupAnim, forKey:"Signal2LoadingAnimationGroupAnim")
        
        ////Text animation
        let textOpacityAnim          = CAKeyframeAnimation(keyPath:"opacity")
        textOpacityAnim.values       = [0, 0.757]
        textOpacityAnim.keyTimes     = [0, 1]
        textOpacityAnim.duration     = 1.0
        textOpacityAnim.beginTime    = 5.14
        textOpacityAnim.autoreverses = true
        
        let textLoadingAnimationGroupAnim : CAAnimationGroup = QCMethod.groupAnimations([textOpacityAnim], fillMode:fillMode)
        layers["text"]?.add(textLoadingAnimationGroupAnim, forKey:"textLoadingAnimationGroupAnim")
    }
    
    //MARK: - Animation Cleanup
    
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValue(forKey: anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
                updateLayerValuesForAnimationId(anim.value(forKey: "animId") as! String)
                removeAnimationsForAnimationId(anim.value(forKey: "animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValuesForAnimationId(_ identifier: String){
        if identifier == "LoadingAnimationGroup"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["LoadingAnimationGroup"] as! CALayer).animation(forKey: "LoadingAnimationGroupLoadingAnimationGroupAnim"), theLayer:(layers["LoadingAnimationGroup"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["Phone"] as! CALayer).animation(forKey: "PhoneLoadingAnimationGroupAnim"), theLayer:(layers["Phone"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["Lines"] as! CALayer).animation(forKey: "LinesLoadingAnimationGroupAnim"), theLayer:(layers["Lines"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["Phone2"] as! CALayer).animation(forKey: "Phone2LoadingAnimationGroupAnim"), theLayer:(layers["Phone2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["Lines2"] as! CALayer).animation(forKey: "Lines2LoadingAnimationGroupAnim"), theLayer:(layers["Lines2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["Signal"] as! CALayer).animation(forKey: "SignalLoadingAnimationGroupAnim"), theLayer:(layers["Signal"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["Signal2"] as! CALayer).animation(forKey: "Signal2LoadingAnimationGroupAnim"), theLayer:(layers["Signal2"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["text"] as! CALayer).animation(forKey: "textLoadingAnimationGroupAnim"), theLayer:(layers["text"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(_ identifier: String){
        if identifier == "LoadingAnimationGroup"{
            (layers["LoadingAnimationGroup"] as! CALayer).removeAnimation(forKey: "LoadingAnimationGroupLoadingAnimationGroupAnim")
            (layers["Phone"] as! CALayer).removeAnimation(forKey: "PhoneLoadingAnimationGroupAnim")
            (layers["Lines"] as! CALayer).removeAnimation(forKey: "LinesLoadingAnimationGroupAnim")
            (layers["Phone2"] as! CALayer).removeAnimation(forKey: "Phone2LoadingAnimationGroupAnim")
            (layers["Lines2"] as! CALayer).removeAnimation(forKey: "Lines2LoadingAnimationGroupAnim")
            (layers["Signal"] as! CALayer).removeAnimation(forKey: "SignalLoadingAnimationGroupAnim")
            (layers["Signal2"] as! CALayer).removeAnimation(forKey: "Signal2LoadingAnimationGroupAnim")
            (layers["text"] as! CALayer).removeAnimation(forKey: "textLoadingAnimationGroupAnim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func roundedRectPath() -> UIBezierPath{
        let roundedRectPath = UIBezierPath(roundedRect:CGRect(x: 0, y: 0, width: 84, height: 146), cornerRadius:4)
        return roundedRectPath
    }
    
    func rectanglePath() -> UIBezierPath{
        let rectanglePath = UIBezierPath(rect:CGRect(x: 0, y: 0, width: 64, height: 116))
        return rectanglePath
    }
    
    func ovalPath() -> UIBezierPath{
        let ovalPath = UIBezierPath(ovalIn:CGRect(x: 0, y: 0, width: 10, height: 10))
        return ovalPath
    }
    
    func pathPath() -> UIBezierPath{
        let pathPath = UIBezierPath()
        pathPath.move(to: CGPoint(x: 0, y: 0))
        pathPath.addCurve(to: CGPoint(x: 52.149, y: 0), controlPoint1:CGPoint(x: 17.383, y: 0), controlPoint2:CGPoint(x: 34.766, y: 0))
        
        return pathPath
    }
    
    func path2Path() -> UIBezierPath{
        let path2Path = UIBezierPath()
        path2Path.move(to: CGPoint(x: 0, y: 0))
        path2Path.addCurve(to: CGPoint(x: 41.391, y: 0), controlPoint1:CGPoint(x: 13.797, y: 0), controlPoint2:CGPoint(x: 27.594, y: 0))
        
        return path2Path
    }
    
    func path3Path() -> UIBezierPath{
        let path3Path = UIBezierPath()
        path3Path.move(to: CGPoint(x: 0, y: 0))
        path3Path.addCurve(to: CGPoint(x: 52.149, y: 0), controlPoint1:CGPoint(x: 17.383, y: 0), controlPoint2:CGPoint(x: 34.766, y: 0))
        
        return path3Path
    }
    
    func path4Path() -> UIBezierPath{
        let path4Path = UIBezierPath()
        path4Path.move(to: CGPoint(x: 0, y: 0))
        path4Path.addCurve(to: CGPoint(x: 52.149, y: 0), controlPoint1:CGPoint(x: 17.383, y: 0), controlPoint2:CGPoint(x: 34.766, y: 0))
        
        return path4Path
    }
    
    func path5Path() -> UIBezierPath{
        let path5Path = UIBezierPath()
        path5Path.move(to: CGPoint(x: 0, y: 0))
        path5Path.addCurve(to: CGPoint(x: 41.391, y: 0), controlPoint1:CGPoint(x: 13.797, y: 0), controlPoint2:CGPoint(x: 27.594, y: 0))
        
        return path5Path
    }
    
    func path6Path() -> UIBezierPath{
        let path6Path = UIBezierPath()
        path6Path.move(to: CGPoint(x: 0, y: 0))
        path6Path.addCurve(to: CGPoint(x: 24.435, y: 0), controlPoint1:CGPoint(x: 8.145, y: 0), controlPoint2:CGPoint(x: 16.29, y: 0))
        
        return path6Path
    }
    
    func path7Path() -> UIBezierPath{
        let path7Path = UIBezierPath()
        path7Path.move(to: CGPoint(x: 0, y: 0))
        path7Path.addCurve(to: CGPoint(x: 52.149, y: 0), controlPoint1:CGPoint(x: 17.383, y: 0), controlPoint2:CGPoint(x: 34.766, y: 0))
        
        return path7Path
    }
    
    func path8Path() -> UIBezierPath{
        let path8Path = UIBezierPath()
        path8Path.move(to: CGPoint(x: 0, y: 0))
        path8Path.addCurve(to: CGPoint(x: 41.391, y: 0), controlPoint1:CGPoint(x: 13.797, y: 0), controlPoint2:CGPoint(x: 27.594, y: 0))
        
        return path8Path
    }
    
    func path9Path() -> UIBezierPath{
        let path9Path = UIBezierPath()
        path9Path.move(to: CGPoint(x: 0, y: 0))
        path9Path.addCurve(to: CGPoint(x: 52.149, y: 0), controlPoint1:CGPoint(x: 17.383, y: 0), controlPoint2:CGPoint(x: 34.766, y: 0))
        
        return path9Path
    }
    
    func path10Path() -> UIBezierPath{
        let path10Path = UIBezierPath()
        path10Path.move(to: CGPoint(x: 0, y: 0))
        path10Path.addCurve(to: CGPoint(x: 24.435, y: 0), controlPoint1:CGPoint(x: 8.145, y: 0), controlPoint2:CGPoint(x: 16.29, y: 0))
        
        return path10Path
    }
    
    func roundedRect2Path() -> UIBezierPath{
        let roundedRect2Path = UIBezierPath(roundedRect:CGRect(x: 0, y: 0, width: 84, height: 146), cornerRadius:4)
        return roundedRect2Path
    }
    
    func rectangle2Path() -> UIBezierPath{
        let rectangle2Path = UIBezierPath(rect:CGRect(x: 0, y: 0, width: 65, height: 116))
        return rectangle2Path
    }
    
    func oval2Path() -> UIBezierPath{
        let oval2Path = UIBezierPath(ovalIn:CGRect(x: 0, y: 0, width: 10, height: 10))
        return oval2Path
    }
    
    func path11Path() -> UIBezierPath{
        let path11Path = UIBezierPath()
        path11Path.move(to: CGPoint(x: 0, y: 0))
        path11Path.addCurve(to: CGPoint(x: 48.649, y: 0), controlPoint1:CGPoint(x: 16.216, y: 0), controlPoint2:CGPoint(x: 32.433, y: 0))
        
        return path11Path
    }
    
    func path12Path() -> UIBezierPath{
        let path12Path = UIBezierPath()
        path12Path.move(to: CGPoint(x: 0, y: 0))
        path12Path.addCurve(to: CGPoint(x: 38.613, y: 0), controlPoint1:CGPoint(x: 12.871, y: 0), controlPoint2:CGPoint(x: 25.742, y: 0))
        
        return path12Path
    }
    
    func path13Path() -> UIBezierPath{
        let path13Path = UIBezierPath()
        path13Path.move(to: CGPoint(x: 0, y: 0))
        path13Path.addCurve(to: CGPoint(x: 48.649, y: 0), controlPoint1:CGPoint(x: 16.216, y: 0), controlPoint2:CGPoint(x: 32.433, y: 0))
        
        return path13Path
    }
    
    func path14Path() -> UIBezierPath{
        let path14Path = UIBezierPath()
        path14Path.move(to: CGPoint(x: 0, y: 0))
        path14Path.addCurve(to: CGPoint(x: 48.649, y: 0), controlPoint1:CGPoint(x: 16.216, y: 0), controlPoint2:CGPoint(x: 32.433, y: 0))
        
        return path14Path
    }
    
    func path15Path() -> UIBezierPath{
        let path15Path = UIBezierPath()
        path15Path.move(to: CGPoint(x: 0, y: 0))
        path15Path.addCurve(to: CGPoint(x: 38.613, y: 0), controlPoint1:CGPoint(x: 12.871, y: 0), controlPoint2:CGPoint(x: 25.742, y: 0))
        
        return path15Path
    }
    
    func path16Path() -> UIBezierPath{
        let path16Path = UIBezierPath()
        path16Path.move(to: CGPoint(x: 0, y: 0))
        path16Path.addCurve(to: CGPoint(x: 22.795, y: 0), controlPoint1:CGPoint(x: 7.598, y: 0), controlPoint2:CGPoint(x: 15.197, y: 0))
        
        return path16Path
    }
    
    func path17Path() -> UIBezierPath{
        let path17Path = UIBezierPath()
        path17Path.move(to: CGPoint(x: 0, y: 0))
        path17Path.addCurve(to: CGPoint(x: 48.649, y: 0), controlPoint1:CGPoint(x: 16.216, y: 0), controlPoint2:CGPoint(x: 32.433, y: 0))
        
        return path17Path
    }
    
    func path18Path() -> UIBezierPath{
        let path18Path = UIBezierPath()
        path18Path.move(to: CGPoint(x: 0, y: 0))
        path18Path.addCurve(to: CGPoint(x: 38.613, y: 0), controlPoint1:CGPoint(x: 12.871, y: 0), controlPoint2:CGPoint(x: 25.742, y: 0))
        
        return path18Path
    }
    
    func path19Path() -> UIBezierPath{
        let path19Path = UIBezierPath()
        path19Path.move(to: CGPoint(x: 0, y: 0))
        path19Path.addCurve(to: CGPoint(x: 48.649, y: 0), controlPoint1:CGPoint(x: 16.216, y: 0), controlPoint2:CGPoint(x: 32.433, y: 0))
        
        return path19Path
    }
    
    func path20Path() -> UIBezierPath{
        let path20Path = UIBezierPath()
        path20Path.move(to: CGPoint(x: 0, y: 0))
        path20Path.addCurve(to: CGPoint(x: 22.795, y: 0), controlPoint1:CGPoint(x: 7.598, y: 0), controlPoint2:CGPoint(x: 15.197, y: 0))
        
        return path20Path
    }
    
    func oval3Path() -> UIBezierPath{
        let bound = CGRect(x: 0, y: 0, width: 2, height: 12)
        let oval3Path = UIBezierPath(arcCenter:CGPoint(x: 0, y: 0), radius:bound.width/2, startAngle:-50 * CGFloat(M_PI)/180, endAngle:-310 * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransform(translationX: bound.midX, y: bound.midY)
        pathTransform = pathTransform.scaledBy(x: 1, y: bound.height/bound.width)
        oval3Path.apply(pathTransform)
        return oval3Path
    }
    
    func oval4Path() -> UIBezierPath{
        let bound = CGRect(x: 0, y: 0, width: 3, height: 19)
        let oval4Path = UIBezierPath(arcCenter:CGPoint(x: 0, y: 0), radius:bound.width/2, startAngle:-50 * CGFloat(M_PI)/180, endAngle:-310 * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransform(translationX: bound.midX, y: bound.midY)
        pathTransform = pathTransform.scaledBy(x: 1, y: bound.height/bound.width)
        oval4Path.apply(pathTransform)
        return oval4Path
    }
    
    func oval5Path() -> UIBezierPath{
        let bound = CGRect(x: 0, y: 0, width: 5, height: 26)
        let oval5Path = UIBezierPath(arcCenter:CGPoint(x: 0, y: 0), radius:bound.width/2, startAngle:-50 * CGFloat(M_PI)/180, endAngle:-310 * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransform(translationX: bound.midX, y: bound.midY)
        pathTransform = pathTransform.scaledBy(x: 1, y: bound.height/bound.width)
        oval5Path.apply(pathTransform)
        return oval5Path
    }
    
    func oval6Path() -> UIBezierPath{
        let bound = CGRect(x: 0, y: 0, width: 2, height: 14)
        let oval6Path = UIBezierPath(arcCenter:CGPoint(x: 0, y: 0), radius:bound.width/2, startAngle:-50 * CGFloat(M_PI)/180, endAngle:-310 * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransform(translationX: bound.midX, y: bound.midY)
        pathTransform = pathTransform.scaledBy(x: 1, y: bound.height/bound.width)
        oval6Path.apply(pathTransform)
        return oval6Path
    }
    
    func oval7Path() -> UIBezierPath{
        let bound = CGRect(x: 0, y: 0, width: 3, height: 22)
        let oval7Path = UIBezierPath(arcCenter:CGPoint(x: 0, y: 0), radius:bound.width/2, startAngle:-50 * CGFloat(M_PI)/180, endAngle:-310 * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransform(translationX: bound.midX, y: bound.midY)
        pathTransform = pathTransform.scaledBy(x: 1, y: bound.height/bound.width)
        oval7Path.apply(pathTransform)
        return oval7Path
    }
    
    func oval8Path() -> UIBezierPath{
        let bound = CGRect(x: 0, y: 0, width: 4, height: 31)
        let oval8Path = UIBezierPath(arcCenter:CGPoint(x: 0, y: 0), radius:bound.width/2, startAngle:-50 * CGFloat(M_PI)/180, endAngle:-310 * CGFloat(M_PI)/180, clockwise:true)
        var pathTransform = CGAffineTransform(translationX: bound.midX, y: bound.midY)
        pathTransform = pathTransform.scaledBy(x: 1, y: bound.height/bound.width)
        oval8Path.apply(pathTransform)
        return oval8Path
    }
    
    
}
