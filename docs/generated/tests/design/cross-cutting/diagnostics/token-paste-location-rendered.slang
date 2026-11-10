//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=A diagnostic whose location falls in a synthesized token-paste view renders that view's name and a line:column inside it.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the token-paste boundary of location decoding: the offending token
// exists only in a view synthesized by `##`, not in any file on disk. A macro
// pastes two fragments into an undeclared name; CHECK asserts the rendered
// location names the token-paste view and that the pasted spelling appears in
// the message, so the sink resolved a SourceLoc that has no on-disk backing.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

#define CAT(a, b) a##b

RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = CAT(undefined, Thing);
}

// CHECK: E30015
// CHECK: token paste
// CHECK: undefinedThing
