//
//  Audio.swift
//  Battleship
//
//  Created by Gabriela Zorzo on 19/03/21.
//

import Foundation
import AVFoundation

class Audio {
var audioPlayer = AVAudioPlayer()

     func playAcertou(){
        //let sound = Bundle.main.path(forResource: "ACERTOU", ofType:"mp3")
        let url = URL(fileURLWithPath: "/Users/gabizorzo/Documents/Academy/NANO CHALLENGE 2/Battleship/Battleship/Sounds/ACERTOU.mp3")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("Error!")
        }
     }
    
    func playErrou(){
      // let sound = Bundle.main.path(forResource: "ERROU", ofType:"mp3")
        let url = URL(fileURLWithPath:"/Users/gabizorzo/Documents/Academy/NANO CHALLENGE 2/Battleship/Battleship/Sounds/ERROU.mp3")

       do {
           audioPlayer = try AVAudioPlayer(contentsOf: url)
           audioPlayer.play()
       } catch {
           print("Error!")
       }
    }
    
    func playOhLoco(){
      // let sound = Bundle.main.path(forResource: "OH-LOCO-MEU_1", ofType:"mp3")
       let url = URL(fileURLWithPath:"/Users/gabizorzo/Documents/Academy/NANO CHALLENGE 2/Battleship/Battleship/Sounds/OH-LOCO-MEU_1.mp3")

       do {
           audioPlayer = try AVAudioPlayer(contentsOf: url)
           audioPlayer.play()
       } catch {
           print("Error!")
       }
    }
    
    func playPegandoFogo(){
      // let sound = Bundle.main.path(forResource: "TA-PEGANDO-FOGO", ofType:"mp3")
        let url = URL(fileURLWithPath:"/Users/gabizorzo/Documents/Academy/NANO CHALLENGE 2/Battleship/Battleship/Sounds/TA-PEGANDO-FOGO.mp3")

       do {
           audioPlayer = try AVAudioPlayer(contentsOf: url)
           audioPlayer.play()
       } catch {
           print("Error!")
       }
    }
}
