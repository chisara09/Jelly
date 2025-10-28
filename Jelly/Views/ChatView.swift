//
//  ChatView.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import SwiftUI

// S-008: Chat – Messages, input box, block/report
struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    let game: Game
    let opponentName: String
    
    @StateObject private var chatManager = ChatManager()
    @StateObject private var safetyManager = SafetyManager.shared
    
    @State private var messageText: String = ""
    @State private var showBlockAlert = false
    @State private var showReportSheet = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showChatError = false
    
    // Mock current user ID - in production this would come from auth
    private let currentUserID = UUID()
    private let currentUserName = "You"
    
    private var messages: [Message] {
        chatManager.getMessages(for: game.id)
    }
    
    private var opponentID: UUID {
        game.opponentID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if messages.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "message.bubble")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary.opacity(0.5))
                                
                                Text("No messages yet")
                                    .foregroundColor(.secondary)
                                
                                Text("Start the conversation!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            ForEach(messages) { message in
                                MessageBubble(
                                    message: message,
                                    isFromCurrentUser: message.senderID == currentUserID
                                )
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            // Input Box
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.orange)
                        .clipShape(Circle())
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle(opponentName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        showBlockAlert = true
                    }) {
                        Label("Block User", systemImage: "person.crop.circle.badge.xmark")
                    }
                    
                    Button(action: {
                        showReportSheet = true
                    }) {
                        Label("Report", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showReportSheet) {
            ReportUserView(playerID: opponentID, playerName: opponentName)
        }
        .alert("Block User", isPresented: $showBlockAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Block", role: .destructive) {
                if let error = safetyManager.blockUser(opponentID) {
                    errorMessage = error
                    showError = true
                } else {
                    // Show confirmation and dismiss
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to block \(opponentName)? You won't be able to communicate with them.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .alert("Error", isPresented: $showChatError) {
            Button("OK") { chatManager.errorMessage = nil }
        } message: {
            Text(chatManager.errorMessage ?? "Message not sent.")
        }
        .onChange(of: chatManager.errorMessage) { _ in
            if chatManager.errorMessage != nil {
                showChatError = true
            }
        }
    }
    
    private func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // Filter bad words before sending
        let filteredText = safetyManager.filterBadWords(trimmedText)
        
        chatManager.sendMessage(
            gameID: game.id,
            senderID: currentUserID,
            senderName: currentUserName,
            text: filteredText
        )
        
        messageText = ""
    }
}

// Message Bubble Component
struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isFromCurrentUser {
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        isFromCurrentUser ?
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [Color(.systemGray5), Color(.systemGray4)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .cornerRadius(18)
                
                Text(message.fullTimestamp)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isFromCurrentUser {
                Spacer(minLength: 60)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(
            game: Game(
                challengerID: UUID(),
                opponentID: UUID(),
                opponentName: "Marcus Johnson",
                courtName: "Central Park Courts",
                courtAddress: "Central Park, NYC",
                scheduledDate: Date(),
                rules: "First to 21"
            ),
            opponentName: "Marcus Johnson"
        )
    }
}


