//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=`#include` filenames are decoded without escape processing, so a backslash-x sequence in the path is looked up (and reported) verbatim.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the filename variant of string decoding: the include path
// below contains the characters `\x41`, which would decode to `A`
// under normal string-escape processing. The missing-include
// diagnostic must report the path with `\x41` intact — a report of
// `no-such-dirA-missing...` would mean escapes were processed.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#include "no-such-dir\x41-missing.slang.h"
//CHECK: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ include file not found
//CHECK: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ failed to find include file 'no-such-dir\x41-missing.slang.h'
// CHECK: E15300
// CHECK: no-such-dir\x41-missing.slang.h

void main() {}
