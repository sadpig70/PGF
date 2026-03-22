# PGF-Loop State Restore (SessionStart after compact)
# Purpose: Restore PGF-Loop state and inject into context when session resumes after compaction
# Trigger: SessionStart hook (after compact)

$ErrorActionPreference = "Stop"

$backupFile = ".claude/pgf-loop-state.backup.json"
$stateFile = ".claude/pgf-loop-state.json"

# Check if backup file exists
if (-not (Test-Path $backupFile)) {
    exit 0
}

try {
    # Load backup
    $snapshot = Get-Content $backupFile -Raw -Encoding UTF8 | ConvertFrom-Json

    # Increment iteration
    $nextIteration = [int]$snapshot.iteration + 1

    # Restore current state file
    $restored = @{
        active         = $true
        iteration      = $nextIteration
        current_node   = $snapshot.current_node
        workplan_path  = $snapshot.workplan_path
        status_path    = $snapshot.status_path
        project        = $snapshot.project
        mode           = $snapshot.mode
        restored_from  = $snapshot.compacted_at
        session_id     = $snapshot.session_id
        policy         = $snapshot.policy
        design_path    = $snapshot.design_path
        max_iterations = $snapshot.max_iterations
        retry_counts   = $snapshot.retry_counts
    }

    $restored | ConvertTo-Json -Depth 5 | Set-Content $stateFile -Encoding UTF8

    # Extract summary info
    $done = 0
    $total = 0
    if ($snapshot.summary) {
        if ($snapshot.summary.done) { $done = $snapshot.summary.done }
        if ($snapshot.summary.total) { $total = $snapshot.summary.total }
    }

    # Output restore info to stdout → inject into Claude context
    Write-Output ""
    Write-Output "[PGF-Loop] Session restored after compaction"
    Write-Output "  Project: $($snapshot.project)"
    Write-Output "  Last compacted: $($snapshot.compacted_at)"
    Write-Output "  Resuming iteration: $nextIteration"
    Write-Output "  Last node: $($snapshot.current_node)"
    Write-Output "  Progress: $done/$total nodes done"
    Write-Output "  WORKPLAN: $($snapshot.workplan_path)"
    Write-Output ""
    Write-Output "Stop Hook will automatically select the next node."

    # Delete backup file (restore complete, prevent duplicate restore)
    Remove-Item $backupFile -Force

} catch {
    Write-Output "[PGF-Loop] State restore failed: $($_.Exception.Message)"
    Write-Output "Manual recovery: check .claude\pgf-loop-state.backup.json"
}

exit 0
