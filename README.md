# homework-project
This project contains terraform files which define AWS networking infrastructure. This platform is deisnged to host a basic single-page application which itself
needs to reach out to two external API endpoints.

Due to the limited details available and several constraints, several elements of this design have been glossed over in the interest of expediency. Though
the design is functional, several elements would need to be fleshed out with better details prior to production.

Constraints:
The primary constraints around this project include a lack of full and total details. Communication with the project's sponsor was not immediatley available,
so in the interests of efficiency, several presumptions were made. Additionally, one must not forget the purpose of the project was demonstrable in nature,
more than functional, so it has been the opinion of this author to presume conceptual demonstrability in a more expedient fashion than a protracted dialogue
would have allowed for. Incorrect presumptions should be easy to correct after the fact, and I was of the mind that returning a conceptually vialble product
was of primary importance.

Notes on the Application: This project does not deal with the application layer other than providing an infrastructure and compute resources upon which to run
that workload. The instructions for this project quite pointedly asked to create an infrastrucure upon which to host this application, and I believe I have
delivered on that request. Certainly, it would be possible to add segments to the USER_DATA sections of the instances to instruct them to perform whatever
steps might be required. Rather than delive into that topic, however, I have focused on the delivery of infrastructure.

![Alt text](2022-05-20_14-19-27.jpg?raw=true "Title")

VPC Design:
To provide a maximal horizontal scaling opportunity, we start with a base VPC CIDR of 10.0.0.0/16.

Public Subnets:
We then create a two contiguous class-C public subnets, one in each desired availability zone. Here, we use two, but more are often avaiable

Private Subnets:
We use two contiguous slash-18 CIDR blocks for our private subnets. Again, straddling two availability zones for redundancy

Interet Gateway:
We need to place an internet gateway in the VPC for public ingress/egress.

NAT Gateways:
We place a NAT Gateway in each of the two public subnets. This permits assets to acess the internet via the IGW without the need for their own public IPs.

Public Routing Tables:
The public subnets have a default route through the internet gateway. It is assumed any assets established within the public subnets will have a public IP.

Private Routing Tables:
Private subnets, default route via their respecive NAT Gateways, ensuring all egress must flow via these NAT-GWs.

Application Load Balancer:
The ALB in the public subnet is the endpoint for public access. It requires a valid security certificate, as the one used in this project is a dummy.
This is spot in the design where consultation with project sponsors would dictate aspects of this design. Normally, I would implement the AWS WAF
service with associated logging on this load-balancers, though that configuration is nuanced enough, I did not implement it in this project at this stage.

Auto-Scaling Group:
We craete an auto-scaling group which can dynamically scale the number of application servers depending on a configuration left intnetionally vague in 
this project. This would need to be addressed based on business needs and cost estimates.
