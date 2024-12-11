//
//  BarcodeScannerView.swift
//  FoodLens
//
//  Created by Harry Ahn on 9/12/2024.
//
import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @EnvironmentObject private var searchHistoryViewModel: SearchHistoryViewModel

    @State private var hasPermission = false
    @State private var scannedProduct: Product?

    var body: some View {
        NavigationStack {
            VStack {
                // Camera Preview
                ZStack {
                    if let cameraError = viewModel.cameraError {
                        Text(cameraError)
                            .foregroundColor(.red)
                            .padding()
                    } else if !hasPermission {
                        VStack {
                            Text("Camera permission is required to use this feature.")
                                .foregroundColor(.red)
                                .padding()
                            Button("Grant Permission") {
                                viewModel.checkCameraPermission { granted in
                                    hasPermission = granted
                                    if granted {
                                        _ = viewModel.setupSession()
                                        viewModel.startScanning()
                                    }
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    } else {
                        if let previewLayer = viewModel.setupSession() {
                            CameraPreview(previewLayer: previewLayer)
                                .onAppear {
                                    viewModel.startScanning()
                                }
                                .onDisappear {
                                    viewModel.stopScanning()
                                }
                        } else {
                            Text("Camera setup failed.")
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(maxHeight: .infinity)

                // Bottom Bar - Search results -> navigation link to product detail page and reset button
                VStack(spacing: 8) {
                    if let product = scannedProduct {
                        Text("Search Results:")
                            .font(.headline)
                            .padding(.vertical)

                        VStack {
                            HStack {
                                SearchItemView(product: product)
                                Spacer()
                                // Chevron Icon
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        .padding()
                        

                        Button(action: resetScanning) {
                            Text("Reset")
                                .font(.body)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    } else {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .font(.title2) // Adjust size as needed for the icon
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Scan a barcode to get started.")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text("If a barcode is successfully read in the camera feed, results will automatically pop up here.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
            }
            .onAppear {
                viewModel.checkCameraPermission { granted in
                    hasPermission = granted
                    if granted {
                        _ = viewModel.setupSession()
                        viewModel.startScanning()
                    }
                }
            }
            .onChange(of: viewModel.scannedCode) {
                handleScan()
            }
        }
    }

    private func handleScan() {
        if let code = viewModel.scannedCode {
            fetchProductInfo(for: code) { product in
                if let product = product {
                    DispatchQueue.main.async {
                        self.scannedProduct = product
                        // Check if the code is already in the search history
                        let isDuplicate = searchHistoryViewModel.searches.contains { $0.barcode == code }
                        if !isDuplicate {
                            searchHistoryViewModel.addSearch(barcode: product.code, isSaved: false)
                        } else {
                            print("Duplicate scan ignored for barcode: \(code)")
                        }
                    }
                }
            }
        }
    }

    // Resets the scanning process
    private func resetScanning() {
        scannedProduct = nil
        viewModel.scannedCode = nil
        viewModel.startScanning()
    }
}

struct CameraPreview: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        DispatchQueue.main.async {
            self.previewLayer.frame = view.bounds
            view.layer.addSublayer(self.previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            self.previewLayer.frame = uiView.bounds
        }
    }
}
