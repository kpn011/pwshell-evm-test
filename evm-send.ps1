$ErrorActionPreference = "Stop"

$rpcUrl = $env:SEPOLIA_RPC_URL
$privateKey = $env:PRIVATE_KEY
$senderAddress = $env:SENDER_ADDRESS

$recipients = @(
    "0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B",
    "0x1Db3439a222C519ab44bb1144fC28167b4Fa6EE6",
    "0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD"
)

$randomIndex = Get-Random -Maximum $recipients.Length
$recipient = $recipients[$randomIndex]

$minAmount = 0.0001
$maxAmount = 0.001
$amount = $minAmount + (Get-Random -Minimum 0 -Maximum 1) * ($maxAmount - $minAmount)
$amountWei = [math]::Round($amount * 1000000000000000000)

$balanceBody = @{
    jsonrpc = "2.0"
    method = "eth_getBalance"
    params = @($senderAddress, "latest")
    id = 1
} | ConvertTo-Json

$balanceResponse = Invoke-RestMethod -Uri $rpcUrl -Method Post -Body $balanceBody -ContentType "application/json"
$balanceHex = $balanceResponse.result
$balance = [Convert]::ToInt64($balanceHex, 16)

if ($balance -lt $amountWei) {
    throw "Insufficient balance"
}

$nonceBody = @{
    jsonrpc = "2.0"
    method = "eth_getTransactionCount"
    params = @($senderAddress, "latest")
    id = 2
} | ConvertTo-Json

$nonceResponse = Invoke-RestMethod -Uri $rpcUrl -Method Post -Body $nonceBody -ContentType "application/json"
$nonce = $nonceResponse.result

$gasPriceBody = @{
    jsonrpc = "2.0"
    method = "eth_gasPrice"
    params = @()
    id = 3
} | ConvertTo-Json

$gasPriceResponse = Invoke-RestMethod -Uri $rpcUrl -Method Post -Body $gasPriceBody -ContentType "application/json"
$gasPrice = $gasPriceResponse.result

Write-Host "Would send $amountWei wei to $recipient"
Write-Host "Need to implement signing in PowerShell..."
