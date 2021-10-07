# Building-Automated-and-Reliable-Systems-The-SRE-Approach

edit this to fit what we will do
![image](https://user-images.githubusercontent.com/88186084/136239372-db1e1718-071d-4e55-a3bc-0476ebc56c72.png)





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

## Testing Team Section


## Automation Team Section

