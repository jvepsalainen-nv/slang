//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: widening conversion from Half to Float yields a Float-typed floatCast value, complementing the narrow-to-wide direction.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// widening conversion from Half to Float yields a Float-typed
// floatCast value, complementing the narrow-to-wide direction. A
// `float(v)` widening from a `half` value produces a `floatCast`
// instruction whose result is `Float`, pulling from the narrowest to
// the platform-default float.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    float widened = float(v);
    buf[0] = widened;
}

// IR: let {{.*}}%widened{{.*}}: Float{{.*}}= floatCast(%v)
