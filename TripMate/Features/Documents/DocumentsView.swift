//
//  DocumentsView.swift
//  TripMate
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct DocumentsView: View {
    @Environment(\.modelContext) private var ctx
    @Bindable var trip: Trip
    @State private var showPicker = false

    var body: some View {
        ZStack(alignment: .bottom) {
            GradientBackground()

            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(trip.documents) { doc in
                            VStack(spacing: 8) {
                                Image(systemName: "doc.richtext")
                                    .font(.system(size: 44))
                                Text(doc.title)
                                    .font(.footnote)
                                    .lineLimit(1)
                                    .frame(maxWidth: 140)
                            }
                            .padding()
                            .frame(width: 160, height: 140)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.twCard)
                            )
                            .contextMenu {
                                Button(role: .destructive) {
                                    ctx.delete(doc)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 180)

                Spacer(minLength: 0)
            }

            FloatingAddButton(
                titleText: NSLocalizedString("add_document", comment: ""),
                icon: "plus"
            ) {
                showPicker = true
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .fileImporter(
            isPresented: $showPicker,
            allowedContentTypes: [UTType.pdf, UTType.image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                // tek URL’yi al
                guard let url = urls.first,
                      let data = try? Data(contentsOf: url) else { return }

                let doc = TripDocument(
                    tripID: trip.id,
                    title: url.deletingPathExtension().lastPathComponent,
                    fileName: url.lastPathComponent,
                    fileData: data
                )
                trip.documents.append(doc)

            case .failure(let error):
                print("File import failed:", error.localizedDescription)
            }
        }
    }
}
