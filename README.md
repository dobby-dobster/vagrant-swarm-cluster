# Vagrant Swarm cluster with RabbitMQ

Run a Swarm cluster locally using Vagrant with nodes running RabbitMQ with producer and consumer.

This will create and setup two Vagrant machines in a private network (10.0.7.0/24):

* Swarm manager: 10.0.7.10
* Swarm node (worker): 10.0.7.11

# Requirements

Install [Vagrant][vagranthome] and [Docker][dockerhome] on your machine.

Ensure you have a valid [Vagrant provider][vagrantprovider] installed.

# Setup

## Boot Vagrant machines

The first thing you need to do is clone this repo:

```
$ git clone https://github.com/dobby-dobster/vagrant-swarm-cluster.git
$ cd vagrant-swarm-cluster
```

Supported providers:

* virtualbox

## Bootstrap script

You can execute the `start_cluster.sh` script to bootstrap the Swarm cluster and create the stack.

```shell
$ chmod +x start_cluster.sh
$ ./start_cluster.
```

# The Stack

The stack by default consists of 1 x RabbitMQ , 3 x consumers and 3 x producer containers. You can increase/decrease the container count via the replicas value in docker-compose.yml. Changing the 'rabbit' service replicas value has not been tested.

The RabbitMQ container is the standard RabbitMQ image, whereas the consumer and producer are running a custom image (based off CentOS) and application. The applications are basic Python which produces and consumes messages.

The images orginate from the following repo: https://github.com/dobby-dobster/docker-rabbitmq-processor

## Validation

You can connect to the nodes using vagrant ssh.

```
vagrant ssh <manager|node1>
```

List services (from the manager):
```
vagrant@manager:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                                  PORTS
tbxvvxmpmqoy        stack_consumer      replicated          3/3                 dobbydobster/vagrant_consumer:latest   
5whqedsnklnw        stack_producer      replicated          3/3                 dobbydobster/vagrant_producer:latest   
1bpfsbtg1y2e        stack_rabbit        replicated          1/1                 rabbitmq:management                    *:5672->5672/tcp, *:15672->15672/tcp
vagrant@manager:~$ 
```

Check service log for one of the services (from the manager)
```
vagrant@manager:~$ docker service logs stack_producer | head
stack_producer.1.gynkhq1wjogn@manager    | Random string generated: C61K0GZHI0XMPMP0HKVBOCHCELMR504L
stack_producer.1.gynkhq1wjogn@manager    | Random string (C61K0GZHI0XMPMP0HKVBOCHCELMR504L) sent
stack_producer.1.gynkhq1wjogn@manager    | Sleeping for 1 seconds..
stack_producer.1.gynkhq1wjogn@manager    | Random string generated: TG1UCPDEJ5T36PDY303YWD9OYGIU3L8I
stack_producer.1.gynkhq1wjogn@manager    | Random string (TG1UCPDEJ5T36PDY303YWD9OYGIU3L8I) sent
stack_producer.1.gynkhq1wjogn@manager    | Sleeping for 1 seconds..
stack_producer.1.gynkhq1wjogn@manager    | Random string generated: RLCWHSAIIGE9IAVUBQDB2ZIIXWQPVUPM
stack_producer.1.gynkhq1wjogn@manager    | Random string (RLCWHSAIIGE9IAVUBQDB2ZIIXWQPVUPM) sent
stack_producer.1.gynkhq1wjogn@manager    | Sleeping for 1 seconds..
stack_producer.1.gynkhq1wjogn@manager    | Random string generated: XL24I5LIM6QJJ26VYSN79OP5UPQ3Q0P2
vagrant@manager:~$
```

You can access the Rabbit UI from your local machine via http://10.0.7.11:15672 using guest/guest as the credentials.

## Cleanup/Destroy

destroy_cluster.sh will remove the nodes from the swarm cluster and the destroy the vagrant resources.

```
./destroy_cluster.sh
```

[vagranthome]: https://www.vagrantup.com/docs/installation/  "Vagrant installation"
[vagrantprovider]: https://www.vagrantup.com/docs/providers/ "Vagrant providers"
[dockerhome]: https://docs.docker.com/engine/installation/  "Docker installation"
