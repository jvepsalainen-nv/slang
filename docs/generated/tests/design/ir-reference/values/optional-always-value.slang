//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#result--optional--conditional-helpers
//META: purpose=Boundary: a function that unconditionally returns `Optional<int>` from a value (no `none` branch) surfaces `makeOptionalValue(%x)` exactly once — the value-side edge of the Optional value space.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The value-side edge: the function never returns `none`, so the
// IR contains only `makeOptionalValue` (not `makeOptionalNone`).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

Optional<int> always(int x)
{
    return x;
}

[numthreads(1, 1, 1)]
void main()
{
    Optional<int> o = always(a);
    if (o.hasValue)
        buf[0] = o.value;
}

// IR: makeOptionalValue(%x)
// IR-LABEL: func %main
// IR: optionalHasValue(%o)
// IR: getOptionalValue(%o)
