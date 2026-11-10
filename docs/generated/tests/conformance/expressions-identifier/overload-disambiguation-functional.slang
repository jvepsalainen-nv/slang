//META: generated=true
//META: doc_ref=docs/language-reference/expressions-identifier.md#overloading
//META: purpose=An overloaded identifier resolves to the correct candidate when the call context disambiguates by argument type.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An identifier may refer to multiple candidates with the same name (overloaded).
// When the call site provides enough type information, the right overload is chosen.
// Uses the overload-probe pattern: each overload returns a distinct integer sentinel.
//TEST:INTERPRET(filecheck=CHECK):

int probe(int x)   { return 1; }
int probe(float x) { return 2; }
int probe(uint x)  { return 3; }

void main()
{
    // Each call passes an argument whose type disambiguates the overload set.
    int ri = probe(1);          // int literal -> probe(int) -> 1
    int rf = probe(1.0f);       // float literal -> probe(float) -> 2
    int ru = probe(uint(99));   // explicit uint -> probe(uint) -> 3
    //CHECK: 1
    //CHECK: 2
    //CHECK: 3
    printf("%d\n", ri);
    printf("%d\n", rf);
    printf("%d\n", ru);
}
