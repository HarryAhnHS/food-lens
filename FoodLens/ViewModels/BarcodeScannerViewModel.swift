//
//  BarcodeScannerViewModel.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import AVFoundation
import SwiftUI

// Credits to David Kirchhoff and his video "https://www.youtube.com/watch?v=R2STbo53_vc&t=288s"
class BarcodeScannerViewModel: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    @Published var cameraError: String?
    @Published var isScanning = false
    @Published var productInfo: [String: Any]?
    @Published var apiError: String?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    func setupSession() -> AVCaptureVideoPreviewLayer? {
        // Initialize session
        captureSession = AVCaptureSession()

        // Configure camera
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            cameraError = "Camera not available or failed to configure input."
            return nil
        }

        // Add input to session
        if let session = captureSession, session.canAddInput(videoDeviceInput) {
            session.addInput(videoDeviceInput)
        } else {
            cameraError = "Failed to add camera input."
            return nil
        }

        // Configure metadata output
        let metadataOutput = AVCaptureMetadataOutput()
        if let session = captureSession, session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417] // Search for barcode types .ean8, .ean13, .pdf417
            // EAN-8: A short barcode commonly used for small items
            // EAN-13: A standard barcode used for products.
            // PDF417: A stacked linear barcode format used for things like IDs.
        } else {
            cameraError = "Failed to add metadata output."
            return nil
        }

        // Configure preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        return previewLayer
    }

    func startScanning() {
        guard let session = captureSession else { return }
        isScanning = true

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    func stopScanning() {
        guard let session = captureSession else { return }
        isScanning = false

        DispatchQueue.global(qos: .userInitiated).async {
            session.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            DispatchQueue.main.async {
                // Here, the camera detects barcode and scannedCode is updated. Should display product details and counts as a "search"
                self.scannedCode = stringValue
            }
            stopScanning() // Optional: Stop scanning after finding a code
        }
    }

    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            cameraError = "Camera access denied. Please enable it in Settings."
            completion(false)
        }
    }
}
