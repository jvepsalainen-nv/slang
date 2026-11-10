//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#core-module
//META: purpose=int8_t keeps its documented MIN value of -128 when it is returned from a function.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the core module's narrowest signed base type survives a
// function-call boundary at its MIN edge. The same constant is printed
// twice: once read straight out of the type's minValue and once after
// travelling through a function return. The CHECK requires both to be
// -128, so a widening step that drops the sign bit shows up as a
// mismatch between the two.

//TEST:INTERPRET(filecheck=CHECK):

int8_t returnsInt8Min() { return int8_t(-128); }

void main()
{
    int8_t direct = int8_t.minValue;
    int8_t returned = returnsInt8Min();
    // CHECK: direct=-128 returned=-128
    printf("direct=%d returned=%d\n", int(direct), int(returned));
}
