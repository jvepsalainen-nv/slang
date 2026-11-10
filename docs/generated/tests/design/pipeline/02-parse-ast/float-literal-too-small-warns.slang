//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#failure-modes
//META: purpose=A float literal below half the smallest denormal warns as too small and is stored as the converted value `0`, the other side of the range flag the parser turns into a diagnostic.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the underflow edge, which is reported by a different diagnostic than
// overflow even though both come from the same out-of-range flag: the parser
// picks between them by asking whether the converted value is finite. The
// smallest denormal float is about 1.401e-45, so anything under half of that
// rounds to zero; `.700649232e-45` is just below the tie point. The message
// naming the converted value `0` again shows the parser stored what the decoder
// returned rather than substituting the smallest denormal.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

static const float tooSmall = .700649232e-45;
//CHECK:                      ^^^^^^^^^^^^^^ warning E40010
//CHECK:                      ^^^^^^^^^^^^^^ '.700649232e-45' is smaller than the smallest representable value for type float, converted to '0'

void main()
{
}
