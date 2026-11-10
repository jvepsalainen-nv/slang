//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=An integer-tagged enum's synthesized `__Tag` witness is honored, so the enum converts to and compares as its underlying integer type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that conformance synthesis installed the tag witness and that the
// witness-table early-out honors it. Converting a case to `int` and switching
// on the enum both go through the tag type's integer conformance; if the
// synthesized witness were not found, neither the conversion nor the switch
// would type-check. CHECK asserts the combined value.

//TEST:INTERPRET(filecheck=CHECK):

enum Color : int
{
    Red = 1,
    Green = 2,
    Blue = 4,
}

void main()
{
    Color c = Color.Green;
    int viaCast = int(c) + int(Color.Blue);
    int viaSwitch = 0;
    switch (c)
    {
    case Color.Red:
        viaSwitch = 10;
        break;
    case Color.Green:
        viaSwitch = 20;
        break;
    default:
        viaSwitch = 30;
        break;
    }
    // CHECK: v=26
    printf("v=%d\n", viaCast + viaSwitch);
}
