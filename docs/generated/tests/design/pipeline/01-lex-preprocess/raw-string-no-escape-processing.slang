//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=A raw string literal performs no escape processing at all, so a backslash sequence inside it survives into the string's bytes verbatim.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the raw-string scanner hands its body through without
// running it past the escape decoder. `\n` inside the raw literal must
// stay two characters (backslash, `n`) rather than collapsing to a
// newline. The emitted C++ re-escapes a literal backslash as `\\`, so
// seeing `a\\nb` in the generated source proves the backslash was
// preserved; a decoded escape would emit `a\nb` instead. slangi printf
// does not support `%s`, hence the emission observation.

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", R"(a\nb)");
    //CHECK: "a\\nb"
}
