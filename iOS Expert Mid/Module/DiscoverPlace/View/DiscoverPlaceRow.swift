//
//  DiscoverPlaceRow.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import SwiftUI

struct DiscoverPlaceRow: View {
    
    var place: Place
    @State private var imagePlaceholder: UIImage?
    @State private var imageIsLoading: Bool = true
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                if let image = imagePlaceholder {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                } else {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(.all, 30)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .foregroundColor(Color.black.opacity(0.6))
                }
                if imageIsLoading {
                    ProgressView()
                }
            }
            VStack(alignment: .leading) {
                Text(place.name.description)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text(place.description.description)
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .lineLimit(3)
            }
            .foregroundColor(Color(UIColor.label))
            .multilineTextAlignment(.leading)
        }
        .padding(.all, 15)
        .background(Color.random.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .onAppear {
            getUIImageFromString(place.image) { image in
                if let image = image {
                    self.imagePlaceholder = image
                    self.imageIsLoading = false
                } else {
                    self.imageIsLoading = false
                }
            }
        }
    }
    
    func getUIImageFromString(_ imgUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imgUrl) else { return completion(nil) }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            return
        }
    }
    
}

struct DiscoverPlaceRow_Previews: PreviewProvider {
    static var previews: some View {
        let place: Place = Place(
            id: 2,
            name: "Danau Toba",
            description: "Danau Toba adalah lokasi letusan gunung berapi super masif berkekuatan VEI 8 sekitar 69.000 sampai 77.000 tahun yang lalu yang memicu perubahan iklim global. Metode penanggalan terkini menetapkan bahwa 74.000 tahun yang lalu lebih akurat. Letusan ini merupakan letusan eksplosif terbesar di Bumi dalam kurun 25 juta tahun terakhir. Menurut teori bencana Toba, letusan ini berdampak besar bagi populasi manusia di seluruh dunia; dampak letusan menewaskan sebagian besar manusia yang hidup waktu itu dan diyakini menyebabkan penyusutan populasi di Afrika timur tengah dan India sehingga memengaruhi genetika populasi manusia di seluruh dunia sampai sekarang.",
            address: "Kota Pematang Siantar, Sumatera Utara",
            longitude: 98.8932576,
            latitude: 2.6540427,
            like: 12,
            image: "https://cdn.pixabay.com/photo/2016/12/09/11/51/lake-toba-1894746_960_720.jpg"
        )
        DiscoverPlaceRow(place: place)
    }
}
