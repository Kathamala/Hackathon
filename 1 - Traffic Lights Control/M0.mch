MACHINE
    M0
SEES 
    CTX
VARIABLES
    rs, /* red signals */
    os, /* orange signals */
    gs, /* green signals */
    bs, /* blinking (orange signals) */
    offs, /* off signals */
    rpc, /* red pedestrian signals */
    gpc, /* green pedestrian signals */
    offspc /* off pedestrian signals */
INVARIANT
    rs <: SIGNALS &
    os <: SIGNALS &
    gs <: SIGNALS &
    bs <: SIGNALS &
    offs <: SIGNALS &
    rpc <: PEDESTRIAN_SIGNALS &
    gpc <: PEDESTRIAN_SIGNALS &
    offspc <: PEDESTRIAN_SIGNALS &
    (bs = SIGNALS or bs ={}) & /* all blinking or none blinking */
    rs \/ os \/ gs \/ bs \/ offs = SIGNALS & /* coherency */
    rs /\ os /\ gs /\ bs /\ offs = {} /* coherency */ &
    rpc \/ gpc \/ offspc = PEDESTRIAN_SIGNALS & rpc /\ gpc /\ offspc = {}
    & not(S1 : gs & S4 : gs)
    & not(S1 : gs & S2 : gs)
    & not(S1 : gs & S2 : gs)
    & not(S2 : gs & S3 : gs)
    & not(S3 : gs & S4 : gs)
    & ((S1 : gs or S3 : gs) => ({PC1, PC3} <: rpc))
    & ((S2 : gs or S4 : gs) => ({PC2, PC4} <: rpc))

INITIALISATION
    rs := {} ||
    os := {} ||
    gs := {} ||
    bs := SIGNALS ||
    offs := {} ||
    rpc := PEDESTRIAN_SIGNALS ||
    gpc := {} ||
    offspc := {}
    
OPERATIONS
    reset_turn_on = /* no precondition, all signals on orange blinking */
    PRE offs = SIGNALS
    THEN
        rs := {} ||
        os := {} ||
        gs := {} ||
        bs := SIGNALS ||
        offs := {} ||
        rpc := PEDESTRIAN_SIGNALS ||
        gpc := {} ||
        offspc := {}
    END;
    
    start_exploitation = /* moving from all blinking to all orange */
    PRE 
        bs = SIGNALS
    THEN
        bs := {} || os := SIGNALS
    END;
    
    orange_to_red = /* moving from all orange to all red */
    PRE 
        os /= {}
    THEN
        os := {} || rs := rs \/ os || gpc := PEDESTRIAN_SIGNALS || rpc := {}
    END;
    
    red_to_green1 = // set S1 and S3 to green
    PRE
        {S1, S3} <: rs & S2 /: gs & S4 /: gs & os = {}
    THEN
        gs := gs \/ {S1, S3} || rs := rs - {S1, S3} || gpc := gpc - {PC1, PC3} || rpc := rpc \/ {PC1, PC3}
    END;
    
    red_to_green2 = // set S2 and S4 to green
    PRE
        {S2, S4} <: rs & S1 /: gs & S3 /: gs & os = {}
    THEN
        gs := gs \/ {S2, S4} || rs := rs - {S2, S4} || gpc := gpc - {PC2, PC4} || rpc := rpc \/ {PC2, PC4}
    END;
    
    green_to_orange = // Set green signals to orange
    PRE
        gs /= {}
    THEN
        os := os \/ gs || gs := {}
    END;

    turn_off = // Turn off all signals
    PRE offs /= SIGNALS
    THEN offs := SIGNALS || gs := {} || bs := {} || os := {} ||  rs := {} || gpc := {} || rpc := {} || offspc := PEDESTRIAN_SIGNALS
    END
    
END
