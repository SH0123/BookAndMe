//
//  ScannerView.swift
//  ReadLog
//
//  Created by sanghyo on 11/14/23.
//

import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    private let completionHandler: ([String]) -> Void
    
    init(completionHandler: @escaping ([String]) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let cameraViewController = VNDocumentCameraViewController()
        cameraViewController.delegate = context.coordinator
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: self.completionHandler)
    }
}

extension ScannerView {
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        private let completionHandler: ([String]) -> Void
        
        init(completionHandler: @escaping ([String]) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let recognizer = TextRecognizer(cameraScan: scan)
            recognizer.recognizeText(withCompletionHandler: completionHandler)
        }
    }
}
