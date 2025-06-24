/*********************************************
 * OPL 22.1.1.0 Model
 * Author: naeem
 * Creation Date: Nov 28, 2023 at 2:33:28 AM
 *********************************************/
// index
range Jobs = 1..3;
range Vehicles = 1..3;
range Nodes = 0..3;

// Parameters
int c[Nodes][Nodes] = ...;  // Cost matrix
int t[Nodes][Nodes] = ...;  // Time matrix
int p[Jobs] = ...;          // Processing times
int w[Jobs] = ...;          // Penalties for tardiness
int d[Jobs] = ...;          // Due dates
int F = ...;                // Fixed cost for vehicle use
int Q[Vehicles] = ...;      // Vehicle capacities
int M = ...;                // Big M

// Decision variables
dvar boolean x[Nodes][Nodes][Vehicles];
dvar boolean y[Vehicles];
dvar boolean A[Jobs][Jobs];
dvar float+ S[Vehicles];
dvar float+ T[Jobs];
dvar float+ D[Jobs];

// Objective
minimize
  sum(i in Nodes, j in Nodes, k in Vehicles) c[i][j] * x[i][j][k] + F * sum(k in Vehicles) y[k] + sum(i in Jobs) w[i] * T[i];

// Constraints
subject to {

  // Constraints 1
  forall(i in Jobs)
    sum(k in Vehicles) sum(j in Nodes : j != i) x[i][j][k] == 1; //Every job is served by exactly one vehicle
   
  // Constraints 2
    forall(k in Vehicles)
       sum(i in Nodes) sum(j in Nodes : j != i) x[i][j][k] <= Q[k]*y[k] + y[k];  // Each vehicle's capacity is not exceeded
   
  // Constraints 3
  forall(k in Vehicles)
    sum(j in Nodes) x[0][j][k] == y[k]; //  A vehicle is used if it makes any trips
   
  // Constraint 4
  forall(h in Nodes, k in Vehicles)
    sum(i in Nodes) x[i][h][k] == sum(j in Nodes) x[h][j][k]; //i in nodes // Flow conservation for each job and vehicle
   
  // Constraints 5
  forall(i in Jobs, j in Jobs : i != j) // Sequence of jobs
    A[i][j] + A[j][i] == 1;
   
  // Constraints 6
  forall(i in Jobs, j in Jobs, r in Jobs : i != j && i != r && j != r) // Subtour elimination = prevent facing to impossible sequences of the jobs which is
     A[i][j] + A[j][r] + A[r][i] >= 1;                                 // required to compute the completion time of each job
   
  // Constraints 7
 forall(j in Nodes: j>0, k in Vehicles)
    S[k] >= sum(i in Nodes : i>0 && i != j) (p[i] * A[i][j]) + p[j] - M * (1 - sum(i in Nodes :i >0 && i != j) x[i][j][k]); // Start time for each vehicle(8)
   
  // Constraints 8
    forall(j in Jobs, k in Vehicles)
    D[j] - S[k] >= t[0][j] - M * (1 - x[0][j][k]); // Delay for each job

  // Constraints 9
  forall(i in Jobs, j in Jobs)
    D[j] - D[i] >= t[i][j] - M * (1 - sum(k in Vehicles) x[i][j][k]); // Delivery time for each job
   
     // Constraint (10)
  forall(i in Jobs, j in Jobs)
    T[i] >= D[i] - d[i]; // t if the delivery time of a customer exceeds its due date, then the tardiness for that customer equals the difference between the delivery time and the due date
   
 
 
}
 