//
//  SupabaseService.swift
//  EduFood_Kelompok7
//
//  Created by Nicholas Leroy Kurniawan on 28/05/26.
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "masukan supabase urlmu")!,
            supabaseKey: "masukan supabase keymu"
        )
    }
}
