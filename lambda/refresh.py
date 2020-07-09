import sys as loadPackagesByOrder
from pip._internal import main
boto3Version="1.14.14"
paramsToInstallBoto3 = "install -I -q boto3=={0} -t /tmp/ --no-cache-dir --disable-pip-version-check".format(boto3Version).split()
main(paramsToInstallBoto3)
loadPackagesByOrder.path.insert(0,'/tmp/')
import boto3
client = boto3.client('autoscaling')

def elibilityCheck(asgName):
    response = client.describe_auto_scaling_groups(
        AutoScalingGroupNames=[
            asgName,
        ]
    )
    responseDict = next(iter(response.values()))[0]
    minSize = responseDict['MinSize']
    desiredCapacity = responseDict['DesiredCapacity']
    if (minSize == 1) or (desiredCapacity == 1):
        return False
    else:
        return True
def startInstanceRefresh(asgName):
    try:
        response = response = client.start_instance_refresh(AutoScalingGroupName=asgName,Strategy='Rolling',Preferences={'MinHealthyPercentage': 80})
    except Exception as e:
        return e

def lambda_handler(event, context):
    if elibilityCheck('ring-eks-worker-asg') == True : print(startInstanceRefresh('ring-eks-worker-asg'))

