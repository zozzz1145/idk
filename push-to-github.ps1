# ============================================================
#  一键推送到 GitHub，触发云端构建 Android APK
#  使用前提：先在 GitHub 网页新建一个【空仓库】（不要勾选 README / .gitignore / license）
#  运行方式：右键本文件 -> 使用 PowerShell 运行；或在该目录执行 powershell -File push-to-github.ps1
# ============================================================

$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

# 大文件推送缓冲
git config http.postBuffer 524288000
# 使用 Git Credential Manager：推送时自动弹出浏览器完成 GitHub 登录授权
git config credential.helper manager

Write-Host ""
Write-Host "本仓库约 470MB，推送耗时取决于上行带宽。" -ForegroundColor Yellow
Write-Host ""
$repo = Read-Host "粘贴仓库地址（例如 https://github.com/你的用户名/origami-king-demo.git）"
if ([string]::IsNullOrWhiteSpace($repo)) {
    Write-Host "未输入仓库地址，已退出。" -ForegroundColor Red
    exit 1
}
$repo = $repo.Trim()

git remote remove origin 2>$null | Out-Null
git remote add origin $repo

Write-Host ""
Write-Host "开始推送 main 分支……浏览器会弹出 GitHub 授权窗口，请登录并确认。" -ForegroundColor Cyan
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    $web = $repo -replace '\.git$', ''
    Write-Host ""
    Write-Host "推送成功。" -ForegroundColor Green
    Write-Host "打开 $web/actions 即可看到 Build Android APK 正在运行。"
    Write-Host "构建完成后在对应运行记录的 Artifacts 里下载 origami-king-android-apk。"
} else {
    Write-Host ""
    Write-Host "推送失败：请确认仓库地址正确、网络可访问 github.com，或改用个人访问令牌（PAT）方式。" -ForegroundColor Red
}
