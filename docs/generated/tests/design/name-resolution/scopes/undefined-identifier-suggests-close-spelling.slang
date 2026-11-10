//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-walking-order-during-lookup
//META: purpose=When a VarExpr fails to resolve, the checker reuses the scope-chain traversal to find a close spelling and attaches a "did you mean" suggestion to the undefined-identifier diagnostic (E30015).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the findClosestInScopeName reuse of the scope walk: the typo
// `totalCont` is one edit from the parameter `totalCount` that sits on
// the scope chain, so the E30015 diagnostic must carry a "did you mean
// 'totalCount'?" suggestion naming the in-scope spelling.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int compute(int totalCount)
{
    return totalCont;
//CHECK:   ^^^^^^^^^ undefined identifier
//CHECK:   ^^^^^^^^^ undefined identifier 'totalCont'.
//CHECK:   ^^^^^^^^^ did you mean 'totalCount'?
// CHECK: E30015
}
