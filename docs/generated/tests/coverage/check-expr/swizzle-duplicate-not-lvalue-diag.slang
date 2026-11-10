//META: generated=true
//META: purpose=A swizzle with a repeated component (`v.xx`) is not an l-value, so assigning to it is rejected (E30011).
//META: intent=characterization
//META: covers=source/slang/slang-check-expr.cpp
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes CheckSwizzleExpr's `isLeftValue = !anyDuplicates && ...`:
// the duplicated 'x' sets anyDuplicates, clearing isLeftValue, so the
// assignment-target check reports "left of '=' is not an l-value" (E30011).

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry test -stage fragment

void test(out float4 v) { v.xx = float2(1, 2); }
//CHECK:                       ^ left of '=' is not an l-value
//CHECK:                       ^ left of '=' is not an l-value.

// CHECK: E30011
