//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#diagnostics-during-lowering
//META: purpose=A `switch` body that discards nothing (`{ }` or `{ ; }`) takes the no-cases early return silently: no unreachable-code warning is reported.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary for the no-case-label switch report: bodies that discard no
// statement must not warn. The CHECK-NOT proves E41000 never appears while the
// positive CHECK proves lowering did complete and produced `func %main`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    switch (a) { }
    switch (a) { ; }
    buf[0] = a;
}

// CHECK-NOT: E41000
// CHECK: func %main
