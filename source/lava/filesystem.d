/**
    The Virtual Filesystem must:
        - Reference assets by a string identifier.
        - Decompress / unencrypt data depending on how it's stored.
        - Return assets upon request.

    TODO: compile-time packing of assets, accessible by a virtual system.
*/

module lava.filesystem;

private string __buildResources() {
    if(!__ctfe) return "CANNOT CALL __buildResources AT RUNTIME";
     
    // Called at compile-time
    pragma(msg, "Running");

    //compile assets here
    
    return "CTFE_Running at compile-time.";
}
    
pragma(msg, __buildResources());

