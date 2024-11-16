//
//  FeedView.swift
//  B4real
//
//  Created by thaclaw on 11/15/24.
//
import SwiftUI
import ParseSwift

struct FeedView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var posts: [Post] = []
    @State private var loading = false                   

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading posts...")
                } else if posts.isEmpty {
                    Text("No posts available. Upload your first photo!")
                        .font(.headline)
                        .padding()
                } else {
                    List(posts, id: \.objectId) { post in
                        VStack(alignment: .leading, spacing: 10) {
                            // Display post image
                            if let file = post.image {
                                AsyncImage(url: file.url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                    case .failure:
                                        Text("Image failed to load")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }

                            // Display caption
                            Text(post.caption ?? "No caption")
                                .font(.headline)

                            // Display post info
                            HStack {
                                Text("Posted by: \(post.user?.username ?? "Unknown")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Spacer()

                                if let createdAt = post.createdAt {
                                    Text("\(createdAt, formatter: postDateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .onAppear {
                fetchPosts()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Log Out") {
                        logOutUser()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Upload", destination: ContentView())
                }
            }
        }
    }

    // Fetch latest posts
    func fetchPosts() {
        loading = true
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .limit(10)

        query.find { result in
            DispatchQueue.main.async {
                loading = false
                switch result {
                case .success(let fetchedPosts):
                    posts = fetchedPosts
                case .failure(let error):
                    print("Failed to fetch posts: \(error.localizedDescription)")
                }
            }
        }
    }

    // Log out user and update session state
    func logOutUser() {
        sessionManager.logOut()
    }

    // Date formatter for displaying post dates
    var postDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

