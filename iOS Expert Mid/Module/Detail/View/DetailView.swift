//
//  DetailView.swift
//  iOS Expert Mid
//
//  Created by Rifqi Alhakim Hariyantoputera on 20/09/23.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var detailVM: DetailViewModel
    @State private var imagePlaceholder: UIImage?
    @State private var imageIsLoading: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack {
                    if let image = imagePlaceholder {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 80)
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                    if imageIsLoading {
                        ProgressView()
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width, height: 250)
                
                .background(.white)
                
                VStack(alignment: .leading) {
                    Text(detailVM.place.name)
                        .font(.system(.title, design: .rounded, weight: .bold))
                    
                    Text(detailVM.place.address)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .lineLimit(1)
                    
                    HStack(spacing: 0) {
                        Image(systemName: "mappin")
                        Text("\(detailVM.place.latitude), \(detailVM.place.longitude)")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    .padding(.top, 1)
                }
                .multilineTextAlignment(.leading)
                .padding(.all, 10)
                
                VStack(alignment: .leading) {
                    Text(detailVM.place.description)
                }
                .padding(.horizontal, 10)
            }
        }
        .onAppear {
            detailVM.getUIImageFromString(detailVM.place.image) { image in
                if let image = image {
                    self.imagePlaceholder = image
                    self.imageIsLoading = false
                } else {
                    self.imageIsLoading = false
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if detailVM.isFavorite {
                        detailVM.deleteFavPlace(detailVM.place)
                    } else {
                        detailVM.addFavPlace(detailVM.place)
                    }
                    detailVM.checkIsFavorite(detailVM.place)
                } label: {
                    Image(systemName: detailVM.isFavorite ? "bookmark.fill" : "bookmark")
                }
            }
        }
        .onAppear {
            self.detailVM.checkIsFavorite(self.detailVM.place)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
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
            DetailView(
                detailVM: DetailViewModel(
                    detailUseCase: Injection.init().provideDetail(place)
                )
            )
        }
    }
}
