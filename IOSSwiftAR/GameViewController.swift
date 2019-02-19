//
//  ViewController.swift
//  SpaceShipMuseum
//
//  Created by Brian Advent on 09.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARRecognitionTags", bundle: Bundle.main) else {
            print("No images available")
            return
        }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

            plane.firstMaterial?.diffuse.contents = UIColor.clear
            
            let planeNode = SCNNode(geometry: plane)

            let shipScene = SCNScene(named: "art.scnassets/USSEnterprise.dae")!
            let shipNode = shipScene.rootNode.childNodes.first!
            
            shipNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
            shipNode.position = SCNVector3Zero

            planeNode.addChildNode(shipNode)
            
            node.addChildNode(planeNode)
            
        }
        
        return node
        
    }
    
    
}
