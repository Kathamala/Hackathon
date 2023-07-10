MACHINE
    M0
SEES 
    CTX
VARIABLES
    rs, /* red signals */
    os, /* orange signals */
    gs, /* green signals */
    bs, /* blinking (orange signals) */
    offs /* off signals */
INVARIANT
    rs <: SIGNALS &
    os <: SIGNALS &
    gs <: SIGNALS &
    bs <: SIGNALS &
    offs <: SIGNALS &
    (bs = SIGNALS or bs ={}) & /* all blinking or none blinking */
    rs \/ os \/ gs \/ bs \/ offs = SIGNALS & /* coherency */
    rs /\ os /\ gs /\ bs /\ offs = {} /* coherency */
    & not(S1 : gs & S4 : gs)
    & not(S1 : gs & S2 : gs)
    & not(S1 : gs & S2 : gs)
    & not(S2 : gs & S3 : gs)
    & not(S3 : gs & S4 : gs)

INITIALISATION
    rs := {} ||
    os := {} ||
    gs := {} ||
    bs := SIGNALS ||
    offs := {}
    
OPERATIONS
    reset_turn_on = /* no precondition, all signals on orange blinking */
    PRE offs = SIGNALS
    THEN
        rs := {} ||
        os := {} ||
        gs := {} ||
        bs := SIGNALS ||
        offs := {}
    END;
    
    start_exploitation = /* moving from all blinking to all orange */
    PRE 
        bs = SIGNALS
    THEN
        bs := {} || os := SIGNALS
    END;
    
    orange_to_red = /* moving from all orange to all red */
    PRE 
        os = SIGNALS
    THEN
        os := {} || rs := SIGNALS
    END;
    
    red_to_green1 = // set S1 and S3 to green
    PRE
        {S1, S3} <: rs & S2 /: gs & S4 /: gs & os = {}
    THEN
        gs := gs \/ {S1, S3} || rs := rs - {S1, S3}
    END;
    
    red_to_green2 = // set S2 and S4 to green
    PRE
        {S2, S4} <: rs & S1 /: gs & S3 /: gs & os = {}
    THEN
        gs := gs \/ {S2, S4} || rs := rs - {S2, S4}
    END;
    
    green_to_orange = // Set green signals to orange
    PRE
        gs /= {}
    THEN
        os := os \/ gs || gs := {}
    END;

    turn_off = // Turn off all signals
    PRE offs /= SIGNALS
    THEN offs := SIGNALS || gs := {} || bs := {} || os := {} ||  rs := {}
    END
    
END
