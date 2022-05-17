//
//  ViewController.swift
//  Poke3D
//
//  Created by Angela Yu on 20/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) else {
            print("can't add images")
            return
            
        }
        
        configuration.trackingImages = imageToTrack
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCBViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        //if it is detected an image
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -Float.pi/2
            
            node.addChildNode(planeNode)
            
            var scnNamePath = ""
            
            if imageAnchor.referenceImage.name == "eevee-card" {
                scnNamePath = "art.scnassets/eevee.scn"
            }else{
                scnNamePath = "art.scnassets/oddish.scn"
            }
            
            
            if let pokeScene = SCNScene(named: scnNamePath) {
                
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    
                    pokeNode.eulerAngles.x = .pi / 2
                    
                    planeNode.addChildNode(pokeNode)
                }
            }
            
        }
        return node
    }
}
