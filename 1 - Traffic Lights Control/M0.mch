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
    & ran(TRANSITIONS[gs]) /\ (dom(TRANSITIONS[gs]) - ran(TRANSITIONS[gs])) = {}
    & PEDESTRIAN_CROSSINGS[gpc] /\ gs = {}

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
        gs := gs \/ {S1, S3} || rs := rs - {S1, S3} || gpc := gpc - PEDESTRIAN_CROSSINGS~[{S1, S3}] || rpc := rpc \/ PEDESTRIAN_CROSSINGS~[{S1, S3}]
    END;
    
    red_to_green2 = // set S2 and S4 to green
    PRE
        {S2, S4} <: rs & S1 /: gs & S3 /: gs & os = {}
    THEN
        gs := gs \/ {S2, S4} || rs := rs - {S2, S4} || gpc := gpc - PEDESTRIAN_CROSSINGS~[{S2, S4}] || rpc := rpc \/ PEDESTRIAN_CROSSINGS~[{S2, S4}]
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
