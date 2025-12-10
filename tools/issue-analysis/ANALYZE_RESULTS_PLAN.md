# How to Create the Issue Analysis Report

**Purpose:** This is a process guide for creating comprehensive issue analysis reports from the generated data.

**Actual Analysis Location:** The analysis report itself goes in **`results/ISSUE_ANALYSIS.md`** (not this file).

This document describes:
- What data is available in `results/*.txt`
- How to structure the analysis report
- What to include in each section
- How to prioritize findings

## Objective

The `results/ISSUE_ANALYSIS.md` should provide:
1. Executive summary of the Slang codebase quality
2. Deep dive into top 10 most problematic areas
3. Root cause analysis based on patterns extracted from issue data

**Important:** This is a descriptive analysis, not prescriptive. The goal is to highlight WHERE problems are and WHAT the root causes appear to be based on data, not to make recommendations on how to fix them.

## Data Sources

### Phase 1: Analysis Outputs (Identify Problem Areas)

Four complementary reports in `results/`:

1. **general-analysis.txt** - Overall PR and issue trends
   - Total issues: 3,573
   - Total PRs: 5,425
   - Bug fix rate: 26.1% (1,417 bug-fix PRs)
   - Provides: PR velocity, issue trends, test coverage, file-level bug frequencies

2. **critical-analysis.txt** - Critical bugs (crashes, ICEs, etc.)
   - Total critical issues: 1,066
   - Critical bug-fix PRs: 702
   - Provides: Root causes, critical components, severity breakdown

3. **bugfix-files-analysis.txt** - File and component bug patterns
   - Analyzes all 1,417 bug-fix PRs
   - Provides: Component-level metrics (fixes, changes, LOC)
   - File-level bug fix frequencies

4. **ISSUE_SOURCES.md** - Downstream projects and infrastructure analysis
   - Identifies which projects report issues
   - Tracks both repository URLs and keyword mentions
   - Coverage: 17.7% of issues mention specific projects/infrastructure
   - Provides: Downstream project statistics, open issue counts, bug rates per project

### Phase 2: Raw Data (Deep-Dive for Evidence)

Raw issue and PR data in `data/`:

1. **data/issues.json** - All 3,573 issues
   - Fields: number, title, body, labels, state, created_at, closed_at, comments, user
   - Use for: Finding specific examples, understanding issue descriptions, analyzing patterns

2. **data/pull_requests.json** - All 5,425 PRs
   - Fields: number, title, body, labels, state, created_at, merged_at, files_changed
   - files_changed includes: filename, additions, deletions, changes
   - Use for: Understanding fixes, finding related issues, analyzing change patterns

3. **data/critical_issues.csv** - Export of critical issues
   - Pre-filtered critical issues for easier analysis
   - Use for: Quick access to critical issue details

## Analysis Structure

### 1. Executive Summary (1 page)

**Key Metrics** (extract from `results/*.txt`):
- Total issues and PRs analyzed
- Bug fix rate (% of PRs that are bug fixes)
- Critical issue count and types
- Test coverage statistics
- Average time to close issues/merge PRs

**Trends** (calculate from raw data):
- Bug fix trend over time (increasing/decreasing)
- Critical issue trend over time
- PR velocity trend
- Test coverage trend

**Issue Sources** (from `ISSUE_SOURCES.md`):
- Top downstream projects reporting issues (Falcor, OptiX, WGPU, etc.)
- Infrastructure references (DXC, SPIRV-Tools, glslang)
- Percentage of issues with project attribution
- Which downstream projects have most open issues
- Which downstream projects have highest bug rates

**Overall Assessment** (synthesize from data):
- Overall quality trend (improving/stable/declining)
- Top 5 most problematic areas (from priority score analysis)
- Top 5 areas in open issues and PRs (current status)
- Key patterns observed (what types of bugs are most common)

### 2. Top 10 Most Problematic Areas

Each area should include:

**Format:**
```
## Area N: [Component/System Name]

**Severity:** Critical/High/Medium
**Impact:** [Scope of impact - crashes, correctness, performance, etc.]

### Metrics
- Bug fix frequency: X fixes per 1000 LOC
- Total bug fixes: X PRs
- Critical issues: X crashes/ICEs
- Test coverage: X% (if available)

### Root Causes (from issue data)
Extract these from actual issue titles, descriptions, and patterns:
1. [Primary cause - quote/reference specific issues]
2. [Secondary cause - show pattern across multiple issues]
3. [Contributing factors - observed from PR fix patterns]

**Important:** Root causes should be extracted from issue/PR text, not assumed by the LLM.
Look for:
- Recurring keywords in issue titles
- Common error messages in issue bodies
- Similar fix patterns in PRs
- User-reported symptoms

### Evidence
- File: [filename] - X fixes, Y LOC, Z fix frequency
- Example issues:
  - #[number]: [title] - [key symptom/error]
  - #[number]: [title] - [key symptom/error]
  - #[number]: [title] - [key symptom/error]
- Patterns observed:
  - [Pattern 1 with frequency count]
  - [Pattern 2 with frequency count]
```

## Discovering Critical Areas (No Assumptions)

The analysis must identify problem areas purely from data. Do not make assumptions about which components are problematic.

### Selection Criteria

Select the top 10 areas based on data from `results/*.txt` files:

1. **High Bug Fix Frequency (normalized by LOC)**
   - From: "TOP 40 FILES BY BUG FIX FREQUENCY" sections
   - Look for: Files with >50 fixes per 1000 LOC
   - Group related files into components

2. **High Absolute Bug Count**
   - From: "ALL COMPONENTS BY BUG-FIX FREQUENCY" section
   - Look for: Components with >100 total bug fixes
   - Consider: Both total fixes and LOC for context

3. **Critical Issue Concentration**
   - From: "ROOT CAUSE COMPONENTS" section in critical-analysis.txt
   - Look for: Components with >5 critical issues
   - Prioritize: Crashes and ICEs over other issue types

4. **Cross-Category Appearance**
   - Components that appear in:
     - High bug frequency lists
     - Critical issue lists
     - High change volume lists
   - These are strong candidates for deep-dive

5. **Test Coverage Gaps**
   - From: General analysis test coverage sections
   - Components with low test coverage AND high bug counts
   - Indicates systemic quality issues

### Decision Matrix

For each component found in the data, calculate a priority score:

```
Priority Score = (Bug Fix Frequency × 0.3) +
                 (Critical Issues × 0.4) +
                 (Total Fixes / 100 × 0.2) +
                 (Cross-Category Appearances × 0.1)
```

Select the top 10 by priority score for detailed analysis.

## Analysis Process

### Phase 1: Identify Problem Areas (From Analysis Outputs)

#### Step 1: Extract Key Metrics
```bash
# Get component-level statistics
grep -A 50 "ALL COMPONENTS BY BUG-FIX FREQUENCY" results/bugfix-files-analysis.txt

# Get file-level bug frequencies
grep -A 40 "TOP 40 FILES BY BUG FIX FREQUENCY" results/bugfix-files-analysis.txt
grep -A 40 "TOP 40 FILES BY BUG FIX FREQUENCY" results/general-analysis.txt
grep -A 40 "TOP 40 FILES BY CRITICAL BUG FIX FREQUENCY" results/critical-analysis.txt

# Get critical issue patterns
grep -A 20 "ROOT CAUSE COMPONENTS" results/critical-analysis.txt
grep -A 20 "CRITICAL ISSUES BY TYPE" results/critical-analysis.txt
```

#### Step 2: Cross-Reference Analysis
- Correlate high bug fix frequency with critical issues
- Identify components appearing in multiple problem categories
- Look for patterns in error types (crashes, ICEs, validation)
- Note files with disproportionately high bug fix frequency per LOC

#### Step 3: Identify Top 10 Areas

**A. Extract Component Metrics**

Create a table with all components found in the analysis:

```
Component Name | Bug Fixes | Bug Fix Freq | LOC | Critical Issues | In Multiple Lists
---------------|-----------|--------------|-----|-----------------|------------------
```

Sources:
- Bug Fixes: From "ALL COMPONENTS BY BUG-FIX FREQUENCY"
- Bug Fix Freq: From "TOP 40 FILES BY BUG FIX FREQUENCY" (average for component)
- LOC: From "ALL COMPONENTS BY BUG-FIX FREQUENCY" (LOC column)
- Critical Issues: From "ROOT CAUSE COMPONENTS"
- In Multiple Lists: Count how many analysis sections mention this component

**B. Calculate Priority Scores**

For each component:
```python
# Normalize values to 0-1 scale first
normalized_freq = bug_fix_freq / max_bug_fix_freq
normalized_critical = critical_issues / max_critical_issues
normalized_fixes = total_fixes / max_total_fixes
cross_category = appearances_count / 3  # Max 3 categories

priority_score = (normalized_freq * 0.3) + \
                 (normalized_critical * 0.4) + \
                 (normalized_fixes * 0.2) + \
                 (cross_category * 0.1)
```

**C. Select Top 10**

- Sort components by priority score
- Take top 10
- Exclude "test" and "docs" unless they show exceptional problems
- Include at least 2-3 high-frequency files even if they're in same component
  (e.g., specific problematic files like slang.cpp, slang-compiler.cpp)

**D. Validate Selection**

Ensure selected areas:
- Represent actual code quality issues (not just high activity)
- Have actionable scope (not too broad like "all IR")
- Show clear patterns that suggest root causes
- Have sufficient data for deep-dive analysis

### Phase 2: Deep-Dive Using Raw Data

For each of the identified top 10 areas:

#### Step 4: Find Specific Issues and PRs

**Example: For "IR Optimization" area identified in Phase 1**

```python
import json

# Load raw data
with open('data/issues.json') as f:
    issues = json.load(f)
with open('data/pull_requests.json') as f:
    prs = json.load(f)

# Find issues mentioning IR components
ir_issues = [
    issue for issue in issues
    if 'slang-ir' in issue.get('title', '').lower() or
       'slang-ir' in (issue.get('body') or '').lower()
]

# Find PRs that modified IR files
ir_prs = [
    pr for pr in prs
    if any('slang-ir' in f['filename'] for f in pr.get('files_changed', []))
]

# Find critical IR issues
critical_ir = [
    issue for issue in ir_issues
    if any(keyword in issue.get('title', '').lower()
           for keyword in ['crash', 'ice', 'assert', 'segfault'])
]
```

#### Step 5: Extract Evidence

For each critical area, gather:

**Issue Examples:**
- Find 3-5 representative issues (issue number, title, key symptoms)
- Look for recurring patterns in issue descriptions
- Note user-reported impact

**PR Analysis:**
- Examine files changed in bug-fix PRs
- Identify common fix patterns
- Calculate average time to fix
- Note if fixes clustered in specific time periods

**Pattern Recognition:**
```python
# Example: Analyze issue titles for patterns
from collections import Counter

keywords = []
for issue in critical_ir:
    title = issue['title'].lower()
    # Extract meaningful keywords
    for word in ['specialization', 'inlining', 'lowering', 'legalization',
                 'optimization', 'transformation']:
        if word in title:
            keywords.append(word)

pattern_frequency = Counter(keywords)
# Shows which IR operations are most problematic
```

#### Step 6: Root Cause Analysis

For each area, synthesize evidence to identify:
- **Technical root causes**: Architecture issues, complexity, missing validation
- **Process root causes**: Insufficient testing, documentation gaps
- **Patterns**: Are bugs clustered in new features? Legacy code? Specific backends?

Example questions to answer:
- What types of bugs are most common? (crashes vs. correctness vs. performance)
- Are bugs in new code or old code?
- Are certain code paths undertested?
- Is the component trying to do too much?
- Are there missing abstractions?

#### Step 7: Prioritization

Rank the 10 areas by:
1. **Impact**: Critical issues > Correctness > Performance > Usability
2. **Frequency**: Bug fix rate normalized by LOC
3. **Trend**: Use issue `created_at` dates to see if problems increasing/decreasing
4. **Blast radius**: How many users/features affected (check issue comment count, labels)

#### Step 8: Extract Root Causes from Data

For each area, analyze issue descriptions and PR patterns to identify root causes.

**From Issue Titles/Bodies:**
```python
# Example: Identify common error patterns
error_patterns = {}
for issue in area_issues:
    title = issue['title'].lower()
    body = (issue.get('body') or '').lower()

    # Extract error keywords
    for pattern in ['assertion', 'crash', 'segfault', 'null pointer',
                   'validation error', 'compilation failed']:
        if pattern in title or pattern in body:
            error_patterns[pattern] = error_patterns.get(pattern, 0) + 1

    # Extract specific error messages (look for quotes or code blocks)
    # Count recurring phrases
```

**From PR Fix Patterns:**
- What files are most commonly changed together?
- What types of changes are most common? (validation, null checks, type fixes)
- Are fixes concentrated in specific functions/areas?
- Look for PR titles like "Fix crash when..." to understand failure modes

**Document Root Causes:**
- State the pattern (e.g., "15 crashes related to null pointer in IR optimization")
- Provide 3-5 specific issue numbers as evidence
- Quote actual error messages or symptoms from issues
- DO NOT speculate beyond what the data shows

### Step 9: Validate with Data

For each identified root cause:
- Show specific issue/PR numbers as evidence
- Provide frequency counts (e.g., "20 of 45 issues mention this pattern")
- Quote actual issue text to support the claim
- Do not make assumptions about why the root cause exists

## Output Format

The final `results/ISSUE_ANALYSIS.md` should include:
- Clear structure with table of contents
- Executive summary (1 page)
- Top 10 most problematic areas (detailed analysis)
- Appendices with supporting data
- No emojis
- Professional, data-driven tone
- Root causes extracted from actual issue data

### HTML Generation

Always generate an HTML version alongside the markdown for better readability:

**Markdown Best Practices for HTML Conversion:**
1. **Lists require blank lines:** Add blank line before bullet/numbered lists
   ```markdown
   **Key findings:**

   - First item
   - Second item
   ```

2. **Escape issue numbers:** Use `\#` to prevent markdown from treating `#8882` as heading
   ```markdown
   - \#8882 (crash): "Description"
   ```

3. **Consistent spacing:** Maintain consistent spacing around headings and sections

**HTML Generation Script:**

Use the provided `generate_html.py` script which:
- Loads PR data to distinguish PRs from issues
- Creates correct URLs: `/pull/` for PRs, `/issues/` for issues
- Applies professional styling
- Opens links in new tab

```bash
python3 generate_html.py
```

**Key features:**
```python
# Loads PR numbers to distinguish from issues
pr_numbers = load_pr_numbers()  # Set of PR numbers from data/pull_requests.json

# Converts #1234 to correct GitHub URL
def replace_number(match):
    number = int(match.group(1))
    url_type = 'pull' if number in pr_numbers else 'issues'
    return f'<a href="https://github.com/shader-slang/slang/{url_type}/{number}"...>#{number}</a>'
```

This ensures:
- `#7758` (issue) → `https://github.com/shader-slang/slang/issues/7758`
- `#5432` (PR) → `https://github.com/shader-slang/slang/pull/5432`

## Success Criteria

The final analysis should:
- Clearly identify WHERE problems are (quantifiable metrics)
- Extract WHAT is happening (patterns, symptoms, error types)
- Document root causes using evidence from issue/PR data
- Show all reasoning with specific issue/PR references
- Avoid speculation or assumptions beyond the data
- NOT make recommendations on how to fix problems

## How to Use This Guide

### Prerequisites

1. **Ensure data is available:**
   ```bash
   ls data/issues.json data/pull_requests.json  # Raw data
   ls results/*.txt  # Analysis outputs
   ```

2. **If data is missing, fetch it:**
   ```bash
   python3 fetch_github_issues.py  # Fetches to data/
   ```

3. **Run all analysis scripts:**
   ```bash
   python3 analyze_issues.py > results/general-analysis.txt
   python3 analyze_critical_issues.py > results/critical-analysis.txt
   python3 analyze_bugfix_files.py > results/bugfix-files-analysis.txt
   ```

4. **Generate HTML after creating the analysis:**
   ```bash
   python3 generate_html.py  # Creates results/ISSUE_ANALYSIS.html with GitHub links
   ```

### Creating the Analysis

**Phase 1: Identify Top 10 Problem Areas**
- Follow Steps 1-3 in "Analysis Process" above
- Extract metrics from `results/*.txt` files
- Cross-reference to identify problem areas
- Select top 10 areas for deep-dive

**Phase 2: Deep-Dive with Raw Data**
- Follow Steps 4-8 in "Analysis Process" above
- For each of the 10 areas, write Python scripts or use jq/grep to:
  - Find relevant issues in `data/issues.json`
  - Find relevant PRs in `data/pull_requests.json`
  - Extract specific examples and evidence
  - Identify patterns and root causes

**Phase 3: Write the Report**
- Create `results/ISSUE_ANALYSIS.md`
- Follow the structure defined in this document
- Include data-backed evidence from both phases
- Add specific issue/PR numbers as examples

**Phase 4: Validate**
- Ensure all 10 areas have concrete evidence
- Verify root causes are extracted from actual issue/PR data
- Check that all claims reference specific issues/PRs
- Confirm the analysis meets all success criteria
- **Verify data-driven approach**: Every claim must reference specific data
  - No assumptions about which components are problematic
  - Priority scores calculated from actual metrics
  - Issue/PR numbers cited for all examples
  - Patterns backed by frequency counts from raw data
  - Root causes quoted from actual issue descriptions
- **No recommendations**: Analysis should describe problems, not prescribe solutions

### Tools for Deep-Dive Analysis

**Command-line tools:**
```bash
# Find issues by keyword
jq '.[] | select(.title | contains("crash")) | {number, title}' data/issues.json

# Find PRs modifying specific files
jq '.[] | select(.files_changed[]?.filename | contains("slang-ir")) | .number' data/pull_requests.json

# Count issues by label
jq '[.[] | .labels[].name] | group_by(.) | map({label: .[0], count: length})' data/issues.json
```

**Python snippets:**
- See Step 4 in Analysis Process for examples
- Can create ad-hoc scripts to analyze patterns
- Use pandas for more complex analysis if needed

## Common Pitfalls to Avoid

### 1. Making Assumptions
**Don't:**
- Assume certain components are problematic based on intuition
- Pre-select areas to investigate
- Cherry-pick data to support preconceived notions

**Do:**
- Let the data guide you to problem areas
- Follow the priority score methodology
- Be surprised by what the data shows

### 2. Ignoring Context
**Don't:**
- Look only at absolute bug counts (large components naturally have more bugs)
- Ignore LOC when comparing components
- Compare components without considering their complexity

**Do:**
- Always normalize by LOC (bugs per 1000 LOC)
- Consider component purpose (compiler core vs. utility functions)
- Look at bug fix frequency trends, not just snapshots

### 3. Insufficient Evidence
**Don't:**
- Make recommendations without citing specific issues/PRs
- Generalize from 1-2 examples
- Rely solely on metrics without examining actual issues

**Do:**
- Provide 3-5 concrete issue/PR examples per area
- Show patterns across multiple instances
- Quote actual issue descriptions and error messages
- Link metrics to real-world impact

### 4. Speculation Beyond Data
**Don't:**
- Assume root causes without evidence from issue text
- Speculate about "why" something is happening
- Make recommendations on how to fix problems

**Do:**
- Extract root causes from actual issue descriptions and error messages
- Stick to observable patterns in the data
- Focus on WHAT is happening, not WHY or HOW TO FIX
- Quote specific issue text as evidence for claimed patterns

### 5. Analysis Staleness
**Don't:**
- Use outdated analysis outputs
- Assume patterns from old data still apply
- Mix data from different time periods

**Do:**
- Re-run all analysis scripts before starting
- Note the data snapshot date in the report
- Consider trends over time, not just current state
- Update analysis regularly (quarterly recommended)

