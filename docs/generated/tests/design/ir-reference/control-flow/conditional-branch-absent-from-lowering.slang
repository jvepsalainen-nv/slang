//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/control-flow.md#conditionalbranch-vs-ifelse
//META: purpose=AST lowering never emits the unstructured conditionalBranch: an entry point built from if, for, and switch statements contains only structured terminators.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the front end reaches for the structured two-way branch
// everywhere, so the unstructured `conditionalBranch` form never appears in
// the IR that lowering hands off. main packs every surface conditional the
// language offers -- an if/else, a for loop with a predicate, and a switch --
// and the CHECK-NOT scans the whole lowered body for `conditionalBranch`.
// The `[^n]` guard is what keeps the pattern from firing on the `n` that ends
// `unconditionalBranch`, which is present on nearly every block here.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform int n;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int s = 0;
    if (a > 0)
        s = 1;
    else
        s = 2;

    for (int i = 0; i < n; i++)
        s = s + i;

    switch (a)
    {
    case 1:
        s = s * 2;
        break;
    default:
        s = s * 3;
        break;
    }

    buf[0] = s;
}

// CHECK-LABEL: func %main
// CHECK-NOT: {{[^n]conditionalBranch}}
// CHECK: return_val(void_constant)
