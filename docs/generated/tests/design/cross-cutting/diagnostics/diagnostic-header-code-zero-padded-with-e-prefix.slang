//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=A rendered diagnostic header is `<severity>[E<5-digit id>]: <message>` with the id zero-padded, so entry 14 prints as error[E00014] rather than error[E14].
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The zero-padding half of the header format is only observable on an
// entry whose id has fewer than five digits, and the ids below 10000 are
// the option-parsing range. This test asks for a profile that does not
// exist, which is catalog entry 14, and asserts the header renders it as
// `error[E00014]` with three leading zeros - the CHECK-NOT for `[E14]`
// rules out the unpadded spelling. It also pins the message so the row
// is anchored to a specific entry rather than to any five-digit code.

//TEST:SIMPLE(filecheck=CHECK,exit-code=1):-target hlsl -entry main -stage compute -profile bogusProfileName

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK-NOT: {{\[}}E14{{\]}}
// CHECK: error{{\[}}E00014{{\]}}: unknown profile
// CHECK-NOT: {{\[}}E14{{\]}}
