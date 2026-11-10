//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=The sink renders the decoded location as a `file:line:column` triple naming the source file.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the sink decodes the SourceLoc through SourceManager into a
// location that names the originating file. CHECK asserts this file's name
// appears alongside the undefined-identifier message, which is only possible
// if the path component of the decoded triple survives rendering.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int a = nonexistent;
}

// CHECK: source-location-file-line-format.slang
// CHECK: undefined identifier
