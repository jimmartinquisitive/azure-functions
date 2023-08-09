# This file enables modules to be automatically managed by the Functions service.
# See https://aka.ms/functionsmanageddependency for additional information.
#
## DO NOT LOAD 'AZ' = '10.*' AS THE MODULE IS TOO BIG AND THE AZURE FUNCTION WILL TIMEOUT ON DOWNLOADING. LOAD THE SUB MODULES INSTEAD.
## The 'Az.Storage' module version must be higher than 4.9.0. We're using the latest version of 5.x here
@{
    'Az.Accounts' = '2.*'
    'Az.Storage' = '5.*'
}
