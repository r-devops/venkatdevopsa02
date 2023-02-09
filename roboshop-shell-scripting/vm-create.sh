
echo " Create the VM's via CLI "

catalogue user cart payment shipping 
user cart payment shipping frontend mongodb redis mysql rabbitmq dispatch

for component in frontend mongodb redis mysql rabbitmq dispatch ; do
az vm create --resource-group azure-training-2023 --name $component --image OpenLogic:CentOS-LVM:8-lvm-gen2:8.5.2022101401 --vnet-name azure-training-2023-vnet --subnet default  --admin-username centos --admin-password DevOps654321 --public-ip-address "" --size Standard_B1s
az vm auto-shutdown -g azure-training-2023 -n  $component --time 1230  
done


