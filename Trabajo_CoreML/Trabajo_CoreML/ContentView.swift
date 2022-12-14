//
//  ContentView.swift
//  Trabajo_CoreML
//
//  Created by Antonio González Capel on 8/12/22.
//

import SwiftUI
import CoreML

var colorfondo = Color(red: 48/255, green: 49/255, blue: 54/255)
var colorboton = Color(red: 73/255, green: 82/255, blue: 189/255)
var colorcajon = Color(red: 65/255, green: 68/255, blue: 74/255)

struct ContentView: View {
    let model = MobileNetV2()
    @State private var clasificacion: String = ""
    
    let imagenes = ["chinchilla", "gato", "perro", "te", "arbol", "nino", "autobus", "camaleon"]
    @State private var currentIndex: Int = 0
    
    private func clasificarImagen(){
        let currentImageName = imagenes[currentIndex]
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeImageTo(size: CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
        
        if let output = output {
                // 1
                let results = output.classLabelProbs.sorted { $0.1 > $1.1 }

                // 2
                let result = results.map { (key, value) in
                    return "\(key) = \(String(format: "%.2f", value * 100))%"
                }.joined(separator: "\n")

                // 3
                self.clasificacion = result
            }
    }
    
    var body: some View {
        Color(red: 48/255, green: 49/255, blue: 54/255)
            .ignoresSafeArea()
            .overlay(
        VStack {
            Text("Clasificador MobileNetv2")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                //.padding()
            Image(imagenes[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 350)
               
            HStack{
                Button("Atrás"){
                    if self.currentIndex == 0     {
                        self.currentIndex = self.imagenes.count - 1
                    }else {
                        self.currentIndex = self.currentIndex - 1   
                    }
                    clasificacion = ""
                }.frame(width: 100, height: 50)
                    .background(colorboton)
                    .foregroundColor(.white)
                    .bold()
                    .cornerRadius(10)
                
                Button("Siguiente"){
                    if self.currentIndex < self.imagenes.count - 1 {
                        self.currentIndex = self.currentIndex + 1
                    }else {
                        self.currentIndex = 0
                    }
                    clasificacion = ""
                }.frame(width: 100, height: 50)
                    .background(colorboton)
                    .foregroundColor(.white)
                    .bold()
                    .cornerRadius(10)
                
            }
            
            Button("Clasificar"){
                clasificarImagen()
            }.frame(width: 100, height: 50)
                .background(clasificacion.count != 0 ? .red : .green)
                .foregroundColor(.white)
                .bold()
                .cornerRadius(10)
            
            VStack{
                HStack{
                    Text("\(clasificacion)")
                        .foregroundColor(.white)
                }
                    .padding()
            }.background(clasificacion.count != 0 ? colorcajon : colorfondo)
                .cornerRadius(10)
            
            
            Spacer()
        }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
