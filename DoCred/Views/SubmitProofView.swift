import SwiftUI
import SwiftData
import PhotosUI

struct SubmitProofView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var chores: [Chore]
    @State private var selectedChore: Chore?
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var comment = ""
    @State private var showingImagePicker = false
    @State private var showingSuccessAlert = false
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    choreSelectionSection
                    proofUploadSection
                    commentSection
                    submitButtonSection
                }
                .padding()
            }
            .navigationTitle("Submit Proof")
            .navigationBarTitleDisplayMode(.large)
        }
        .onChange(of: selectedImage) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
        .alert("Proof Submitted!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                resetForm()
            }
        } message: {
            Text("Your proof has been submitted and is pending verification.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Submit Proof")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Take a photo or video to prove you completed your chore")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
    
    private var choreSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Chore")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(availableChores) { chore in
                        ChoreSelectionCard(
                            chore: chore,
                            isSelected: selectedChore?.id == chore.id,
                            action: { selectedChore = chore }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var proofUploadSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upload Proof")
                .font(.headline)
            
            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                    
                    Button("Remove Photo") {
                        selectedImageData = nil
                        selectedImage = nil
                    }
                    .foregroundColor(.red)
                    .font(.caption)
                }
            } else {
                PhotosPicker(selection: $selectedImage, matching: .images) {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        Text("Tap to select photo")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    )
                }
            }
        }
    }
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comment (Optional)")
                .font(.headline)
            
            TextField("Add a note about your chore completion...", text: $comment, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
        }
    }
    
    private var submitButtonSection: some View {
        Button(action: submitProof) {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "paperplane.fill")
                }
                Text(isSubmitting ? "Submitting..." : "Submit Proof")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(canSubmit ? Color.blue : Color.gray)
            .cornerRadius(12)
        }
        .disabled(!canSubmit || isSubmitting)
        .padding(.top)
    }
    
    private var availableChores: [Chore] {
        chores.filter { !$0.isCompleted }
    }
    
    private var canSubmit: Bool {
        selectedChore != nil && selectedImageData != nil
    }
    
    private func submitProof() {
        guard let chore = selectedChore, let imageData = selectedImageData else { return }
        
        isSubmitting = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let proof = ProofSubmission(
                id: UUID().uuidString,
                choreId: chore.id,
                userId: "current-user-id"
            )
            proof.comment = comment.isEmpty ? nil : comment
            // In a real app, you'd upload the image to cloud storage
            // and store the URL in imageURL
            
            modelContext.insert(proof)
            
            isSubmitting = false
            showingSuccessAlert = true
        }
    }
    
    private func resetForm() {
        selectedChore = nil
        selectedImage = nil
        selectedImageData = nil
        comment = ""
    }
}

struct ChoreSelectionCard: View {
    let chore: Chore
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(chore.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(chore.points) pts")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                Text(chore.choreDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(chore.dueDate, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 200)
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SubmitProofView()
        .modelContainer(for: [Chore.self, ProofSubmission.self], inMemory: true)
} 