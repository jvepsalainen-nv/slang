//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-builtin-operator-fast-path
//META: purpose=getBuiltinArithmeticCommonType makes float beat int, so an int + float expression has type float.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "float beats int" half of the usual arithmetic conversions the
// fast path applies before building a BuiltinOperatorExpr. An overload probe
// with one int and one float overload observes the type of `i + f`; CHECK
// asserts the float overload fired, which is only true if the common type is
// float.

//TEST:INTERPRET(filecheck=CHECK):

int probe(int x)   { return 1; }
int probe(float x) { return 2; }

void main()
{
    int i = 3;
    float f = 4.0f;
    int tag = probe(i + f);
    // CHECK: tag=2
    printf("tag=%d\n", tag);
}
