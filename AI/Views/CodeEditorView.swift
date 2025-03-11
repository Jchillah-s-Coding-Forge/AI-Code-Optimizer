//
//  CodeEditorView.swift
//  AI
//
//  Created by Michael Winkler on 11.03.25.
//

import SwiftUI

struct CodeEditorView: View {
    @ObservedObject var viewModel = CodeEditorViewModel()
    @State private var showDocumentPicker = false
    @State private var showWebView: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: viewModel.optimizeCode) {
                    Label("Optimize", systemImage: "wand.and.stars")
                }
                .frame(width: 50, height: 70)
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isOptimizing)
                
                Button(action: { showWebView.toggle() }) {
                    Label("Preview", systemImage: "eye")
                }
                .buttonStyle(.bordered)
                
                .buttonStyle(.bordered)
                .disabled(viewModel.previousVersions.isEmpty)
                
                Button(action: viewModel.saveToFile) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.bordered)
                
                Button(action: { showDocumentPicker.toggle() }) {
                    Label("Open", systemImage: "folder")
                }
                .buttonStyle(.bordered)
            }
            
            CodeTextEditor(code: $viewModel.code, previousVersions: $viewModel.previousVersions)

            if viewModel.isOptimizing {
                ProgressView("Optimizing...")
            } else {
                Text("Optimized Code:")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView {
                    Text(viewModel.optimizedCode)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(height: 150)
            }
        }
        .padding()
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPickerView(selectedFileURL: $viewModel.selectedFileURL, code: $viewModel.code)
        }
        .sheet(isPresented: $showWebView) {
            WebView(htmlString: viewModel.code)
        }
    }
}

#Preview {
    CodeEditorView()
}


//struct CodeEditorView: View {
//    @ObservedObject var viewModel = CodeEditorViewModel()
//    @State private var showWebView: Bool = false
//
//    var body: some View {
//        VStack(spacing: 10) {
//            HStack {
//                Button(action: viewModel.optimizeCode) {
//                    Label("Optimize", systemImage: "wand.and.stars")
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(viewModel.isOptimizing)
//                
//                Button(action: { showWebView.toggle() }) {
//                    Label("Preview", systemImage: "eye")
//                }
//                .buttonStyle(.bordered)
//                
//                Button(action: viewModel.undoLastChange) {
//                    Label("Undo", systemImage: "arrow.uturn.backward")
//                }
//                .buttonStyle(.bordered)
//                .disabled(viewModel.previousVersions.isEmpty)
//                
//                Button(action: viewModel.saveToFile) {
//                    Label("Save", systemImage: "square.and.arrow.down")
//                }
//                .buttonStyle(.bordered)
//            }
//            
//            CodeTextEditor(code: $viewModel.code, previousVersions: $viewModel.previousVersions)
//
//            if viewModel.isOptimizing {
//                ProgressView("Optimizing...")
//            } else {
//                Text("Optimized Code:")
//                    .font(.headline)
//                    .padding(.top)
//                
//                ScrollView {
//                    Text(viewModel.optimizedCode)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(8)
//                }
//                .frame(height: 150)
//            }
//        }
//        .padding()
//        .sheet(isPresented: $showWebView) {
//            WebView(htmlString: viewModel.code)
//        }
//    }
//}
//
//#Preview {
//    CodeEditorView()
//}

