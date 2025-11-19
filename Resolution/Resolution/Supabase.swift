//
//  Supabase.swift
//  Resolution
//
//  Created by June Eguilos on 11/18/25.
//

import Foundation
import Supabase

// Read environment variables from .env file or bundle
func getEnvironmentVariable(_ name: String) -> String? {
    return ProcessInfo.processInfo.environment[name] ?? Bundle.main.object(forInfoDictionaryKey: name) as? String
}

guard let supabaseURL = getEnvironmentVariable("SUPABASE_URL"),
      let supabaseAnonKey = getEnvironmentVariable("SUPABASE_ANON_KEY") else {
    fatalError("Supabase URL and Anon Key must be provided in .env file or Info.plist")
}

let supabase = SupabaseClient(
    supabaseURL: URL(string: supabaseURL)!,
    supabaseKey: supabaseAnonKey
)
