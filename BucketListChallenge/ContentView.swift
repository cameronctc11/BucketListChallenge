//
//  ContentView.swift
//  BucketListChallenge
//
//  Created by McKenzie, Cameron - Student on 10/21/25.
//


import SwiftUI
import MapKit

struct Attraction: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
    let icon: String
    
    func distance(from cityCenter: CLLocationCoordinate2D) -> Double {
        let attractionLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let cityLoc = CLLocation(latitude: cityCenter.latitude, longitude: cityCenter.longitude)
        let meters = cityLoc.distance(from: attractionLoc)
        return meters / 1609.34
    }
}

struct ContentView: View {
    let cityName = "New Orleans"
    let cityCenter = CLLocationCoordinate2D(latitude: 29.95583, longitude: -90.06526)
    
    let attractions: [Attraction] = [
        Attraction(
            name: "French Quarter",
            coordinate: CLLocationCoordinate2D(latitude: 29.95583, longitude: -90.06526),
            description: "The historic heart of New Orleans – music, food, and old-world charm.",
            icon: "building.columns"
        ),
        Attraction(
            name: "Café Du Monde",
            coordinate: CLLocationCoordinate2D(latitude: 29.95763, longitude: -90.06175),
            description: "Iconic café known for beignets and café au lait.",
            icon: "cup.and.saucer"
        ),
        Attraction(
            name: "New Orleans Historic Voodoo Museum",
            coordinate: CLLocationCoordinate2D(latitude: 29.95980, longitude: -90.06390),
            description: "A small museum exploring voodoo’s culture and folklore.",
            icon: "wand.and.stars"
        ),
        Attraction(
            name: "Cajun Encounters",
            coordinate: CLLocationCoordinate2D(latitude: 30.03217, longitude: -89.92707),
            description: "Tour company offering swamp, city, and plantation adventures.",
            icon: "bus"
        ),
        Attraction(
            name: "New Orleans Ghost Adventures Tours",
            coordinate: CLLocationCoordinate2D(latitude: 29.95642, longitude: -90.06291),
            description: "Chilling haunted tour featuring authentic ghost stories.",
            icon: "ghost"
        )
    ]
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 29.95583, longitude: -90.06526),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @State private var selectedAttraction: Attraction? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                ForEach(attractions) { attraction in
                    Annotation(attraction.name, coordinate: attraction.coordinate) {
                        Button {
                            selectedAttraction = attraction
                            withAnimation(.easeInOut) {
                                position = .region(
                                    MKCoordinateRegion(
                                        center: attraction.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    )
                                )
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: attraction.icon)
                                    .font(.title2)
                                    .padding(8)
                                    .background(Color.indigo.opacity(0.9))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                Text(attraction.name)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(4)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text(cityName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(attractions) { attraction in
                            Button {
                                selectedAttraction = attraction
                                withAnimation(.easeInOut) {
                                    position = .region(
                                        MKCoordinateRegion(
                                            center: attraction.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        )
                                    )
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    Text(attraction.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(String(format: "%.2f mi", attraction.distance(from: cityCenter)))
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(8)
                                .background(Color.indigo.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 40)
        }
        .sheet(item: $selectedAttraction) { attraction in
            VStack(spacing: 20) {
                Text(attraction.name)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(String(format: "Distance from city center: %.2f miles", attraction.distance(from: cityCenter)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(attraction.description)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Close") {
                    selectedAttraction = nil
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
            .presentationDetents([.medium])
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

