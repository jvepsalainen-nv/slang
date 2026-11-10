//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/targets.md#auto-generated-reference
//META: purpose=The `subgroup_workgroup_index` compound alias restricts `WaveGetNumWaves` to compute-class stages on SPIR-V; a fragment entry point calling it is rejected by the capability system with E36107.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the compound-alias gating path on the second target the doc
// names: `WaveGetNumWaves` is gated by `subgroup_workgroup_index`, which
// on SPIR-V admits only compute-class stages. A fragment entry point
// calling the query is rejected at check time; the CHECK pins the E36107
// stage/target mismatch, so misuse never reaches SPIR-V emission.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -entry main -stage fragment

[shader("fragment")]
float4 main() : SV_Target
/*CHECK:
       ^^^^ entrypoint 'main' uses features that are not available in 'fragment' stage for 'spirv' compilation target.
*/
//CHECK: E36107
{
    return float4(float(WaveGetNumWaves()), 0, 0, 1);
}
