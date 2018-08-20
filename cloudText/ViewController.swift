//
//  ViewController.swift
//  cloudText
//
//  Created by Chewy Wu on 8/10/18.
//  Copyright © 2018 Chewy Wu. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var SceneView: ARSCNView!
     var configuration = ARWorldTrackingConfiguration()
     var user_input: String = ""
     var cameraNode = SCNNode()
     var textNode = SCNNode()
     var cloudSetNode = SCNNode()
    
    @IBOutlet weak var UIFieldName: UITextField!
    
    @IBAction func TypeInField(_ sender: Any) {
        print(UIFieldName.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SceneView.debugOptions = []
        SceneView.session.run(configuration)
        SceneView.showsStatistics = true
        SceneView.delegate = self
        
        cloudSetNode.position = SCNVector3(x: -40, y: 50, z: -70)
        cloudSetNode.name = "cloudSet"
        SceneView.scene.rootNode.addChildNode(cloudSetNode)
    }
    
    @IBAction func sendText(_ sender: Any) {
        user_input = UIFieldName.text!
        self.restart()
        self.createText()
        self.createCloud()
        
        UIFieldName.resignFirstResponder()

    }
    
    func createText() {
        //create 3d text
        let geo_Text = SCNText(string: user_input, extrusionDepth: 5)
        geo_Text.font = UIFont(name: "Optima", size: 25)
        geo_Text.alignmentMode = kCAAlignmentCenter
        //texture
        let tex_blue = SCNMaterial()
        tex_blue.diffuse.contents = #imageLiteral(resourceName: "cloud2_tex")
        tex_blue.reflective.contents = #imageLiteral(resourceName: "cloud2_tex")
        tex_blue.isDoubleSided = true
        geo_Text.firstMaterial = tex_blue

        
        //textNode
        textNode = SCNNode(geometry: geo_Text)
        textNode.eulerAngles = SCNVector3Make(Float(50.degreesToRadians), 0, 0);
        textNode.position = SCNVector3(x: 0, y: 0, z: 0)
        textNode.name = "text"
        
        let (minBound, maxBound) = geo_Text.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.02/2)
        
        cloudSetNode.addChildNode(textNode)
        
    }
    
    func restart(){
        SceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "clouds" || node.name == "text" {
                node.removeFromParentNode()
            }
        }
    }
    
    func createCloud(){
        //create 3d clouds
        let geo_Cloud = SCNPlane(width: 80, height: 40)
        
        //texture
        let tex_Cloud = SCNMaterial()
        tex_Cloud.diffuse.contents = #imageLiteral(resourceName: "cloud3_tex")
        tex_Cloud.transparency = 1
        geo_Cloud.firstMaterial = tex_Cloud
        
        //textNode
        let cloudNode = SCNNode(geometry: geo_Cloud)
        cloudNode.position = SCNVector3(x: 0, y: 5, z: 5)
        cloudNode.eulerAngles = SCNVector3Make(Float(10.degreesToRadians), 0, 0);
        
        let cloudNode2 = SCNNode(geometry: geo_Cloud)
        cloudNode2.position = SCNVector3(x: 5, y: 10, z: -15)
        cloudNode2.eulerAngles = SCNVector3Make(Float(10.degreesToRadians), 0, 0);
       
        if cloudNode.animationKeys.isEmpty {
            self.panLeftNode(node: cloudNode)
            self.panRightNode(node: cloudNode2)
        }
         cloudNode.name = "clouds"
         cloudNode2.name = "clouds"
        
        cloudSetNode.addChildNode(cloudNode)
        cloudSetNode.addChildNode(cloudNode2)
    }
    
//    func action_Pan(time: TimeInterval) -> SCNAction {
//        let pan = SCNAction.moveBy(x: 10, y: 0, z: 0, duration: time)
//        let foreverpan = SCNAction.repeatForever(pan)
//        return foreverpan
//    }
    
    
    func panLeftNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(node.presentation.position.x - 25 ,node.presentation.position.y, node.presentation.position.z)
        spin.duration = 5
        spin.repeatCount = 10
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "postion")
    }
    
    func panRightNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(node.presentation.position.x + 25 ,node.presentation.position.y, node.presentation.position.z + 5)
        spin.duration = 8
        spin.repeatCount = 10
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "postion")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    
}
