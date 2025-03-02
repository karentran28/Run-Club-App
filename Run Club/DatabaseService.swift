//
//  DatabaseService.swift
//  Run Club
//
//  Created by Karen Tran on 2025-03-01.
//

import Foundation
import Supabase

struct Table {
    static let workouts = "workouts"
}

struct RunPayload: Identifiable, Codable {
    var id: Int?
    let createdAt: Date
    let userId: UUID
    let distance: Double
    let pace: Double
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case id, distance, pace, time
        case createdAt = "created_at"
        case userId = "user_id"
    }
}

final class DatabaseService {
    
    static let shared = DatabaseService()
    
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseKey)
    
    private init() { }
    
    //CRUD
    
    //Create
    func saveWorkout(run: RunPayload) async throws {
        let _ = try await supabase.from(Table.workouts).insert(run).execute().value
    }
    
    //Reading
    func fetchWorkouts() async throws -> [RunPayload] {
        try await supabase.from(Table.workouts).select().execute().value
    }
    
    
    
}
