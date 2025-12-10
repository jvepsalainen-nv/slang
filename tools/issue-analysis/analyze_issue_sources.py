#!/usr/bin/env python3
"""
Analyze the source of GitHub issues:
- Extract repository references from issue text
- Categorize as downstream projects vs related infrastructure
- Issue status (open/closed) by repository
- Bug issues by repository
"""

import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from analyze_common import DATA_DIR, load_issues, load_prs

# Repositories to exclude (Slang-internal, GitHub infrastructure, personal forks)
EXCLUDE_REPOS = {
    # GitHub infrastructure
    'user-attachments/assets',
    'user-attachments/files',
    'orgs/shader-slang',
    'actions/upload-artifact',
    'benchmark-action/github-action-benchmark',

    # Slang main repos
    'shader-slang/slang',
    'shader-slang/slang.git',
    'shader-slang/slang-rhi',
    'shader-slang/slangpy',
    'shader-slang/shader-slang.github.io',
    'shader-slang/spec',
    'shader-slang/neural-shading-s25',
    'shader-slang/neural-shading-s25.git',
    'shader-slang/slang-playground',
    'shader-slang/slang-binaries',
    'shader-slang/slang-torch',
    'shader-slang/stdlib-reference',
    'shader-slang/sgl',
    'shader-slang/slang-glslang',
    'shader-slang/llvm-project',
    'shader-slang/slang-llvm',
    'shader-slang/optix-examples',
    'shader-slang/falcor-compile-perf-test',
    'shader-slang/webgpu-dawn-binaries',
    'shader-slang/slangpy-samples.git',
    'shader-slang/slang-material-modules-benchmark',

    # Slang test infrastructure
    'shader-slang/VK-GL-CTS',
    'shader-slang/swiftshader',

    # Personal forks and development repos
    'skiminki-nv/slang',
    'jhelferty-nv/slang',
    'ArielG-NV/slang',
    'csyonghe/slang',
    'theHamsta/slang',
    'Themaister/slang',
    'aleino-nv/slang',
    'Checkmate50/slang',
    'United-Visual-Researchers/slang',
    'cheneym2/slang.git',

    # Development tools/benchmarks
    'NBickford-NV/slang-compile-timer',
    'NBickford-NV/slang-compile-timer.git',
    'sporacid/shader-slang-issue',
}

# Related infrastructure (compilers, validation tools, specs)
INFRASTRUCTURE_REPOS = {
    'microsoft/DirectXShaderCompiler',
    'microsoft/hlsl-specs',
    'microsoft/DirectX-Graphics-Samples',
    'microsoft/ShaderConductor',
    'KhronosGroup/SPIRV-Tools',
    'KhronosGroup/SPIRV-Headers',
    'KhronosGroup/SPIRV-Registry',
    'KhronosGroup/GLSL',
    'KhronosGroup/glslang',
    'KhronosGroup/Vulkan-ValidationLayers',
    'gpuweb/gpuweb',
    'llvm/llvm-project',
    'NVIDIA/nvapi',
    'NVIDIA-RTX/DirectXShaderCompiler',
}

# Downstream project keywords (refined based on actual findings)
# Maps display name to search patterns
DOWNSTREAM_KEYWORDS = {
    'Falcor': r'\bfalcor\b',
    'OptiX': r'\boptix\b',
    'DXVK-Remix': r'\bdxvk[-\s]?remix\b',
    'Unreal Engine': r'\bunreal\s+engine\b|\bUE[45]\b',
    'Unity': r'\bunity\b',
    'Godot': r'\bgodot\b',
    'Bevy': r'\bbevy\b',
    'Omniverse': r'\bomniverse\b',
    'MaterialX': r'\bmaterialx\b',
    'OpenVDB': r'\bopenvdb\b',
    'Vulkan Samples': r'\bvulkan[-\s]samples\b',
    'WGPU': r'\bwgpu\b',
    'SwiftShader': r'\bswiftshader\b',
    'Mitsuba': r'\bmitsuba\b',
    'tiny-cuda-nn': r'\btiny[-\s]cuda[-\s]nn\b',
}

# Infrastructure keywords
INFRASTRUCTURE_KEYWORDS = {
    'DirectX Shader Compiler': r'\bDXC\b|\bDirectXShaderCompiler\b',
    'SPIRV-Tools': r'\bSPIRV[-\s]Tools\b|\bspirv[-\s]val\b|\bspirv[-\s]opt\b',
    'GLSL/glslang': r'\bglslang\b',
    'Vulkan Validation': r'\bvulkan[-\s]validation\b',
    'HLSL Specs': r'\bhlsl[-\s]specs\b',
    'WebGPU': r'\bwebgpu\b',
}

def is_bug_issue(issue):
    """Check if issue is a bug"""
    labels = [label['name'].lower() for label in issue.get('labels', [])]
    title = issue.get('title', '').lower()

    # Check labels
    if any(bug_label in labels for bug_label in ['bug', 'crash', 'ice', 'regression']):
        return True

    # Check title patterns
    bug_patterns = [
        r'\bcrash\b', r'\bice\b', r'\binternal compiler error\b',
        r'\bsegfault\b', r'\bsegmentation fault\b',
        r'\bvalidation error\b', r'\bassertion fail\b',
        r'\bincorrect\b', r'\bwrong\b', r'\bbroken\b',
        r'\bregression\b', r'\bbug\b', r'\bfix\b'
    ]

    return any(re.search(pattern, title) for pattern in bug_patterns)

def extract_repository_urls(text):
    """Extract GitHub/GitLab repository URLs from text"""
    if not text:
        return []

    # Regex to match GitHub/GitLab repo URLs
    # Matches: https://github.com/owner/repo or https://gitlab.com/owner/repo
    repo_pattern = r'https?://(?:github\.com|gitlab\.com)/([a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+)'

    matches = re.findall(repo_pattern, text)
    # Normalize and deduplicate
    repos = list(set(matches))

    return repos

def extract_keywords(text):
    """Extract downstream projects and infrastructure by keyword matching"""
    if not text:
        return {'downstream': [], 'infrastructure': []}

    text_lower = text.lower()
    downstream = []
    infrastructure = []

    # Search for downstream project keywords
    for project, pattern in DOWNSTREAM_KEYWORDS.items():
        if re.search(pattern, text_lower, re.IGNORECASE):
            downstream.append(project)

    # Search for infrastructure keywords
    for infra, pattern in INFRASTRUCTURE_KEYWORDS.items():
        if re.search(pattern, text_lower, re.IGNORECASE):
            infrastructure.append(infra)

    return {
        'downstream': downstream,
        'infrastructure': infrastructure
    }

def categorize_repository(repo):
    """Categorize repository as downstream, infrastructure, or excluded"""
    if repo in EXCLUDE_REPOS:
        return 'excluded'
    elif repo in INFRASTRUCTURE_REPOS:
        return 'infrastructure'
    else:
        return 'downstream'

def get_repo_display_name(repo):
    """Get display name for repository"""
    # Use the repo name as-is, but could map to friendly names if needed
    return repo

def analyze_issue_sources():
    """Analyze repository references and keyword mentions in issues"""
    issues = load_issues()

    # Statistics
    total_issues = len(issues)
    total_open = sum(1 for issue in issues if issue['state'] == 'open')
    total_closed = total_issues - total_open

    # Repository statistics by category
    downstream_repos = Counter()
    infrastructure_repos = Counter()

    # Keyword statistics
    downstream_keywords = Counter()
    infrastructure_keywords = Counter()

    # Combined statistics (for repos and keywords)
    source_open = defaultdict(int)
    source_closed = defaultdict(int)
    source_bugs = defaultdict(int)
    source_bugs_open = defaultdict(int)
    source_issues = defaultdict(list)  # Store issue details per source

    issues_with_sources = 0
    issues_with_sources_open = 0

    for issue in issues:
        is_open = issue['state'] == 'open'
        body = issue.get('body', '') or ''
        title = issue.get('title', '') or ''
        is_bug = is_bug_issue(issue)
        issue_num = issue['number']

        # Extract repository URLs and keywords
        full_text = f"{title}\n{body}"
        repos = extract_repository_urls(full_text)
        keywords = extract_keywords(full_text)

        found_sources = set()

        # Process repository URLs
        for repo in repos:
            category = categorize_repository(repo)

            # Skip excluded repos
            if category == 'excluded':
                continue

            found_sources.add(repo)

            # Categorize
            if category == 'downstream':
                downstream_repos[repo] += 1
            elif category == 'infrastructure':
                infrastructure_repos[repo] += 1

        # Process keywords
        for keyword in keywords['downstream']:
            found_sources.add(keyword)
            downstream_keywords[keyword] += 1

        for keyword in keywords['infrastructure']:
            found_sources.add(keyword)
            infrastructure_keywords[keyword] += 1

        # Track combined statistics for all sources
        for source in found_sources:
            source_open[source] += 1 if is_open else 0
            source_closed[source] += 0 if is_open else 1

            if is_bug:
                source_bugs[source] += 1
                if is_open:
                    source_bugs_open[source] += 1

            # Store issue details
            source_issues[source].append({
                'number': issue_num,
                'title': title,
                'state': issue['state'],
                'is_bug': is_bug,
                'created_at': issue['created_at'],
                'closed_at': issue.get('closed_at'),
            })

        if found_sources:
            issues_with_sources += 1
            if is_open:
                issues_with_sources_open += 1

    # Merge counters (repos + keywords)
    all_downstream = downstream_repos + downstream_keywords
    all_infrastructure = infrastructure_repos + infrastructure_keywords

    # Generate report
    output_file = Path(DATA_DIR).parent / 'results' / 'ISSUE_SOURCES.md'
    output_file.parent.mkdir(parents=True, exist_ok=True)

    with open(output_file, 'w') as f:
        f.write("# Downstream Project & Infrastructure Analysis\n\n")
        f.write("## Executive Summary\n\n")
        f.write(f"**Total Issues Analyzed**: {total_issues}\n\n")
        f.write(f"- Open: {total_open}\n")
        f.write(f"- Closed: {total_closed}\n\n")

        # Source coverage
        issues_without_sources = total_issues - issues_with_sources
        f.write(f"**Issues mentioning downstream projects or infrastructure**: {issues_with_sources} ")
        f.write(f"({issues_with_sources*100/total_issues:.1f}%)\n")
        f.write(f"- Open: {issues_with_sources_open}\n")
        f.write(f"- Closed: {issues_with_sources - issues_with_sources_open}\n\n")

        f.write(f"**Issues without project/infrastructure references**: {issues_without_sources} ")
        f.write(f"({issues_without_sources*100/total_issues:.1f}%)\n\n")

        # Category breakdown
        f.write("### Source Categories\n\n")
        f.write(f"- **Downstream Projects**: {len(all_downstream)} sources ")
        f.write(f"({len(downstream_repos)} repos, {len(downstream_keywords)} keywords)\n")
        f.write(f"- **Related Infrastructure**: {len(all_infrastructure)} sources ")
        f.write(f"({len(infrastructure_repos)} repos, {len(infrastructure_keywords)} keywords)\n\n")

        # Downstream projects table
        f.write("## Downstream Projects\n\n")
        f.write("Projects and engines that use Slang (extracted from repository URLs and keywords).\n\n")

        if all_downstream:
            f.write("| Rank | Source | Total | Open | Closed | Bugs | Bugs Open | Type |\n")
            f.write("|------|--------|-------|------|--------|------|-----------|------|\n")

            for i, (source, count) in enumerate(all_downstream.most_common(), 1):
                open_count = source_open[source]
                closed_count = source_closed[source]
                bugs = source_bugs[source]
                bugs_open = source_bugs_open[source]
                source_type = 'Repo' if source in downstream_repos else 'Keyword'
                f.write(f"| {i} | {source} | {count} | {open_count} | {closed_count} | {bugs} | {bugs_open} | {source_type} |\n")
        else:
            f.write("No downstream projects found.\n")

        f.write("\n")

        # Infrastructure table
        f.write("## Related Infrastructure\n\n")
        f.write("Compiler toolchains, validation tools, and specifications referenced in issues.\n\n")

        if all_infrastructure:
            f.write("| Rank | Source | Total | Open | Closed | Bugs | Bugs Open | Type |\n")
            f.write("|------|--------|-------|------|--------|------|-----------|------|\n")

            for i, (source, count) in enumerate(all_infrastructure.most_common(), 1):
                open_count = source_open[source]
                closed_count = source_closed[source]
                bugs = source_bugs[source]
                bugs_open = source_bugs_open[source]
                source_type = 'Repo' if source in infrastructure_repos else 'Keyword'
                f.write(f"| {i} | {source} | {count} | {open_count} | {closed_count} | {bugs} | {bugs_open} | {source_type} |\n")
        else:
            f.write("No infrastructure references found.\n")

        f.write("\n")

        # Detailed downstream project breakdown
        if all_downstream:
            f.write("## Detailed Downstream Project Breakdown\n\n")

            for source, count in all_downstream.most_common():
                source_type = 'Repository' if source in downstream_repos else 'Keyword'
                f.write(f"### {source} ({source_type})\n\n")
                f.write(f"**Total Issues**: {count}\n\n")
                f.write(f"- Open: {source_open[source]}\n")
                f.write(f"- Closed: {source_closed[source]}\n")
                f.write(f"- Bugs: {source_bugs[source]}\n")
                f.write(f"- Open Bugs: {source_bugs_open[source]}\n\n")

                # List open issues for this source
                open_issues = [iss for iss in source_issues[source] if iss['state'] == 'open']
                if open_issues:
                    f.write(f"**Open Issues** ({len(open_issues)}):\n\n")
                    for iss in sorted(open_issues, key=lambda x: x['number'], reverse=True)[:10]:
                        bug_tag = " [BUG]" if iss['is_bug'] else ""
                        f.write(f"- \\#{iss['number']}{bug_tag}: {iss['title']}\n")
                    if len(open_issues) > 10:
                        f.write(f"- ... and {len(open_issues) - 10} more\n")
                    f.write("\n")

        # Detailed infrastructure breakdown
        if all_infrastructure:
            f.write("## Detailed Infrastructure Breakdown\n\n")

            for source, count in all_infrastructure.most_common():
                source_type = 'Repository' if source in infrastructure_repos else 'Keyword'
                f.write(f"### {source} ({source_type})\n\n")
                f.write(f"**Total Issues**: {count}\n\n")
                f.write(f"- Open: {source_open[source]}\n")
                f.write(f"- Closed: {source_closed[source]}\n")
                f.write(f"- Bugs: {source_bugs[source]}\n")
                f.write(f"- Open Bugs: {source_bugs_open[source]}\n\n")

                # List open issues for this source
                open_issues = [iss for iss in source_issues[source] if iss['state'] == 'open']
                if open_issues:
                    f.write(f"**Open Issues** ({len(open_issues)}):\n\n")
                    for iss in sorted(open_issues, key=lambda x: x['number'], reverse=True)[:10]:
                        bug_tag = " [BUG]" if iss['is_bug'] else ""
                        f.write(f"- \\#{iss['number']}{bug_tag}: {iss['title']}\n")
                    if len(open_issues) > 10:
                        f.write(f"- ... and {len(open_issues) - 10} more\n")
                    f.write("\n")

        # Key Insights
        f.write("## Key Insights\n\n")

        if all_downstream:
            top_downstream = all_downstream.most_common(1)[0]
            f.write(f"- **Most referenced downstream project**: {top_downstream[0]} ({top_downstream[1]} issues)\n")

            # Find source with most open issues
            downstream_by_open = [(s, source_open[s]) for s in all_downstream.keys()]
            downstream_by_open.sort(key=lambda x: x[1], reverse=True)
            if downstream_by_open:
                f.write(f"- **Downstream project with most open issues**: {downstream_by_open[0][0]} ({downstream_by_open[0][1]} open)\n")

        if all_infrastructure:
            top_infra = all_infrastructure.most_common(1)[0]
            f.write(f"- **Most referenced infrastructure**: {top_infra[0]} ({top_infra[1]} issues)\n")

        f.write(f"\n- **Issues without project/infrastructure references**: {issues_without_sources} ")
        f.write(f"({issues_without_sources*100/total_issues:.1f}% of all issues)\n")
        f.write(f"  - These are likely general language features, build system, or documentation issues\n\n")

    print(f"Issue source analysis written to: {output_file}")
    return output_file

if __name__ == '__main__':
    analyze_issue_sources()

