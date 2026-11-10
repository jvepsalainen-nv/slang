//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=A per-id override takes precedence over warning-group gating, so `-W<id>` force-enables a single warning from a group that is off.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented ordering in which a per-id override is consulted before
// the group gate. 38052 lives in the pedantic group, which is off by default, so
// naming the id with `-W38052` must make it fire even though `-Wpedantic` was not
// passed. CHECK asserts the code and message appear; the sibling
// warning-group-pedantic-silent-by-default.slang shows the same shader is silent
// without any override.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry vertMain -stage vertex -W38052

struct VOut { float4 color : COLOR; };

VOut vertMain(uint id : SV_VertexID)
{
    VOut o;
    o.color = float4(float(id), 0, 0, 1);
    return o;
}

// CHECK: E38052
// CHECK: no output with the 'SV_Position' system value semantic
