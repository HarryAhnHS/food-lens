import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @StateObject private var viewModel = BarcodeScannerViewModel()
    @EnvironmentObject private var searchHistoryViewModel : SearchHistoryViewModel
    
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

                // Bottom Bar
                VStack {
                    if let product = scannedProduct {
                        HStack {
                            if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                            } else {
                                Text("No Image Available")
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading) {
                                if let productName = product.productName {
                                    Text(productName)
                                        .font(.title)
                                        .bold()
                                }
                                if let brands = product.brands {
                                    Text(brands)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }
                            Spacer()
                            NavigationLink(destination: ProductDetailsView(product: product)) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    } else {
                        Text("Scan a barcode to get started.")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    Button(action: resetScanning) {
                        Text("Reset and Keep Scanning")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color(UIColor.secondarySystemBackground))
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
                if let code = viewModel.scannedCode {
                    // Check if the code is already in the search history
                    let isDuplicate = searchHistoryViewModel.searches.contains { $0.barcode == code }
                    if (!isDuplicate) {
                        fetchProductInfo(for: code) { product in
                            if let product = product {
                                DispatchQueue.main.async {
                                    self.scannedProduct = product
                                    // Here I need to update searchHistoryViewModel env object to include the add the product into search history
                                    
                                    searchHistoryViewModel.addSearch(barcode: product.code, isSaved: false)
                                }
                            }
                        }
                    }
                    else {
                        print("Duplicate scan ignored for barcode: \(code)")
                    }
                }
            }
        }
    }

    // Resets the scanning process
    private func resetScanning() {
        scannedProduct = nil
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
