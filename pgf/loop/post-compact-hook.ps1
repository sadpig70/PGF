# PGF-Loop PostCompact Hook
# Purpose: Back up PGF-Loop state on compaction to preserve state across sessions
# Trigger: PostCompact hook event (manual/auto)

$ErrorActionPreference = "Stop"

$stateFile = ".claude/pgf-loop-state.json"
$backupFile = ".claude/pgf-loop-state.backup.json"
$logFile = ".claude/PGF-loop-compact.log"

# Check if PGF-Loop is active
if (-not (Test-Path $stateFile)) {
    exit 0  # PGF-Loop inactive → normal exit
}

try {
    # Read hook event from stdin
    $hookInput = $null
    if (-not [Console]::IsInputRedirected) {
        $hookInput = @{}
    } else {
        $rawInput = [Console]::In.ReadToEnd()
        if ($rawInput) {
            $hookInput = $rawInput | ConvertFrom-Json
        } else {
            $hookInput = @{}
        }
    }

    # Load current state
    $state = Get-Content $stateFile -Raw -Encoding UTF8 | ConvertFrom-Json

    # Create snapshot
    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
    $trigger = if ($hookInput.trigger) { $hookInput.trigger } else { "unknown" }

    $snapshot = @{
        compacted_at   = $timestamp
        trigger        = $trigger
        iteration      = $state.iteration
        current_node   = $state.current_node
        workplan_path  = $state.workplan_path
        status_path    = $state.status_path
        project        = $state.project
        mode           = $state.mode
        summary        = $state.summary
        policy         = $state.policy
        design_path    = $state.design_path
        session_id     = $state.session_id
        max_iterations = $state.max_iterations
        retry_counts   = $state.retry_counts
    }

    # Save backup file
    $snapshot | ConvertTo-Json -Depth 5 | Set-Content $backupFile -Encoding UTF8

    # Write log entry
    $done = if ($state.summary.done) { $state.summary.done } else { 0 }
    $total = if ($state.summary.total) { $state.summary.total } else { 0 }
    $logEntry = "[$timestamp] PostCompact ($trigger) | iter=$($state.iteration) | node=$($state.current_node) | $done/$total done"
    Add-Content $logFile -Value $logEntry -Encoding UTF8

} catch {
    # Do not abort session even if PostCompact fails
    $errorLog = "[$((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss'))] PostCompact ERROR: $($_.Exception.Message)"
    Add-Content $logFile -Value $errorLog -Encoding UTF8
}

exit 0
