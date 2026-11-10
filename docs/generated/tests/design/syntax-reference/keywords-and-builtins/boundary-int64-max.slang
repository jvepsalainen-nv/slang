//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#core-module-syntax-declarations
//META: purpose=Boundary: `int64_t` from `core.meta.slang` at its MAX value (9223372036854775807) binds the `int64_t` overload over a competing `int` overload.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the upper edge of the wide signed integer type contributed
// by the core meta-module. The value exceeds 32-bit range, so an
// `int` overload would lose.

//TEST:INTERPRET(filecheck=CHECK):

int kind(int64_t v) { return 1; }
int kind(int v)     { return 2; }

void main()
{
    int64_t x = 9223372036854775807;
    // CHECK: k=1
    printf("k=%d\n", kind(x));
}
