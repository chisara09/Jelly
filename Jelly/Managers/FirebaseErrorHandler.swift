//
//  FirebaseErrorHandler.swift
//  Jelly
//
//  Created by Godfrey Chisara Ojiako on 10/26/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

/// Utility class for handling Firebase errors and converting them to user-friendly messages
class FirebaseErrorHandler {
    
    /// Converts a Firebase error to a user-friendly message
    /// - Parameter error: The error to convert
    /// - Returns: A user-friendly error message string
    static func userFriendlyMessage(for error: Error) -> String {
        let nsError = error as NSError
        
        // Handle Firebase Auth errors
        if nsError.domain == "FIRAuthErrorDomain" {
            if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
                return authErrorMessage(for: authErrorCode)
            }
        }
        
        // Handle Firestore errors
        if nsError.domain == "FIRFirestoreErrorDomain" {
            if let code = FirestoreErrorCode.Code(rawValue: nsError.code) {
                return firestoreErrorMessage(for: code)
            }
        }
        
        // Check for Storage error codes
        if nsError.domain == "FIRStorageErrorDomain" {
            return storageErrorMessage(for: nsError)
        }
        
        // Generic error message
        let errorMessage = nsError.localizedDescription
        
        // Map common error codes to user-friendly messages
        switch nsError.code {
        case -1009: // No internet connection
            return "No internet connection. Please check your network and try again."
        case -1001: // Request timeout
            return "Request timed out. Please try again."
        case -1004: // Cannot connect to host
            return "Unable to connect. Please check your internet connection."
        case 401:
            return "You need to be logged in to perform this action."
        case 403:
            return "You don't have permission to perform this action."
        case 404:
            return "The requested item could not be found."
        default:
            // Return original error message if it's already user-friendly
            if !errorMessage.isEmpty && errorMessage.count < 200 {
                return errorMessage
            }
            return "An error occurred. Please try again."
        }
    }
    
    // MARK: - Firebase Auth Error Messages
    
    private static func authErrorMessage(for errorCode: AuthErrorCode) -> String {
        switch errorCode {
        case .emailAlreadyInUse:
            return "This email is already registered. Please use a different email or try logging in."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password is too weak. Please use at least 6 characters."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .userNotFound:
            return "No account found with this email. Please check your email or sign up."
        case .userDisabled:
            return "This account has been disabled. Please contact support."
        case .tooManyRequests:
            return "Too many failed attempts. Please try again later."
        case .networkError:
            return "Network error. Please check your connection and try again."
        case .invalidCredential:
            return "Invalid email or password. Please try again."
        case .requiresRecentLogin:
            return "Please log in again to complete this action."
        default:
            return "Authentication error. Please try again."
        }
    }
    
    // MARK: - Firestore Error Messages
    
    private static func firestoreErrorMessage(for errorCode: FirestoreErrorCode.Code) -> String {
        switch errorCode {
        case .notFound:
            return "The requested item could not be found."
        case .permissionDenied:
            return "You don't have permission to perform this action. Please check your account settings."
        case .unavailable:
            return "Service is temporarily unavailable. Please check your internet connection and try again."
        case .invalidArgument:
            return "Invalid data provided. Please check your input and try again."
        case .deadlineExceeded:
            return "Request took too long. Please try again."
        case .alreadyExists:
            return "This item already exists."
        case .resourceExhausted:
            return "Too many requests. Please wait a moment and try again."
        case .failedPrecondition:
            return "Operation cannot be completed. Please try again."
        case .aborted:
            return "Operation was cancelled. Please try again."
        case .outOfRange:
            return "Invalid data range. Please check your input."
        case .unimplemented:
            return "This feature is not yet available."
        case .internal:
            return "An internal error occurred. Please try again."
        case .unauthenticated:
            return "You need to be logged in to perform this action."
        case .dataLoss:
            return "Data error occurred. Please try again."
        case .cancelled:
            return "Operation was cancelled."
        @unknown default:
            return "An error occurred. Please try again."
        }
    }
    
    // MARK: - Storage Error Messages
    
    private static func storageErrorMessage(for error: NSError) -> String {
        // Firebase Storage error codes
        switch error.code {
        case -13000: // Object not found
            return "The file could not be found."
        case -13010: // Unauthorized
            return "You don't have permission to access this file."
        case -13011: // Unauthenticated
            return "You need to be logged in to upload files."
        case -13020: // Retry limit exceeded
            return "Upload failed. Please check your connection and try again."
        case -13021: // Invalid checksum
            return "File upload failed. Please try again."
        case -13030: // Canceled
            return "Upload was cancelled."
        case -13031: // Invalid URL
            return "Invalid file URL."
        case -13040: // Invalid argument
            return "Invalid file. Please select a different file."
        case -13041: // No default bucket
            return "Storage service is not configured. Please contact support."
        case -13050: // Unavailable
            return "Storage service is temporarily unavailable. Please try again later."
        case -13051: // Out of range
            return "File size is too large. Please select a smaller file."
        default:
            return "File upload error. Please try again."
        }
    }
    
    /// Logs error details for debugging (only in debug builds)
    /// - Parameters:
    ///   - error: The error to log
    ///   - context: Additional context about where the error occurred
    static func logError(_ error: Error, context: String) {
        #if DEBUG
        let nsError = error as NSError
        print("❌ Firebase Error [\(context)]:")
        print("   Domain: \(nsError.domain)")
        print("   Code: \(nsError.code)")
        print("   Description: \(nsError.localizedDescription)")
        if let userInfo = nsError.userInfo as? [String: Any], !userInfo.isEmpty {
            print("   UserInfo: \(userInfo)")
        }
        #endif
    }
}
