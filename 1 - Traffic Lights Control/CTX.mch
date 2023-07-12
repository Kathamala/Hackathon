MACHINE
    CTX
SETS
    LANES = {L1, L2, L3, L4};
    SIGNALS = {S1, S2, S3, S4};
    PEDESTRIAN_SIGNALS = {PC1, PC2, PC3, PC4}
CONSTANTS
    INTERSECT_LANES,
    TRANSITIONS,
    PEDESTRIAN_CROSSINGS
    
PROPERTIES
    INTERSECT_LANES <: LANES * LANES &
    TRANSITIONS : SIGNALS <-> ( LANES * LANES ) &
    PEDESTRIAN_CROSSINGS : PEDESTRIAN_SIGNALS <-> SIGNALS &    
    INTERSECT_LANES = { 
        L1 |-> L2, L1 |-> L4, 
        L2 |-> L1, L2 |-> L3, 
        L3 |-> L2, L3 |-> L4, 
        L4 |-> L1, L4 |-> L3} &
    TRANSITIONS = {
        S1 |-> (L1 |-> L1),
        S1 |-> (L1 |-> L4),
        S2 |-> (L2 |-> L2),
        S2 |-> (L2 |-> L1),
        S3 |-> (L3 |-> L3),
        S3 |-> (L3 |-> L2),
        S4 |-> (L4 |-> L4),
        S4 |-> (L4 |-> L3)
    } &
    PEDESTRIAN_CROSSINGS = {
        PC1 |-> S1,
        PC2 |-> S2,
        PC3 |-> S3,
        PC4 |-> S4
    }
END
