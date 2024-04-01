import SwiftUI
import SceneKit


struct QuickLookPreview: View {
    var body: some View {
        SceneKitView()
                    .frame(width: 800, height: 600)
    }
}

struct SceneKitView: NSViewRepresentable {
    func makeNSView(context: Context) -> SCNView {
        let scnView = SCNView()
                scnView.scene = SCNScene()
                scnView.allowsCameraControl = true
                scnView.autoenablesDefaultLighting = true

                
                // 加载.usdz模型
                if let fileURL = Bundle.main.url(forResource: "PegasusTrail", withExtension: "usdz") {
                    do {
                        let scene = try SCNScene(url: fileURL, options: nil)
                                        scnView.scene = scene
                        
                        // 加载模型并调整相机
                        if let modelNode = scene.rootNode.childNodes.first {
                            adjustCameraPosition(sceneView: scnView, modelNode: modelNode)
                        }
                                        
//                        scene.rootNode.eulerAngles.x = CGFloat.pi / 6
//                        
//                        // 调整模型缩放比例，使物体看起来更小
//                        // 假设模型是场景中的第一个子节点
//                        if let modelNode = scene.rootNode.childNodes.first {
//                            modelNode.scale = SCNVector3(0.4, 0.4, 0.4) // 缩小为原始大小的50%
//                            // 调整模型位置，使其在视图中更居中
//                            modelNode.position = SCNVector3(0, 1.0, 0)
//                        }
                    } catch {
                        print("Error loading scene: \(error)")
                    }
                }
                
        // 启用默认灯光
        scnView.autoenablesDefaultLighting = true
                
        // 创建并添加自定义网格到场景中
        let gridNode = createGridNode(size: 300, divisions: 50, color: NSColor.gray)
        scnView.scene?.rootNode.addChildNode(gridNode)
                
        // 使用自动视角调整
//        scnView.pointOfView?.camera?.automaticallyAdjustsZRange = true
                
        return scnView
    }
    
    func updateNSView(_ nsView: SCNView, context: Context) {
        // 在这里更新SCNView
    }
    
    // 更新调整相机位置的函数，以修正比较问题
    func adjustCameraPosition(sceneView: SCNView, modelNode: SCNNode) {
        let (min, max) = modelNode.boundingBox
        let center = SCNVector3((min.x + max.x) / 2, (min.y + max.y) / 2, (min.z + max.z) / 2)
        let extent = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)

        // 使用Swift标准库的max函数比较x, y, z分量
        let maxDimension = Swift.max(extent.x, extent.y, extent.z)
        let cameraDistance = maxDimension * 1.5 // 可根据需要调整这个乘数
        let cameraPosition = SCNVector3(center.x, center.y, center.z + cameraDistance)

        // 创建并配置相机节点
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = cameraPosition

        // 将相机节点添加到场景
        sceneView.scene?.rootNode.addChildNode(cameraNode)

        // 让相机朝向模型中心
        cameraNode.look(at: center)
    }


    func createGridNode(size: CGFloat, divisions: Int, color: NSColor) -> SCNNode {
        let parentGridNode = SCNNode()
        let gridSpacing = size / CGFloat(divisions)
        let lineWidth: CGFloat = 0.1
        let centerLineWidth: CGFloat = 0.2 // 中心线更粗
        let material = SCNMaterial()
        material.diffuse.contents = color.withAlphaComponent(0.6) // 非中心线颜色稍淡
        material.isDoubleSided = true

        let centerMaterial = SCNMaterial()
        centerMaterial.diffuse.contents = NSColor.black // 中心线使用黑色
        centerMaterial.isDoubleSided = true

        for i in 0...divisions {
            let isCenterLine = i == divisions / 2
            let lineMaterial = isCenterLine ? centerMaterial : material
            let lineThickness = isCenterLine ? centerLineWidth : lineWidth

            // 水平线
            let horizontalLine = SCNBox(width: size, height: lineThickness, length: lineThickness, chamferRadius: 0)
            horizontalLine.materials = [lineMaterial]
            
            let horizontalNode = SCNNode(geometry: horizontalLine)
            horizontalNode.position = SCNVector3(0, 0, -size / 2 + CGFloat(i) * gridSpacing)
            parentGridNode.addChildNode(horizontalNode)
            
            // 垂直线
            let verticalLine = SCNBox(width: lineThickness, height: lineThickness, length: size, chamferRadius: 0)
            verticalLine.materials = [lineMaterial]
            
            let verticalNode = SCNNode(geometry: verticalLine)
            verticalNode.position = SCNVector3(-size / 2 + CGFloat(i) * gridSpacing, 0, 0)
            parentGridNode.addChildNode(verticalNode)
        }

        // 添加中心圆圈
        let circle = SCNTorus(ringRadius: 3.0, pipeRadius: centerLineWidth / 2) // 圆圈尺寸可调整
        circle.firstMaterial?.diffuse.contents = NSColor.black
        let circleNode = SCNNode(geometry: circle)
        circleNode.position = SCNVector3(0, 0.1, 0) // 稍微提升以避免Z-fighting
        parentGridNode.addChildNode(circleNode)

        return parentGridNode
    }

}
