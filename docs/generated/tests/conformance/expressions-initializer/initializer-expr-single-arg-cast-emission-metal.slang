//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-expressions
//META: doc_section_digest=4baa222d5b95c67d63377172d8a9ca06fa2e19f939661ef5099353e8c61b3470
//META: purpose=A single-argument initializer expression int(f) emits as an int() cast in HLSL, matching the C-style cast form.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the single-argument initializer expression `int(f)` and its
// C-style cast equivalent `(int)f` both lower to Metal's `int(...)` cast.
// Two distinct helpers prevent DCE; CHECK asserts the Metal `int(` cast token
// appears for each, confirming the initializer-expression form is a cast on Metal.

//TEST:SIMPLE(filecheck=CHECK):-target metal -stage compute -entry main

float passFloat(float f) { return f; }

int castViaInitExpr(float f)
{
    return int(f);
}

int castViaCStyle(float f)
{
    return (int)f;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main(RWStructuredBuffer<int> buf)
{
    buf[0] = castViaInitExpr(passFloat(buf[1]));
    buf[2] = castViaCStyle(passFloat(buf[3]));
}

// CHECK: return int(f_{{[0-9]+}})
// CHECK: return int(f_{{[0-9]+}})
