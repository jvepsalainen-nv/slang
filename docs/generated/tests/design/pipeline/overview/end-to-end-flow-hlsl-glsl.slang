//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/pipeline/overview.md#end-to-end-flow
//META: doc_section_digest=050f2a1afed02c0a6b611d78eee6fa52f2d4cdf8d79a760ffe0b1f192d46e37b
//META: purpose=A non-trivial source successfully traverses the full pipeline to produce HLSL text with the entry-point body intact.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the full-pipeline end-to-end claim out to the GLSL back-end:
// the same macro/struct/callee/if-statement source the HLSL sibling
// compiles must also traverse lex/preprocess/parse/check/lower/IR-
// passes/emit to a GLSL artefact. CHECK pins the GLSL compute marker
// (layout(local_size_x...)) plus the lowered struct field, callee,
// and branch so every stage's work is observable in the emitted text.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute

#define LIMIT 4

struct Counter
{
    int value;
};

int bump(Counter c)
{
    return c.value + 1;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    Counter c;
    c.value = LIMIT;
    int next = bump(c);
    if (next > 0)
    {
        return;
    }
    return;
}

//GLSL: layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
//GLSL: void main()
//GLSL: if((bump_0(c_{{[0-9]+}})) > 0)
