//
//  ViewController.swift
//  AR Drawing
//
//  Created by Vara Prasada Gopi Srinath Samudrala on 3/10/18.
//  Copyright © 2018 Vara Prasada Gopi Srinath Samudrala. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var clear: UIButton!
    var inkColor:UIColor = UIColor.green
    var inkSize:Float = 0.01
    
    @IBAction func yellowColor(_ sender: Any) {
        inkColor=UIColor.yellow
    }

    @IBAction func blueColor(_ sender: Any) {
        inkColor=UIColor.blue
    }
    @IBAction func greenColor(_ sender: Any) {
        inkColor=UIColor.green
    }
    
    @IBAction func redColor(_ sender: Any) {
        inkColor=UIColor.red
    }
    
    @IBAction func reduceInkSize(_ sender: Any) {
        if inkSize == 0.01 {
            return
        } else {
            inkSize-=0.01
        }
    }
    
    @IBAction func increaseInkSize(_ sender: Any) {
        inkSize+=0.01
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics=true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
//         print("rendering")
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
//        print(transform)
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentLocationOfCamera = orientation + location
//        print (orientation.x, orientation.y, orientation.z)
        DispatchQueue.main.async {
            if self.clear.isHighlighted{
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                        node.removeFromParentNode()                    
                })
            }
            if self.draw.isHighlighted{
                let sphereNode = SCNNode(geometry: SCNSphere(radius: CGFloat(self.inkSize)))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = self.inkColor
                sphereNode.position = currentLocationOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                print("button is pressed")
            } else{
                let pointer = SCNNode(geometry: SCNSphere(radius: CGFloat(self.inkSize)))
                pointer.geometry?.firstMaterial?.diffuse.contents = self.inkColor
                pointer.name = "pointer"
                pointer.position = currentLocationOfCamera
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
        
    }

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

