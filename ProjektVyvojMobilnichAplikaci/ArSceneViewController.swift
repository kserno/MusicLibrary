//
//  ArSceneViewController.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 29/03/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit
import ARKit
import Vision

class ArSceneViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var processing: Bool = false
    var detectedBarcodeAnchor: ARAnchor?

    var barcodeDetectionRequests = [VNRequest]()
    var latestFrame: ARFrame? = nil
    var qrRect: CGRect? = nil
    
    var lastBarcode: String? = nil
    
    var arAlbumViewController: ARAlbumViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // shows statistics like fps
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        startBarcodeScanning()
    }
    
    private func startBarcodeScanning() {
        let request = VNDetectBarcodesRequest(completionHandler: self.requestHandler)
        barcodeDetectionRequests = [request]
    }
    
    
    private func requestHandler(request: VNRequest, error: Error?) {
        // Get the first result out of the results, if there are any
        if let results = request.results, let result = results.first as? VNBarcodeObservation {
            guard let payload = result.payloadStringValue else {
                return
            }
            print(payload)
            lastBarcode = payload
            // Get the bounding box for the bar code and find the center
            var rect = result.boundingBox
            qrRect = rect
            // Flip coordinates
            rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
            rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
            // Get center
            let center = CGPoint(x: rect.midX, y: rect.midY)
            
            DispatchQueue.main.async {
                self.hitTestBarcode(center: center)
                self.processing = false
            }
        } else {
            self.processing = false
        }
    }
    
    private func hitTestBarcode(center: CGPoint) {
        
        if let hitTestResults = self.latestFrame?.hitTest(center, types: [.featurePoint] ),
            let hitTestResult = hitTestResults.first {
            if detectedBarcodeAnchor != nil {
                let node = self.sceneView.node(for: detectedBarcodeAnchor!)
                node?.transform = SCNMatrix4(hitTestResult.worldTransform)
            } else {
                // Create an anchor. The node will be created in delegate methods
                detectedBarcodeAnchor = ARAnchor(transform: hitTestResult.worldTransform)
                sceneView.session.add(anchor: detectedBarcodeAnchor!)
            }
        }
    }
    
   
    
    func navigateDetail() {
        performSegue(withIdentifier: "AlbumSegue", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (detectedBarcodeAnchor != nil) {
            sceneView.session.remove(anchor: detectedBarcodeAnchor!)
            sceneView.session.pause()
        }
        //sceneView.session.pause() not working
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension ArSceneViewController: ARSCNViewDelegate {

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print(anchors[0])
    }
   
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // If this is our anchor, create a node
        let node = SCNNode()
        
        if detectedBarcodeAnchor?.identifier == anchor.identifier {
            if (qrRect == nil) {
                return node
            }
            
            let plane = SCNPlane(
                width: 0.3,
                height: 0.5
            )
            
            if (arAlbumViewController == nil) {
                arAlbumViewController = ARAlbumViewController()
                arAlbumViewController?.arController = self
                arAlbumViewController?.barcode = lastBarcode
            }
            
        
            plane.firstMaterial?.diffuse.contents = arAlbumViewController?.view
            let planeNode = SCNNode(geometry: plane)
            planeNode.transform = SCNMatrix4(anchor.transform)
            
            node.addChildNode(planeNode)
        }
        return node
    }
    
}

extension ArSceneViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        latestFrame = frame
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if self.processing {
                    return
                }
                self.processing = true
                // Create a request handler using the captured image from the ARFrame
                let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage,
                                                                options: [:])
                // Process the request
                try imageRequestHandler.perform(self.barcodeDetectionRequests)
            } catch {
                
            }
        }
    }

}


