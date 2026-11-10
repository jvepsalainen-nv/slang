//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#initializers
//META: purpose=An `__init` declaration defines a way to initialize an instance; it is invoked by calling the enclosing type as if it were a function.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an `__init` is invoked by calling the type as a function, e.g. `MyVector(3.0)`.
// The initializer broadcasts its scalar argument to both fields; CHECK lines assert x and y
// both printed as 3, confirming the initializer ran and set the fields.

//TEST:INTERPRET(filecheck=CHECK):

struct MyVector
{
    float x, y;
    __init(float s) { x = s; y = s; }
}

void main()
{
    MyVector v = MyVector(3.0);
    // CHECK: 3
    // CHECK: 3
    printf("%g\n%g\n", v.x, v.y);
}
