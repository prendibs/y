#requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateRange(1, 480)][int]$Minutes = 120,
    [ValidateRange(5, 300)][int]$IntervalSeconds = 30,
    [switch]$Check
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
if (-not ('LabVmActiveNative' -as [type])) {
    Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
public static class LabVmActiveNative {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
'@
}

if ($Check) {
    if ([LabVmActiveNative]::SetThreadExecutionState(3) -eq 0) {
        throw 'Pemeriksaan API wake gagal. Tidak ada tombol yang dikirim.'
    }
    Write-Output 'CHECK OK. Dependensi dan API wake tersedia. Tidak ada tombol yang dikirim.'
    return
}

Write-Host '=== JALANKAN HANYA DI POWERSHELL DALAM VM LAB ===' -ForegroundColor Yellow
Write-Host 'F15 dikirim ke aplikasi aktif di VM. Tekan Ctrl+C untuk berhenti.'
Write-Host 'Aktivitas ini belum membuktikan bahwa penyedia lab mengenalinya.'
for ($countdown = 5; $countdown -ge 1; $countdown--) {
    Write-Host ("Mulai dalam {0} detik..." -f $countdown)
    Start-Sleep -Seconds 1
}

$clock = [Diagnostics.Stopwatch]::StartNew()
$deadline = [TimeSpan]::FromMinutes($Minutes)
while ($clock.Elapsed -lt $deadline) {
    # Tanpa CONTINUOUS, panggilan ini hanya memperbarui timer idle saat ini.
    if ([LabVmActiveNative]::SetThreadExecutionState(3) -eq 0) {
        throw 'API wake gagal. Skrip dihentikan.'
    }
    [System.Windows.Forms.SendKeys]::SendWait('{F15}')
    Write-Host ('{0:HH:mm:ss} F15 dikirim sebagai aktivitas di VM.' -f (Get-Date))
    $nextTick = $clock.Elapsed.Add([TimeSpan]::FromSeconds($IntervalSeconds))
    if ($nextTick -gt $deadline) { $nextTick = $deadline }
    while ($clock.Elapsed -lt $nextTick) {
        $remainingMs = ($nextTick - $clock.Elapsed).TotalMilliseconds
        if ($remainingMs -gt 0) {
            Start-Sleep -Milliseconds ([int][Math]::Min(1000, [Math]::Ceiling($remainingMs)))
        }
    }
}
$clock.Stop()
Write-Host 'Durasi selesai. Skrip berhenti.'
