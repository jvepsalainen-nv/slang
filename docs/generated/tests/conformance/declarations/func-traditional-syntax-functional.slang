//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#functions
//META: purpose=Functions may also be declared with traditional C-style syntax (return-type name(params)) and produce correct results.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the traditional C-style function declaration (return-type before name) works.
// `float add(int x, float y)` is called and 5.5 confirms the result,
// proving C-style syntax is accepted and produces correct output.

//TEST:INTERPRET(filecheck=CHECK):

float add(int x, float y) { return float(x) + y; }

void main()
{
    // CHECK: 5.5
    printf("%g\n", add(3, 2.5));
}
