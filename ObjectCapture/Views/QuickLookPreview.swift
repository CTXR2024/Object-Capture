import SwiftUI
import SceneKit


struct QuickLookPreview: View {
    var body: some View {
        // load the native .uzdz
        SceneKitView(modelURL:Bundle.main.url(forResource: "PegasusTrail", withExtension: "usdz")!)
    }
}

struct SceneKitView: NSViewRepresentable {
    private var modelURL: URL
    init(modelURL: URL){
        self.modelURL = modelURL
    }
    func makeNSView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = SCNScene()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        
        
        do {
            let scene = try SCNScene(url: modelURL, options: nil)
            scnView.scene = scene
            
            if let modelNode = scene.rootNode.childNodes.first {
                adjustCameraPosition(sceneView: scnView, modelNode: modelNode)
            }
        } catch {
            print("Error loading scene: \(error)")
        }
        
        
        // launch the default light
        scnView.autoenablesDefaultLighting = true
        return scnView
    }
    
    func updateNSView(_ nsView: SCNView, context: Context) {
        // update SCNView here
    }
    
    // update the camera position
    func adjustCameraPosition(sceneView: SCNView, modelNode: SCNNode) {
        let (min, max) = modelNode.boundingBox
        let center = SCNVector3((min.x + max.x) / 2, (min.y + max.y) / 2, (min.z + max.z) / 2)
        let extent = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
        
        let maxDimension = Swift.max(extent.x, extent.y, extent.z)
        let cameraDistance = maxDimension * 1.5 // 可根据需要调整这个乘数
        let cameraPosition = SCNVector3(center.x, center.y, center.z + cameraDistance)
        
        // create camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = cameraPosition
        
        // put the camera node into the root node
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // make the camnera center alignment
        cameraNode.look(at: center)
    }
    
    
    func createGridNode(size: CGFloat, divisions: Int, color: NSColor) -> SCNNode {
        let parentGridNode = SCNNode()
        let gridSpacing = size / CGFloat(divisions)
        let lineWidth: CGFloat = 0.1
        let centerLineWidth: CGFloat = 0.2 // make the central line heavier
        let material = SCNMaterial()
        material.diffuse.contents = color.withAlphaComponent(0.6)
        material.isDoubleSided = true
        
        let centerMaterial = SCNMaterial()
        centerMaterial.diffuse.contents = NSColor.black
        centerMaterial.isDoubleSided = true
        
        for i in 0...divisions {
            let isCenterLine = i == divisions / 2
            let lineMaterial = isCenterLine ? centerMaterial : material
            let lineThickness = isCenterLine ? centerLineWidth : lineWidth
            
            // horizontal line
            let horizontalLine = SCNBox(width: size, height: lineThickness, length: lineThickness, chamferRadius: 0)
            horizontalLine.materials = [lineMaterial]
            
            let horizontalNode = SCNNode(geometry: horizontalLine)
            horizontalNode.position = SCNVector3(0, 0, -size / 2 + CGFloat(i) * gridSpacing)
            parentGridNode.addChildNode(horizontalNode)
            
            // verticak line
            let verticalLine = SCNBox(width: lineThickness, height: lineThickness, length: size, chamferRadius: 0)
            verticalLine.materials = [lineMaterial]
            
            let verticalNode = SCNNode(geometry: verticalLine)
            verticalNode.position = SCNVector3(-size / 2 + CGFloat(i) * gridSpacing, 0, 0)
            parentGridNode.addChildNode(verticalNode)
        }
        
        // add central circle
        let circle = SCNTorus(ringRadius: 3.0, pipeRadius: centerLineWidth / 2) // adjust the radius of the circle
        circle.firstMaterial?.diffuse.contents = NSColor.black
        let circleNode = SCNNode(geometry: circle)
        circleNode.position = SCNVector3(0, 0.1, 0)
        parentGridNode.addChildNode(circleNode)
        
        return parentGridNode
    }
    
}
