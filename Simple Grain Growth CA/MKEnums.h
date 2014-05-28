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
    FurtherMoorNeighborhood,
};

enum ViewStatus {
    addGrain,
    addDislocationCircle,
    addDislocationSquare,
    doNothingView,
    addToSave,
};

enum TransitionRules {
    Rules1,
    Rules1_4,
    Montecarlo,
    Recrystalization,
};

enum ViewType {
    Structure,
    Energy,
};

enum EnergyDystrybution {
    HomogenousInGrain,
    Heterogenous,
    Homogenous,
};

enum AddNucleonsType {
    _one,
    _incrising,
    _decrising,
    _const,
};