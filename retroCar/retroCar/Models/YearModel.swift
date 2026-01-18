//
//  YearModel.swift
//  retroCar
//
//  Created by Arpit Verma on 1/18/26.
//

import Foundation
import SwiftUI

struct YearModel : Identifiable {
    let year : String
    let ratroCar : CarModel
    let color : Color
    let id : UUID =  UUID()
    let index: Int
    let user : UserModal = UserModal(fname: "ARPIT", image: "profile1", sname: "VERMA")
    
}

var sampleYear : YearModel = YearModel(year: "1960s", ratroCar: CarModel(carCompany: "CEVROLET", modelName: "CORVETTE", modelCode :"HY461",sizeOfTire :"12.00-20",similarType : "STYEVR1491 STERLING",  wheelSize: "3,0000",similarType2:"K4, 1,000",
                                                                         description: "Sraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stabilitySraction control (TCS) is a stability "),color:Color.theme.cardColor1, index: 0)

var years :[YearModel] = [
    YearModel(year: "1960s", ratroCar: CarModel(carCompany: "CEVROLET", modelName: "CORVETTE", modelCode :"HY461",sizeOfTire :"12.00-20",similarType : "STYEVR1491 STERLING",  wheelSize: "3,0000",similarType2:"K4, 1,000",
                                                description: "Sraction control (TCS) is a stability control feature closely associated with ABS. It allows ) brake actuation pressure to be generated to brake a driven wheel to prevent it spinning when peak adhesion has been lost during acceleration, and thus maintain traction.\n\nCommunication with the engine control unit is essential, so the ESC controller also requests engine torque reduction during a traction control event; thus TCS control is more complicated than ABS control.")
              ,color: Color.theme.cardColor1, index: 0),
    YearModel(year: "1970s", ratroCar: CarModel(carCompany: "PORSHE", modelName: "917K", modelCode :"HY461",sizeOfTire :"12.00-20",similarType : "STYEVR1491 STERLING",  wheelSize: "K4, 1,000",similarType2:"3,000",
                                                description: "Sraction control (TCS) is a stability control feature closely associated with ABS. It allows ) brake actuation pressure to be generated to brake a driven wheel to prevent it spinning when peak adhesion has been lost during acceleration, and thus maintain traction.\n\nCommunication with the engine control unit is essential, so the ESC controller also requests engine torque reduction during a traction control event; thus TCS control is more complicated than ABS control."),color:Color.theme.cardColor2 , index: 1),
    YearModel(year: "1980s", ratroCar: CarModel(carCompany: "BMW", modelName: "M1 PROCAR", modelCode :"HY461",sizeOfTire :"12.00-20",similarType : "STYEVR1491 STERLING",  wheelSize: "K4, 1,000",similarType2:"3,0000",
                                                description: "Sraction control (TCS) is a stability control feature closely associated with ABS. It allows ) brake actuation pressure to be generated to brake a driven wheel to prevent it spinning when peak adhesion has been lost during acceleration, and thus maintain traction.\n\nCommunication with the engine control unit is essential, so the ESC controller also requests engine torque reduction during a traction control event; thus TCS control is more complicated than ABS control."),color:Color.theme.cardColor3 , index: 2),
    YearModel(year: "1980s", ratroCar: CarModel(carCompany: "BMW", modelName: "M1 PROCAR", modelCode :"HY461",sizeOfTire :"12.00-20",similarType : "STYEVR1491 STERLING",  wheelSize: "K4, 1,000",similarType2:"3,0000",
                                                description: "Sraction control (TCS) is a stability control feature closely associated with ABS. It allows ) brake actuation pressure to be generated to brake a driven wheel to prevent it spinning when peak adhesion has been lost during acceleration, and thus maintain traction.\n\nCommunication with the engine control unit is essential, so the ESC controller also requests engine torque reduction during a traction control event; thus TCS control is more complicated than ABS control."),color:Color.theme.cardColor4, index: 3)
    
    
]
