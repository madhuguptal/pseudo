// TODO add clean up of previous builds to save space on Jenkins
if ( BRANCH_NAME != "develop-cf") {

    node('DotNetAgent') { 
        deleteDir()
        stage('Checkout') {
                // enables submodule checkout
                checkout([
                    $class: 'GitSCM', 
                    branches: scm.branches, 
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [[
                    $class: 'SubmoduleOption', 
                    disableSubmodules: false, 
                    parentCredentials: true, 
                    recursiveSubmodules: true, 
                    reference: '', 
                    trackingSubmodules: false
                    ]], 
                    submoduleCfg: [], 
                    userRemoteConfigs: scm.userRemoteConfigs
                ])
                bat 'git rev-parse HEAD > commit'
                stash name:"commit", includes:"commit"
        }
        stage('Build'){

            // Download the MaxMind DB first
            powershell """
                \$Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                \$Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName \$Date).Credentials
                \$env:AWS_ACCESS_KEY_ID = \$Creds.AccessKeyId
                \$env:AWS_SECRET_ACCESS_KEY = \$Creds.SecretAccessKey
                \$env:AWS_SESSION_TOKEN = \$Creds.SessionToken
                Copy-S3Object -Region \"ap-southeast-1\" -BucketName bkash-maxmind -Key GeoIP2-City.mmdb -LocalFile GeoIP2-City.mmdb -AccessKey \$Creds.AccessKeyId -SecretKey \$Creds.SecretAccessKey -SessionToken \$Creds.SessionToken"""
            

            bat 'nuget restore bKash.API.sln'
            dir("bKash.API.Authentication"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Authentication.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "dotnet publish -o ./published/"
                // Copy the MaxMind DB file to /Content
                bat "xcopy /y ..\\GeoIP2-City.mmdb published\\Content\\"
            }
            dir("bKash.API.Middleware"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "dotnet publish -o ./published/"
                // Copy the MaxMind DB file to /Content
                bat "xcopy /y ..\\GeoIP2-City.mmdb published\\Content\\"
            }
            dir("bKash.API.Intelligence.NetCore"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Intelligence.NetCore.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "dotnet publish -o ./published/"
                // Copy the MaxMind DB file to /Content
                bat "xcopy /y ..\\GeoIP2-City.mmdb published\\Content\\"
            }
            dir("bKash.API.Middleware.PushNotification"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.PushNotification.csproj /p:Configuration=Release;DebugSymbols=True /t:Rebuild /m"
                bat "dotnet publish -o ./published/"
            }
            dir("bKash.API.Middleware.Common"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.Common.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "dotnet publish -o ./published/"
            }
            dir("bKash.API.Middleware.CPS"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.CPS.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "dotnet publish -o ./published/"
            }

            dir("bKash.API.RewardTransaction.Processor"){
                bat "dotnet restore"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.RewardTransaction.Processor.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "dotnet publish -o ./published/"
            }

            // Windows
            dir("bKash.API.MIDDLEWARE.BI.471"){
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.BI.471.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.BI.471.csproj /p:Configuration=Release;DebugSymbols=True /t:WebPublish /p:publishUrl=\"published\" /p:DeployOnBuild=true /p:WebPublishMethod=FileSystem /m"
                dir('published\\roslyn'){} //make a dir for roslyn
                // due to issues with publish process roslyn gets missed. This copies it back.
                try { // some builds don't need roslyn it seems
                    bat "xcopy /s /y /R bin\\roslyn\\*.* published\\bin\\roslyn\\"
                } catch(err) {}
            }
            zip zipFile:"bKash.API.MIDDLEWARE.BI.471.zip", dir:"bKash.API.MIDDLEWARE.BI.471\\published"
                        powershell """
                Write-S3Object -CannedACLName bucket-owner-full-control -Region \"ap-southeast-1\" -BucketName bkash-builds-bkash -File bKash.API.MIDDLEWARE.BI.471.zip -Key ${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.MIDDLEWARE.BI.471.zip"""
            

            // Windows
            dir("bKash.API.CPS.Callback"){
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.CPS.Callback.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.CPS.Callback.csproj /p:Configuration=Release;DebugSymbols=True /t:WebPublish /p:publishUrl=\"published\" /p:DeployOnBuild=true /p:WebPublishMethod=FileSystem /m"
                dir('published\\roslyn'){} //make a dir for roslyn
                // due to issues with publish process roslyn gets missed. This copies it back.
                try { // some builds don't need roslyn it seems
                    bat "xcopy /s /y /R bin\\roslyn\\*.* published\\bin\\roslyn\\"
                } catch(err) {}
            }
            zip zipFile:"bKash.API.CPS.Callback.zip", dir:"bKash.API.CPS.Callback\\published"
                        powershell """
                Write-S3Object -CannedACLName bucket-owner-full-control -Region \"ap-southeast-1\" -BucketName bkash-builds-bkash -File bKash.API.CPS.Callback.zip -Key ${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.CPS.Callback.zip"""
            

            // Windows
            dir("bKash.API.Middleware.TransactionHistory"){
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.TransactionHistory.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.TransactionHistory.csproj /p:Configuration=Release;DebugSymbols=True /t:WebPublish /p:publishUrl=\"published\" /p:DeployOnBuild=true /p:WebPublishMethod=FileSystem /m"
                dir('published\\roslyn'){} //make a dir for roslyn
                // due to issues with publish process roslyn gets missed. This copies it back.
                try { // some builds don't need roslyn it seems
                    bat "xcopy /s /y /R bin\\roslyn\\*.* published\\bin\\roslyn\\"
                } catch(err) {}
            }
            zip zipFile:"bKash.API.Middleware.TransactionHistory.zip", dir:"bKash.API.Middleware.TransactionHistory\\published"
                        powershell """
                Write-S3Object -CannedACLName bucket-owner-full-control -Region \"ap-southeast-1\" -BucketName bkash-builds-bkash -File bKash.API.Middleware.TransactionHistory.zip -Key ${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.Middleware.TransactionHistory.zip"""

            // Windows
            dir("bKash.API.Middleware.CPS.PushNotification"){
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.CPS.PushNotification.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Middleware.CPS.PushNotification.csproj /p:Configuration=Release;DebugSymbols=True /t:WebPublish /p:publishUrl=\"published\" /p:DeployOnBuild=true /p:WebPublishMethod=FileSystem /m"
                dir('published\\roslyn'){} //make a dir for roslyn
                // due to issues with publish process roslyn gets missed. This copies it back.
                try { // some builds don't need roslyn it seems
                    bat "xcopy /s /y /R bin\\roslyn\\*.* published\\bin\\roslyn\\"
                } catch(err) {}
            }
            
            zip zipFile:"bKash.API.Middleware.CPS.PushNotification.zip", dir:"bKash.API.Middleware.CPS.PushNotification\\published"
                        powershell """
                Write-S3Object -CannedACLName bucket-owner-full-control -Region \"ap-southeast-1\" -BucketName bkash-builds-bkash -File bKash.API.Middleware.CPS.PushNotification.zip -Key ${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.Middleware.CPS.PushNotification.zip"""


            dir("bKash.API.Analytics.Processor.WindowsService"){ // this is a windows service
                bat "\"${tool 'Slave-MSBuild 15'}\" bKash.API.Analytics.Processor.WindowsService.csproj /p:Configuration=Release;DebugSymbols=True /t:Build /m"
            }


        }
        
        stage('BuildAppAMI'){
            dir("bKash.Packer/templates"){
                powershell '''
                    $ProgressPreference = "SilentlyContinue"
                    Invoke-WebRequest -uri https://s3-ap-southeast-1.amazonaws.com/tigerspike-scripts/public-drop/packer-1.3.3.exe -OutFile packer.exe
                    pwd
                    ls
                    '''
                try {
                    bat "del manifest.*.json /Q /F"
                } catch(err) {}
                parallel(
                    "Linux":{
                        parallel(
                            "Middleware": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    pwd
                                    ls
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'middleware.linux.json')'''
                                    stash name:"middlewareami", includes:"manifest.middleware.json"
                                }
                            },
                            "RewardTransactionProcessor": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'reward.linux.json')'''
                                    stash name:"rewardami", includes:"manifest.reward.json"
                                }
                            },
                            "MiddlewarePushNotification": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'middlewarepushnotification.linux.json')'''
                                    stash name:"middlewarepushnotification", includes:"manifest.middlewarepushnotification.json"
                                }
                            },
                            "Auth": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'auth.linux.json')'''
                                    stash name:"authami", includes:"manifest.auth.json"
                                }
                            }
                        )
                        parallel(
                            "IntelProxy": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'intelproxy.linux.json')'''
                                    stash name:"intelproxyami", includes:"manifest.intelproxy.json"
                                }
                            },
                            "MiddlewareCommon": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'middlewarecommon.linux.json')'''
                                    stash name:"middlewarecommonami", includes:"manifest.middlewarecommon.json"
                                }
                            },
                            "CPSAPI": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell '''
                                    $Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    $Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName $Date).Credentials
                                    $env:AWS_ACCESS_KEY_ID = $Creds.AccessKeyId
                                    $env:AWS_SECRET_ACCESS_KEY = $Creds.SecretAccessKey
                                    $env:AWS_SESSION_TOKEN = $Creds.SessionToken
                                    $env:AWS_POLL_DELAY_SECONDS = 100
                                    $env:AWS_MAX_ATTEMPTS = 30
                                    $env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'cpsapi.linux.json')'''
                                    stash name:"cpsapiami", includes:"manifest.cpsapi.json"
                                }
                            }
                        )
                    },
                    "Windows":{
                        parallel(
                            "CPSTEP": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell """
                                    \$Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    \$Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName \$Date).Credentials
                                    \$env:AWS_ACCESS_KEY_ID = \$Creds.AccessKeyId
                                    \$env:AWS_SECRET_ACCESS_KEY = \$Creds.SecretAccessKey
                                    \$env:AWS_SESSION_TOKEN = \$Creds.SessionToken
                                    \$env:PACKAGE_S3_LOCATION=\"${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.Middleware.CPS.PushNotification.zip\"
                                    \$env:AWS_POLL_DELAY_SECONDS = 100
                                    \$env:AWS_MAX_ATTEMPTS = 30
                                    \$env:AWS_MAX_RETRIES=10
                                    & './packer.exe' @('build', 'cpstep.windows.json')"""
                                    stash name:"cpstepami", includes:"manifest.cpstep.json"
                                }
                            },
                            
                            "TransactionHistory": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell """
                                    \$Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    \$Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName \$Date).Credentials
                                    \$env:AWS_ACCESS_KEY_ID = \$Creds.AccessKeyId
                                    \$env:AWS_SECRET_ACCESS_KEY = \$Creds.SecretAccessKey
                                    \$env:AWS_SESSION_TOKEN = \$Creds.SessionToken
                                    \$env:AWS_POLL_DELAY_SECONDS = 100
                                    \$env:AWS_MAX_ATTEMPTS = 30
                                    \$env:AWS_MAX_RETRIES=10
                                    \$env:PACKAGE_S3_LOCATION=\"${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.Middleware.TransactionHistory.zip\"
                                    & './packer.exe' @('build', 'transactionhistory.windows.json')"""
                                    stash name:"transactionhistoryami", includes:"manifest.transactionhistory.json"
                                }
                            }
                        )
                        parallel(
                            "CPSCallBack": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell """
                                    \$Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    \$Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName \$Date).Credentials
                                    \$env:AWS_ACCESS_KEY_ID = \$Creds.AccessKeyId
                                    \$env:AWS_SECRET_ACCESS_KEY = \$Creds.SecretAccessKey
                                    \$env:AWS_SESSION_TOKEN = \$Creds.SessionToken
                                    \$env:AWS_POLL_DELAY_SECONDS = 100
                                    \$env:AWS_MAX_ATTEMPTS = 30
                                    \$env:AWS_MAX_RETRIES=10
                                    \$env:PACKAGE_S3_LOCATION=\"${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.CPS.Callback.zip\"
                                    & './packer.exe' @('build', 'cpscallback.windows.json')"""
                                    stash name:"cpscallbackami", includes:"manifest.cpscallback.json"
                                }
                            },
                            "MIDDLEWAREBI": {
                                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                                    powershell """
                                    \$Date = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
                                    \$Creds = (Use-STSRole -Region "ap-southeast-1" -RoleArn "arn:aws:iam::156094812340:role/jenkins" -RoleSessionName \$Date).Credentials
                                    \$env:AWS_ACCESS_KEY_ID = \$Creds.AccessKeyId
                                    \$env:AWS_SECRET_ACCESS_KEY = \$Creds.SecretAccessKey
                                    \$env:AWS_SESSION_TOKEN = \$Creds.SessionToken
                                    \$env:AWS_POLL_DELAY_SECONDS = 100
                                    \$env:AWS_MAX_ATTEMPTS = 30
                                    \$env:AWS_MAX_RETRIES=10
                                    \$env:PACKAGE_S3_LOCATION=\"${BRANCH_NAME}/${BUILD_NUMBER}/bKash.API.MIDDLEWARE.BI.471.zip\"
                                    & './packer.exe' @('build', 'middlewarebi.windows.json')"""
                                    stash name:"middlewarebiami", includes:"manifest.middlewarebi.json"
                                }
                            }
                        )
                    }
                )
            }
        }
    
    }
    
    stage('Deploy') { 
        node('master'){
            deleteDir()
            // enables submodule checkout
            checkout([
                $class: 'GitSCM', 
                branches: scm.branches, 
                doGenerateSubmoduleConfigurations: false, 
                extensions: [[
                $class: 'SubmoduleOption', 
                disableSubmodules: false, 
                parentCredentials: true, 
                recursiveSubmodules: true, 
                reference: '', 
                trackingSubmodules: false
                ]], 
                submoduleCfg: [], 
                userRemoteConfigs: scm.userRemoteConfigs
            ])
            if (BRANCH_NAME == "sit"){
                sh 'git rev-parse HEAD > commit'
                stash name:"commit", includes:"commit"
            }
            dir ('bKash.Infra/'){

            
                if (BRANCH_NAME != "develop-cf"){

                    // stores all the AMI parameters
                    def parameters = [:]
                    /*
                    def middlewareAMI = 'ami-03ae8c30de3d69386'
                    parameters["pMiddlewareAMI"] = middlewareAMI
                    

                    def rewardAMI = 'ami-0372f58eb20fdd901'
                    parameters["pRewardAMI"] = rewardAMI

                    def middlewarepushnotificationAMI = 'ami-0a98389ae0f420cbe'
                    parameters["pMiddlewarepushnotificationAMI"] = middlewarepushnotificationAMI
                    

                    def intelproxyAMI = 'ami-09b5b931ec4d874fd'
                    parameters["pIntelProxyAMI"] = intelproxyAMI
                    

                    def middlewarecommonAMI = 'ami-0edfc543bcea4a1aa'
                    parameters["pMiddlewareCommonServiceAMI"] = middlewarecommonAMI
                    

                    def cpscallbackAMI = 'ami-0b9157043f1f954b1'
                    parameters["pCPSCallBackAMI"] = cpscallbackAMI
					

                    def middlewarebiami = 'ami-0b971d41dd042c60f'
                    parameters["pMIDDLEWAREBIAMI"] = middlewarebiami
                    

                    def authAMI = 'ami-0d59dae05c673b0f3'
                    parameters["pAuthAMI"] = authAMI
                    

                    def cpsAMI = 'ami-07a37f627df7a0db6'
                    parameters["pCPSAPIAMI"] = cpsAMI
                    

                    def cpstepAMI = 'ami-04ae64232ca5c565f'
                    parameters["pCPSTEPAMI"] = cpstepAMI
                    

                    def transactionhistoryAMI = 'ami-0d73975e72a5f03d1'
                    parameters["pTransactionHistoryAMI"] = transactionhistoryAMI
                    */

                    // update middleware ami
                    unstash name:"middlewareami"
                    def middleware = readJSON file: 'manifest.middleware.json'
                    def middlewareAMI = middleware['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pMiddlewareAMI"] = middlewareAMI

                    unstash name:"rewardami"
                    def reward = readJSON file: 'manifest.reward.json'
                    def rewardAMI = reward['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pRewardAMI"] = rewardAMI

                    unstash name:"middlewarepushnotification"
                    def middlewarepushnotification = readJSON file: 'manifest.middlewarepushnotification.json'
                    def middlewarepushnotificationAMI = middlewarepushnotification['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pMiddlewarepushnotificationAMI"] = middlewarepushnotificationAMI

                    unstash name:"intelproxyami"
                    def intelproxy = readJSON file: 'manifest.intelproxy.json'
                    def intelproxyAMI = intelproxy['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pIntelProxyAMI"] = intelproxyAMI

                    unstash name:"middlewarecommonami"
                    def middlewarecommon = readJSON file: 'manifest.middlewarecommon.json'
                    def middlewarecommonAMI = middlewarecommon['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pMiddlewareCommonServiceAMI"] = middlewarecommonAMI

                    unstash name:"cpscallbackami"
                    def cpscallback = readJSON file: 'manifest.cpscallback.json'
                    def cpscallbackAMI = cpscallback['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pCPSCallBackAMI"] = cpscallbackAMI

                    unstash name:"middlewarebiami"
                    def middlewarebi = readJSON file: 'manifest.middlewarebi.json'
                    def middlewarebiami = middlewarebi['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pMIDDLEWAREBIAMI"] = middlewarebiami

                    unstash name:"authami"
                    def auth = readJSON file: 'manifest.auth.json'
                    def authAMI = auth['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pAuthAMI"] = authAMI

                    unstash name:"cpsapiami"
                    def cps = readJSON file: 'manifest.cpsapi.json'
                    def cpsAMI = cps['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pCPSAPIAMI"] = cpsAMI

                    unstash name:"cpstepami"
                    def cpstep = readJSON file: 'manifest.cpstep.json'
                    def cpstepAMI = cpstep['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pCPSTEPAMI"] = cpstepAMI

                    unstash name:"transactionhistoryami"
                    def transactionhistory = readJSON file: 'manifest.transactionhistory.json'
                    def transactionhistoryAMI = transactionhistory['builds'].find{ it.artifact_id =~ "ap-southeast-1:.+"}['artifact_id'].split(",").find{ it =~ "ap-southeast-1:.+"}.split(":")[1]
                    parameters["pTransactionHistoryAMI"] = transactionhistoryAMI
                    

                    // read the param file and update it to have the new AMI values
                    def devparams = readJSON file: 'parameters/dev.json'
                    devparams["Parameters"] = devparams["Parameters"] + parameters
                    writeJSON file: 'parameters/dev.json', json: devparams

                    def devbparams = readJSON file: 'parameters/devb.json'
                    devbparams["Parameters"] = devbparams["Parameters"] + parameters
                    writeJSON file: 'parameters/devb.json', json: devbparams

                    def qabparams = readJSON file: 'parameters/qab.json'
                    qabparams["Parameters"] = qabparams["Parameters"] + parameters
                    writeJSON file: 'parameters/qab.json', json: qabparams

                    def sitparams = readJSON file: 'parameters/sit.json'
                    sitparams["Parameters"] = sitparams["Parameters"] + parameters
                    writeJSON file: 'parameters/sit.json', json: sitparams

                    def uatparams = readJSON file: 'parameters/uat.json'
                    uatparams["Parameters"] = uatparams["Parameters"] + parameters
                    writeJSON file: 'parameters/uat.json', json: uatparams

                    def stagingparams = readJSON file: 'parameters/staging.json'
                    stagingparams["Parameters"] = stagingparams["Parameters"] + parameters
                    writeJSON file: 'parameters/staging.json', json: stagingparams

                    def liveparams = readJSON file: 'parameters/live.json'
                    liveparams["Parameters"] = liveparams["Parameters"] + parameters
                    writeJSON file: 'parameters/live.json', json: liveparams

                }


                sh '''#!/bin/bash
                session_name="jenkins-`date +%Y%m%d`"
                sts=( $(
                    aws sts assume-role \
                    --role-arn "arn:aws:iam::156094812340:role/jenkins" \
                    --role-session-name "$session_name" \
                    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
                    --output text
                ) )

                export AWS_ACCESS_KEY_ID=${sts[0]}
                export AWS_SECRET_ACCESS_KEY=${sts[1]}
                export AWS_SESSION_TOKEN=${sts[2]} ${@:2}

                aws cloudformation package \
                    --template-file bkash.yaml  \
                    --output-template-file bkash-packaged.yaml \
                    --s3-bucket cicd-infrastructurebucket-37kv0p5llgir \
                    --region ap-southeast-1
                rm infrastructure.zip || true
                ''' // TODO setup for bKash account details
                zip zipFile:"infrastructure.zip", glob:"bkash-packaged.yaml, parameters/*.json"
                def s3Path = ""
                //if (BRANCH_NAME == "develop") s3Path = "s3://cicd-infrastructurebucket-37kv0p5llgir/dev/infrastructure.zip"
                if (BRANCH_NAME == "sit") s3Path = "s3://cicd-infrastructurebucket-37kv0p5llgir/dev/infrastructure.zip"
                if (BRANCH_NAME == "devb") s3Path = "s3://cicd-infrastructurebucket-37kv0p5llgir/devb/infrastructure.zip"
                if (BRANCH_NAME == "develop-cf") s3Path = "s3://cicd-infrastructurebucket-37kv0p5llgir/devcf/infrastructure.zip"
                if (BRANCH_NAME == "master") s3Path = "s3://cicd-infrastructurebucket-37kv0p5llgir/prod/infrastructure.zip"

                //This is a work around - we should probably package up the infra cloudformation and stash it in the dotnet park and unstash it here.
                unstash name:"commit"
                def commit = readFile('commit').trim()
                sh """#!/bin/bash
                session_name="jenkins-`date +%Y%m%d`"
                sts=( \$(
                    aws sts assume-role \
                    --role-arn "arn:aws:iam::156094812340:role/jenkins" \
                    --role-session-name "\$session_name" \
                    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
                    --output text
                ) )

                export AWS_ACCESS_KEY_ID=\${sts[0]}
                export AWS_SECRET_ACCESS_KEY=\${sts[1]}
                export AWS_SESSION_TOKEN=\${sts[2]} \${@:2}

                aws s3 cp --metadata codepipeline-artifact-revision-summary=${commit} infrastructure.zip ${s3Path}

                """
                
            }
            echo 'Deploying....'
        }
    }
}