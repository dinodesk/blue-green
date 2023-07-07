# blue-green
Sample code for blue green deployment. This project would get deployed in ECS container and pull data fom Aurora MySQL.
:::mermaid
graph LR

subgraph AWS VPC
    EC2[EC2 Deploy Instance ]
    ECR(ECR)
    ECS[ECS Cluster]
    TG1[Target Group Blue]
    TG2[Target Group Green]
    AuroraDB[Aurora DB Blue]
    AuroraDBg[Aurora DB Green]
    PublicURL[Public url]
    TestURL[Private url]
end

EC2 -- Build --> Jenkins
Jenkins -- Deploy --> ECR
PublicURL --Load Balancer --> TG1
ECS-- services -->TG1
ECS-- services -->TG2

TestURL -- Load Balancer --> TG2

TG1 -- Connects --> AuroraDB
TG2 -- Connects --> AuroraDBg

:::
