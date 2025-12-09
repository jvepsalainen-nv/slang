# Quick Start Guide

Get started with the Slang Test Generator in 5 minutes.

## Installation

No installation required! Just Python 3.7+ with PyYAML:

```bash
pip install pyyaml
```

## Your First Test

### Step 1: Create a Simple Shader

Create `hello.slang`:

```slang
[numthreads(1, 1, 1)]
void computeMain(uint3 tid: SV_DispatchThreadID)
{
    outputBuffer[0] = 12345;
}
```

### Step 2: Create a Configuration

Create `hello-config.yaml`:

```yaml
test_config:
  name: hello
  shader_template: "./hello.slang"
  output_pattern: "{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"

variants:
  cpu-test:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cpu -output-using-type"
        filecheck: RESULT
    
    filecheck_patterns:
      RESULT:
        - "12345"
```

### Step 3: Generate the Test

```bash
python slang-test-gen.py hello-config.yaml --output-dir ./output
```

### Step 4: Check the Result

Look at `output/cpu-test.slang`:

```slang
// THIS IS A GENERATED FILE. DO NOT EDIT!
//
// Test: hello - cpu-test
//
//TEST(compute):COMPARE_COMPUTE(filecheck-buffer=RESULT): -cpu -output-using-type

//TEST_INPUT: ubuffer(data=[0], stride=4):name outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid: SV_DispatchThreadID)
{
    outputBuffer[0] = 12345;
}

// RESULT:
// 12345
```

## Common Use Cases

### Use Case 1: Test Multiple Backends

```yaml
test_config:
  name: multi-backend
  shader_template: "./shader.slang"
  output_pattern: "{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"

variants:
  cpu:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cpu -output-using-type"
        filecheck: RESULT
  
  cuda:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cuda"
        filecheck: RESULT
  
  vulkan:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-vk"
        filecheck: RESULT
```

### Use Case 2: Parameterized Tests with Template Variables

Create `template-shader.slang`:

```slang
[numthreads({{NUM_THREADS}}, 1, 1)]
void computeMain(uint3 tid: SV_DispatchThreadID)
{
    outputBuffer[tid.x] = {{BASE_VALUE}} + tid.x;
}
```

Create `template-config.yaml`:

```yaml
test_config:
  name: parameterized
  shader_template: "./template-shader.slang"
  output_pattern: "{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0 0 0 0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"
  
  global_template_vars:
    NUM_THREADS: 4
    BASE_VALUE: 100

variants:
  test-1:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cpu -output-using-type"
        filecheck: RESULT
    
    filecheck_patterns:
      RESULT:
        - "100"
        - "101"
        - "102"
        - "103"
```

### Use Case 3: Test with Textures

```yaml
test_config:
  name: texture-test
  output_pattern: "{variant_name}.slang"
  
  # Inline shader code
  shader_template: |
    [shader("fragment")]
    void fragMain()
    {
        int ret = int((myTexture.Load(int2(0, 0))).x);
        outputBuffer[0] = 0x12345 + ret;
    }
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"

variants:
  texture2d:
    inputs:
      - name: myTexture
        type: Texture2D
        parameters: "size=4, content=zero"
        declaration: "Texture2D<float4> myTexture;"
    
    directives:
      - type: SIMPLE
        flags: "-entry fragMain -stage fragment -target spirv"
        filecheck: CHECK
    
    filecheck_patterns:
      CHECK:
        - "result code = 0"
```

### Use Case 4: Disabled Test Tracking

```yaml
test_config:
  name: my-test
  shader_template: "./shader.slang"
  output_pattern: "{variant_name}.slang"
  
  global_inputs:
    - name: outputBuffer
      type: ubuffer
      parameters: "data=[0], stride=4"
      declaration: "RWStructuredBuffer<int> outputBuffer;"

variants:
  working-test:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-cpu -output-using-type"
        filecheck: RESULT
        enabled: true
  
  broken-test:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-metal"
        filecheck: RESULT
        enabled: false
        disable_reason: 8786  # GitHub issue number
  
  not-implemented:
    directives:
      - type: COMPARE_COMPUTE
        flags: "-wgpu"
        filecheck: RESULT
        enabled: false
        disable_reason: "WebGPU support not yet implemented"
```

## Testing the Generated Files

After generating test files, you can run them with slang-test:

```bash
# From Slang repository root
./build/Release/bin/slang-test output/cpu-test.slang
```

## Next Steps

1. Read the [README.md](README.md) for comprehensive documentation
2. Check out [examples/](examples/) for more complex examples
3. Review [schema/test-config.schema.yaml](schema/test-config.schema.yaml) for all available options
4. Create your own test configurations!

## Tips

- **Validate first**: Use `--validate-only` to check configuration before generating
- **Use external shaders**: Easier to edit and test separately
- **Start simple**: Begin with basic tests and add complexity gradually
- **Use template variables**: Makes tests more maintainable and reusable
- **Group related tests**: Put multiple variants of the same test in one config file
- **Document disabled tests**: Always provide a reason or GitHub issue number

## Troubleshooting

### Configuration validation fails

Check that:
- All required fields are present (`name`, `shader_template`)
- Test directive types are valid (SIMPLE, COMPARE_COMPUTE, etc.)
- YAML syntax is correct (proper indentation, no tabs)

### Generated test doesn't work

Check that:
- Shader syntax is correct
- Test inputs match shader declarations
- FileCheck patterns match expected output
- Test flags are appropriate for the target backend

### Template variables not substituted

Check that:
- Variables are defined in `global_template_vars` or `template_vars`
- Variables use double braces: `{{VARIABLE_NAME}}`
- Variable names match exactly (case-sensitive)

## Getting Help

- Check the [README.md](README.md) for detailed documentation
- Look at [examples/](examples/) for working examples
- Review the schema in [schema/test-config.schema.yaml](schema/test-config.schema.yaml)
- Open an issue on the Slang repository for bugs or feature requests

