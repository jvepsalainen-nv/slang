//META: generated=true
//META: doc_ref=docs/language-reference/expressions-identifier.md#overloading
//META: purpose=An overloaded identifier (function name) is disambiguated by the argument types at the call site; different argument types route to different overloads.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Corner case: overload disambiguation when the argument is a subtype of multiple parameter types.
// Tests that a bool argument resolves to the int overload (implicit conversion) rather than float.
//TEST:INTERPRET(filecheck=CHECK):

// Overload probe: returns 1 for int, 2 for float, confirming which overload was selected.
int which(int x)   { return 1; }
int which(float x) { return 2; }

void main()
{
    // bool promotes to int (rank 1) before float (rank 2); the int overload is chosen.
    bool b = true;
    int result = which(int(b));
    //CHECK: 1
    printf("%d\n", result);

    // An explicit float argument forces the float overload.
    float fval = 1.5f;
    int result2 = which(fval);
    //CHECK: 2
    printf("%d\n", result2);
}
