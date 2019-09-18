//
//  ECURLBuilder.swift
//  ECom
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import Alamofire

public final class GhostURLBuilder {
    
    class func bookingBaseURL(_ config: SPAPIConfig) -> String {
        return config.bookingURL + "/custom-fitting/stores" // + "/" + config.env
    }
    
    //GOLF
    class func golfClubsURL(_ config: SPAPIConfig) -> String {
        return config.baseURL + SPPaths.golfClubs
    }
    
    class func golfCoursesURL(_ config: SPAPIConfig, club: SPGolfClub?) -> String {
        if club != nil {
            return config.baseURL + SPPaths.golfClubs + "/" + club!.facilityID + SPPaths.golfCourses
        }
        return config.baseURL + SPPaths.golfCourses
    }
    
    class func golfTeesURL(_ config: SPAPIConfig, course: SPGolfCourse?) -> String {
        if course != nil {
            return config.baseURL + SPPaths.golfCourses + "/" + course!.courseID + SPPaths.golfTees
        }
        return config.baseURL + SPPaths.golfTees
    }
    
    //Feed
    class func newsFeedURL(_ config: SPAPIConfig, item: SPFeedItem?) -> String {
        if item != nil {
           return config.baseURL + SPPaths.news + "/" + item!.id
        }
        return config.baseURL + SPPaths.news
    }
    
    //Weather
    class func weatherURL(_ config: SPAPIConfig) -> String {
        return config.openWeatherMapBaseURL + SPPaths.weather
    }
    
    class func forecastURL(_ config: SPAPIConfig) -> String {
        return config.openWeatherMapBaseURL + SPPaths.forecast
    }
    
    //Chat
    class func chatAssetUploadURL(_ config: SPAPIConfig) -> String {
        return config.baseURL + SPPaths.chat
    }
    
    //Bookings
    class func appointmentStoresURL(_ config: SPAPIConfig) -> String {
        return SPURLBuilder.bookingBaseURL(config)
    }
    
    class func appointmentStoreURL(_ config: SPAPIConfig, id: String) -> String {
        return SPURLBuilder.bookingBaseURL(config) + "/\(id)"
    }
    
    class func appointmentBookingURL(_ config: SPAPIConfig, store: SPBookingStore) -> String {
        return SPURLBuilder.bookingBaseURL(config) + "/\(store.id)" + SPPaths.bookings
    }
    
    class func appointmentTimesURL(_ config: SPAPIConfig, store: SPBookingStore) -> String {
        return SPURLBuilder.bookingBaseURL(config) + "/\(store.id)" + SPPaths.availability
    }
}

public final class SPParmetersBuilder {
    //Navigation
    class func bookingAppointmentParameters(_ date: Date, type: String) -> Parameters {
        return ["date": "date", "appointmentTypeId": type]
    }
}

struct SPPaths {
    //static let dev = "/dev"
    static let golfClubs = "/golf-clubs"
    static let golfCourses = "/golf-courses"
    static let golfTees = "/golf-tees"
    static let news = "/news"
    static let weather = "/weather"
    static let forecast = "/forecast"
    static let chat = "/chat"
    static let bookings = "/bookings"
    static let availability = "/availability"
}
