//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#files-and-responsibilities
//META: purpose=Implicit-conversion ranking inserts an int-to-float coercion at a typed initialization site, preserving the source value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "coercion site checks" concern: the initializer is an `int`
// expression while the declared type is `float`, so the conversion checker
// must insert a widening coercion rather than reject the initialization.
// CHECK asserts the converted value, which proves the coercion happened and
// preserved the operand.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int i = 7;
    float f = i;
    // CHECK: f=7.5
    printf("f=%.1f\n", f + 0.5f);
}
