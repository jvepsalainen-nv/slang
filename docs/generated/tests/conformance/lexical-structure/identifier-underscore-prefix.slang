//META: generated=true
//META: doc_ref=docs/language-reference/lexical-structure.md#identifiers
//META: purpose=Identifiers may start with `_` and contain letters/digits/underscores in subsequent positions, per the doc's identifier grammar.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that identifiers may start with `_` and contain letters,
// digits, and underscores in subsequent positions. Three variables
// with `_`-led, digit-embedded, and trailing-underscore names are
// declared and summed; CHECK on `sum=6` confirms all three bound.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int _leading = 1;
    int _trailing_underscore_ = 2;
    int with_digits_42_99 = 3;
    int sum = _leading + _trailing_underscore_ + with_digits_42_99;
    //CHECK: sum=6
    printf("sum=%d\n", sum);
}
