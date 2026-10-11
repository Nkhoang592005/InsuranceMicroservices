# Capture a rendered window showing the REAL build log (not a simulated build).
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$log = Get-Content -LiteralPath (Join-Path $root 'artifacts/build-output.txt') -Raw
if ($log -notmatch 'Build succeeded\.' -or $log -notmatch '0 Error\(s\)') { throw 'A successful build log is required.' }
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Bai thuc hanh 4 - Actual solution build output'
$form.ClientSize = New-Object System.Drawing.Size(1250, 760)
$form.StartPosition = 'CenterScreen'
$box = New-Object System.Windows.Forms.TextBox
$box.Multiline = $true
$box.ReadOnly = $true
$box.Dock = 'Fill'
$box.BackColor = [System.Drawing.Color]::FromArgb(20, 24, 32)
$box.ForeColor = [System.Drawing.Color]::White
$box.Font = New-Object System.Drawing.Font('Consolas', 11)
$box.Text = "Command: dotnet build InsuranceMicroservices.slnx -m:1 --nologo\r\n\r\n" + $log
$form.Controls.Add($box)
$form.Show()
$box.SelectionStart = $box.Text.Length
$box.ScrollToCaret()
[System.Windows.Forms.Application]::DoEvents()
$bitmap = New-Object System.Drawing.Bitmap($form.Width, $form.Height)
$form.DrawToBitmap($bitmap, (New-Object System.Drawing.Rectangle(0, 0, $form.Width, $form.Height)))
$bitmap.Save((Join-Path $root 'artifacts/build-result.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
$form.Close()
$form.Dispose()
Write-Output 'Saved artifacts/build-result.png from the build log window.'

