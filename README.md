# Particle_Swarm_Optimization
# Introduction:

Wireless Sensor Network (WSN) is a network which is formed with a maximum number of
sensor nodes which are positioned in an application environment to monitor the physical
entities in a target area, for example, temperature monitoring environment, water level,
monitoring pressure, and health care, and various military applications.

# Related Work :

WSNs have many research challenges and network issues when deploying the sensor
nodes to monitor the physical world
The traditional clustering algorithm LEACH uses randomized rotation with uniform clustering
of local cluster heads to increase the scalability and network performance. The lifetime of the
network has extended by utilizing a HEED clustering protocol; this formed the clustering and
cluster head selection based on the residual energy of sensor nodes and the cost of
communication from source to destination.

# Proposed PSO-Based Clustering Algorithm:
Particle Swarm Optimization (PSO) is a population-based optimization scheme. The random
solutions of the system are initialized with a population and search optimal solutions in each
generation. The potential solutions in each generation are called particles. Each particle in
PSO keeps the stored record for all its coordinates which are related to obtaining the better
solution by following the current best particles.
Fitness function of every particle is executed and the fitness value (best solution) is
calculated and stored. The fitness value of the current optimum particle is called “pbest.”
PSO optimizes the best population value that is obtained so far by any particle in the
neighbors and its location is called lbest.

When all the generated populations are considered as topological neighbors by a particular
particle, then the best value is chosen among the generated population and that particular
best value is the best solution and it is known as gbest.
The PSO always try to change the velocity of every particle towards its pbest and lbest. The
velocity is determined by random terminologies, which is having randomly generated
numbers for velocity towards pbest and lbest localities.

# Steps involved in the written algorithm:
● Adding Variables and Parameters of PSO required.
● Initialising variables’ values,particle’s best and global best.
● Calculating velocity and energy lost for transmission of information
● Calculating least cost using Cost Function and updating that particle having least
cost as cluster head.
● Cluster head transmits data to base station and cluster moves towards destination
optimising total energy.
