//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#warning-groups
//META: purpose=`Default` is the implicit group of every untagged warning and is always emitted, so enabling another group does not gate it out.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that turning on a named group leaves untagged warnings alone. 41024
// carries no group sentinel, so it belongs to Default; compiling with `-Wall`
// selects a different group entirely and CHECK asserts 41024 still fires, which
// would not hold if the mask gated Default warnings too.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute -Wall

RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    int x = (1, 2);
    buf[0] = x;
}

// CHECK: E41024
// CHECK: comma operator used in expression
