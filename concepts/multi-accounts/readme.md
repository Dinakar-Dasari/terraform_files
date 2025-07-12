## creating resources in multiple aws accounts
1. To create a resource in multiple accounts we can use two ways.
   a. By using modules where we will create a module of that resource and create two separate folders and use the module by providing respective account details in the provider file.
   b. By using two provider profiles in the provider.tf file
     1. First we need to create a profile with two aws credentials in the cli                                                              **aws configure --profile dev** and add all the details \n
         **aws configure --profile prod** and add all the details   
