# Building Automated and Reliable Systems: *The SRE Approach*

For our final week of training, we have been tasked to create a reliable system using all the tools and techniques we have learnt so far.

The end goal is to create a fully automated system that will push changes to an app on the localhost onto the public, live app. Whilst that is happening the app will also be monitored and tested in order to ensure the reliablity and security of the system, alerting us of any changes to the traffic or CPU utilisation.

### The Team:
- **[Akunma](https://github.com/andujiuba)**
- **[Amy](https://github.com/am93596)**
- **[Ioana](https://github.com/ioanan11)**
- **[Kieron](https://github.com/sc18kg)**
- **[Michael](https://github.com/om1chael)**
- **[Sacha](https://github.com/sachadorf1)**
- **[Viktor](https://github.com/ViMitre)**
- **[Will](https://github.com/Mo0rBy)**
- **[Zeeshan](https://github.com/ZeeshanJ99)**

## OVERVIEW
### Here is a complete diagram, detailing the different parts of this project and how they all fit together

![image](https://user-images.githubusercontent.com/88186581/136984377-dea26840-db63-43c7-aa8c-83933c9aaf8f.png)


![image](https://user-images.githubusercontent.com/88186084/136238993-0cfbb9d0-3009-4ba3-b9b9-7f8bc8a1c64a.png)


![image](https://user-images.githubusercontent.com/88186084/136239065-448783f5-304d-45ba-b61f-bc53178e4a5d.png)


## Monitoring Team Section
### Setting up Prometheus
- Launch an EC2 instance from `sre_promethus_grafa` AMI - use the `sre_shahrukh_app security group
- ssh into the instance
- `cd sre`
- `sudo docker run -p 9090:9090 -d -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus`
- Paste the public IP of the instance into your browser, followed by `:9090`
- `sudo docker ps`
- `cat prometheus.yml` - CronJob running behind the scenes every 5 seconds to scrape the data
- need to monitor another instance which has k8s on it - make a new job to target the ec2
- that ec2 needs to give us permission to scrape
- k8s cluster to run the jobs
- then run `sudo docker run -d --name=sregrafana -p 80:3000 grafana/grafana` to set up grafana on the instance - this will open on localhost
- open `localhost` in your browser
  - grafana username: `admin`
  - grafana password: `admin`
  - reset password to: `grafana`

------------------------

## Testing Team Section

![image](https://user-images.githubusercontent.com/88186581/136989926-49c928dd-e172-4940-bdef-881004559ddc.png)

-----------------------------------

## Automation Team Section

-----------------------------------

## What to expect at Deloitte

An article on Deloitte's website describes the first few weeks at the company as being about adapting, integrating, getting to know the company, and most importantly - learning. Starting at Deloitte is like easing into the shallow pool, learning how to paddle, to swim, and then gliding into the deep. So, if you’re nervous about the level of work expected from you – don’t. You won’t be expected to know everything, and you won’t be expected to make big contributions straightaway.

https://www.youtube.com/watch?v=r_xv1Y6qt84

-------------------------------------------------------------------

### Useful skills as an SRE at Deloitte

At Deloitte, a senior SRE should be adaptable to various technologies in the Kubernetes/Docker,Cloud such as AWS,Azure, Puppet (we've replaced with ansible as its better), GIT, Terraform and automation via scripting in powershell, bash and python and CI/CD tools such as Jenkins.

A Deloitte job description of an experienced SRE dictates that the following responsibilities will need to be performed in the job role

Responsibilities:

- Improve and refine existing cloud infrastructure, based mainly on Kubernetes over AWS EKS
- Champion and subsequently introduce new technologies and improve CI/CD workflows
- Ensure process repeatability, track/document any changes to infrastructure, assist development teams during deployment/downtime activities
- Work with QA and test automation engineers to develop and maintain a robust test infrastructure
- Design architectural solutions for product improvements and feature requests
- Design procedures for system troubleshooting, maintenance and logging
- Perform root cause analysis for production errors
- Help ensure the team continues to evolve and improve in everything we do, and how we do it

-------------------------------------------------------------------------------

### Some great links to learn more about our role as an SRE at Deloitte

- https://www2.deloitte.com/lu/en/pages/risk/articles/sre-its-not-about-numbers-its-about-customer-satisfaction.html - podcast about our role as an SRE in Deloitte's working structure

![image](https://user-images.githubusercontent.com/88186084/136794281-5aa2f47f-e50a-4652-88bd-61d83aea76d4.png)


- https://www2.deloitte.com/content/dam/Deloitte/lu/Documents/risk/lu-sre-it-not-about-numbers.pdf - Transcription of podcast above

- https://www2.deloitte.com/us/en/pages/technology/articles/cloud-container-technology.html

- https://www2.deloitte.com/uk/en/pages/careers/articles/respect-and-inclusion.html - Deloitte UK core values












