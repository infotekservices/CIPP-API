using namespace System.Net

Function Invoke-ExecCopyForSent {
    <#
    .FUNCTIONALITY
        Entrypoint
    .ROLE
        Exchange.Mailbox.ReadWrite
    #>
    [CmdletBinding()]
    param($Request, $TriggerMetadata)

    $APIName = $Request.Params.CIPPEndpoint
    Write-LogMessage -headers $Request.Headers -API $APINAME -message 'Accessed this API' -Sev 'Debug'


    # Write to the Azure Functions log stream.
    Write-Host 'PowerShell HTTP trigger function processed a request.'


    # Interact with query parameters or the body of the request.
    Try {
        $MessageCopyForSentAsEnabled = if ($request.query.MessageCopyForSentAsEnabled -eq 'false') { 'false' } else { 'true' }
        $MessageResult = Set-CIPPMessageCopy -userid $Request.query.id -tenantFilter $Request.query.TenantFilter -APIName $APINAME -Headers $Request.Headers -MessageCopyForSentAsEnabled $MessageCopyForSentAsEnabled
        $Results = [pscustomobject]@{'Results' = "$MessageResult" }
    } catch {
        $Results = [pscustomobject]@{'Results' = "set MessageCopyForSentAsEnabled to $MessageCopyForSentAsEnabled failed - $($_.Exception.Message)" }
    }

    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $Results
        })

}
