//
//  QRCodePreviewLayer.swift
//  LedLamp
//
//  Created by Kyrylo Chernov on 03.03.2024.
//

import Foundation
import AVFoundation

public class QRCodeReaderPreviewLayer: AVCaptureVideoPreviewLayer {
    private let marginSize: CGFloat
    
//    public var rectOfInterest: CGRect {
//        metadataOutputRectConverted(fromLayerRect: maskContainer)
//    }
    
    public override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    public var maskContainer: CGRect {
//        let width:CGFloat = 166
//        return CGRect(x: ((bounds.width / 2) - (width / 2)),
//                      y: ((bounds.height / 2) - (width / 2)),
//                      width: width,
//                      height: width)
//    }
    
    public init(session: AVCaptureSession,
                marginSize: CGFloat) {
        self.marginSize = marginSize
        super.init(session: session)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
    }
}
