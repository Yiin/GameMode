
native gpci(playerid, serial[], len);

/*
 * Improved version of CallLocalFunction.
 *
 * Supports strings and arrays better. Variables can be passed by reference (format specifier "v").
 */
stock CallLocalFunctionEx(const function[], const fmat[] = "", GLOBAL_TAG_TYPES:...) {
    new
             func,
             idx,
             temp,
             args = strlen(fmat),
             arg = args,
        bool:packed_format = ispacked(fmat)
    ;
    
    // Get the function's address
    if (-1 != (idx = funcidx(function))) {
        // Load the offset to DAT from the prefix
        #emit LCTRL        1
        
        // Invert it so we have the offset to the prefix from DAT
        #emit NEG
        
        // Copy it to alt for use later
        #emit MOVE.alt
        
        // Add 32 to jump to the offset containing the public function's table
        #emit ADD.C        32
        
        // Read the value there; must be done using LREF because
        // it's outside of the DAT section
        #emit STOR.S.pri   temp
        #emit LREF.S.pri   temp
        
        // Add the value we just loaded to the prefix (that we stored in alt)
        #emit ADD
        
        // Add index * 8 (each entry contains 2 cells - a pointer to the function's name
        // and a pointer to the function itself, relative to COD).
        #emit LOAD.S.alt   idx
        #emit SHL.C.alt    3
        
        // Add that to the offset
        #emit ADD
        
        // Now get the address it's pointing to. This seems to only work
        // using LREF (as opposed to LOAD.I, for example).
        #emit STOR.S.pri   temp
        #emit LREF.S.pri   temp
        
        // Now store it
        #emit STOR.S.pri   func
    } else {
        return 0;
    }
    
    while (--arg >= 0) {
        switch (packed_format ? fmat{arg} : fmat[arg]) {
            // String, array, and variables passed by reference
            case 's', 'a', 'v': {
                // Load the frame pointer
                #emit LCTRL 5
                
                // Add 12 + (2 + arg) * 4 to get the argument we want
                #emit LOAD.S.alt  arg
                #emit SHL.C.alt   2
                #emit ADD
                #emit ADD.C       20
                
                // Load the address there
                #emit LOAD.I
                
                // Push that address
                #emit PUSH.pri
            }
            
            // Single-cell arguments passed by value; I used "default"
            // here because it seems that's what CallLocalFunction does.
            default: {
                // Load the frame pointer
                #emit LCTRL 5
                
                // Add 12 + (2 + arg) * 4 to get the argument we want
                #emit LOAD.S.alt  arg
                #emit SHL.C.alt   2
                #emit ADD
                #emit ADD.C       20
                
                // Load the address there
                #emit LOAD.I
                
                // Load the value that address points to
                #emit LOAD.I
                
                // Push that value
                #emit PUSH.pri
            }
        }
    }
    
    // Push args * 4
    #emit LOAD.S.pri  args
    #emit SHL.C.pri   2
    #emit PUSH.pri
    
    // Push the return address
    #emit LCTRL       6
    #emit ADD.C       28
    #emit PUSH.pri
    
    // Call the function
    #emit LOAD.S.pri  func
    #emit SCTRL       6
    
    // Restore the stack
    #emit STACK       24
    
    // Return (pri is the return value, which comes from func)
    #emit RETN
    
    // Never actually happens
    return 0;
}

/*
 * Safer version, also for packed strings.
 */
stock IsNull(const string[]) {
    if (string[0] > 255)
        return string{0} == '\0' || (string[0] & 0xFFFF0000) == 0x01000000;
    else
        return string[0] == '\0' || string[0] == '\1' && string[1] == '\0';
}

stock IsFloatNan(Float:number)
{
    return (number != number) || !(number <= 0.0 || number > 0.0);
}

/*
 * formatex for y_va functions.
 */
stock va_formatex(output[], size = sizeof(output), const fmat[], va_:STATIC_ARGS) {
    new
        num_args,
        arg_start,
        arg_end
    ;
    
    // Get the pointer to the number of arguments to the last function.
    #emit LOAD.S.pri   0
    #emit ADD.C        8
    #emit MOVE.alt
    
    // Get the number of arguments.
    #emit LOAD.I
    #emit STOR.S.pri   num_args
    
    // Get the variable arguments (end).
    #emit ADD
    #emit STOR.S.pri   arg_end
    
    // Get the variable arguments (start).
    #emit LOAD.S.pri   STATIC_ARGS
    #emit SMUL.C       4
    #emit ADD
    #emit STOR.S.pri   arg_start
    
    // Using an assembly loop here screwed the code up as the labels added some
    // odd stack/frame manipulation code...
    while (arg_end != arg_start)
    {
        #emit MOVE.pri
        #emit LOAD.I
        #emit PUSH.pri
        #emit CONST.pri    4
        #emit SUB.alt
        #emit STOR.S.pri   arg_end
    }
    
    // Push the additional parameters.
    #emit PUSH.S       fmat
    #emit PUSH.S       size
    #emit PUSH.S       output
    
    // Push the argument count.
    #emit LOAD.S.pri   num_args
    #emit ADD.C        12
    #emit LOAD.S.alt   STATIC_ARGS
    #emit XCHG
    #emit SMUL.C       4
    #emit SUB.alt
    #emit PUSH.pri
    #emit MOVE.alt
    
    // Push the return address.
    #emit LCTRL        6
    #emit ADD.C        28
    #emit PUSH.pri
    
    // Call formatex
    #emit CONST.pri    formatex
    #emit SCTRL        6
}

stock Float:floatrandom(Float:max) {
    return floatmul(floatdiv(float(random(cellmax)), float(cellmax - 1)), max);
}

stock Float:fclamp(Float:X, Float:a, Float:b) {
    X = X < a ? a : X;
    X = X > b ? b : X;
    return X;
}