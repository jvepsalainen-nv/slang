//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=A half literal just above the largest finite half warns as unrepresentable and is stored as the converted value `inf`, because the parser does no clamping of its own.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the overflow edge of the half type together with the no-clamping
// rule. 65504 is the largest finite half and 65520 is the first value that
// rounds past it, so `65520.h` is the smallest literal that overflows. The
// warning text spells out the stored result, `inf`, which is exactly the
// difference between reporting the range problem and silently saturating to
// 65504 — a clamping parser would have produced a finite value and a different
// message.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

static const half tooLarge = 65520.h;
//CHECK:                     ^^^^^^^ warning E40009
//CHECK:                     ^^^^^^^ half literal '65520.h' unrepresentable, converted to 'inf'

void main()
{
}
