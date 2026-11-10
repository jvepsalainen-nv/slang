//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that the int8 base type round-trips the documented MIN (-128) and MAX (127) literal values through evaluation.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Small-int boundary: int8's MIN/MAX edges. The constructor form
// `int8_t(N)` invokes a TypeCastExpr that must preserve the value
// at the boundary of the type's representable range.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int8_t a = int8_t(-128);
    int8_t b = int8_t(127);
    // CHECK: min=-128
    printf("min=%d\n", int(a));
    // CHECK: max=127
    printf("max=%d\n", int(b));
}
