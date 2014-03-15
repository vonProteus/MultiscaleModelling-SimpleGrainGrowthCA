//
//  MKEnums.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

enum BoundaryTypes {
    absorbingBoundaryConditions,
    periodicBoundaryConditions
};

enum NeighborsTypes {
    VonNeumannNeighborhood,
    MoorNeighborhood,
    HexRandom,
    PentaRandom,
    Hex1,
    Hex2,
    Hex3,
    Hex4
};