1. To create a resource in multiple accounts we can use two ways. 
    1. Create a reusable **module.**
        - Then in two different **Terraform root folders** (e.g., `dev/` and `prod/`), you call the same module but configure a             different provider (account/region/etc.).
    2. Using multiple provider profiles in one config (provider.tf file)
        1. First we need to create a profile with two aws credentials in the cli 
            1. **aws configure --profile dev** and add all the details
            2.  **aws configure --profile prod** and add all the details
        2. In [provider.tf](http://provider.tf) file add two provider fields with different profiles.
        3. To tell terraform on which accounts it needs to create a particular resource. Use 
            1. provider = aws.dev in that resource
