//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#container-level-overload-accumulation
//META: purpose=Same-named decls inside one container do not shadow each other; they accumulate through the same-name chain into one overload set and resolution picks by argument type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a container hands lookup every same-named member, not
// just the last one declared. Both `run` overloads must reach the
// candidate set for the int call and the float call to select different
// bodies. CHECK asserts 14 + 14, a sum each body reaches by a different
// route, so a single surviving overload cannot produce it.

//TEST:INTERPRET(filecheck=CHECK):

struct K
{
    int run(int a) { return a * 2; }
    int run(float a) { return int(a) + 10; }
}

void main()
{
    K k;
    // CHECK: r=28
    printf("r=%d\n", k.run(7) + k.run(4.0f));
}
