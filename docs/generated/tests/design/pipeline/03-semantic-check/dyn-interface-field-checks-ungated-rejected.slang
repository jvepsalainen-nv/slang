//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#dyn-interface-restrictions
//META: purpose=The field checks on a type conforming to a `dyn interface` (E33079, E33080) are not gated on the language version, so they fire under the default `-std`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the exception the refreshed doc records: unlike the extension and
// generic-conformer checks, the field checks stay active when the gate is
// closed. There is no `-std 2026` here, so the unsized and opaque fields
// being rejected shows the gate does not cover them. CHECK pins one code per
// field.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

dyn interface IFoo
{
    int get();
}

struct Unsized : IFoo
{
    int tail[];
//CHECK: E33079
    int get() { return 0; }
}

struct Opaque : IFoo
{
    Texture2D t;
//CHECK: E33080
    int get() { return 0; }
}

void main()
{
}
