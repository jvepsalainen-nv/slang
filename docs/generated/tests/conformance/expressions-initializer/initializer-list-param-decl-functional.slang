//META: generated=true
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-list-expression
//META: purpose=An initializer list expression used as the initial-value of a parameter declaration (default argument) initializes the parameter when called without that argument.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an initializer list can appear as the default-value expression
// in a parameter declaration (not just a variable declaration).
// `process()` is called without an argument; the default `{ 0.5f, 1.5f }` must
// initialize both fields. CHECK asserts the printf output matches those values.

//TEST:INTERPRET(filecheck=CHECK):

struct Vec2 { float x; float y; };

void process(Vec2 v = { 0.5f, 1.5f })
{
    printf("%f %f\n", v.x, v.y);
}

void main()
{
    // Called without argument — default init list should apply.
    //CHECK: 0.500000 1.500000
    process();
}
