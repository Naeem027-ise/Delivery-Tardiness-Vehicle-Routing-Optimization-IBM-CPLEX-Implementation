/*********************************************
 * OPL 22.1.1.0 Data
 * Author: naeem
 * Creation Date: Nov 30, 2023 at 11:06:57 AM
 *********************************************/
 // Indices and ranges
range Jobs = 1..3;     // Jobs
range Vehicles = 1..3; // Vehicles
range Nodes = 0..3;    // Nodes including the depot (0)

// Parameters 
int c[Nodes][Nodes];  // Cost matrix
int t[Nodes][Nodes];  // Time matrix
int p[Jobs];          // Processing times
int w[Jobs];          // Penalties for tardiness
int d[Jobs];          // Due dates
int F;               // Fixed cost for vehicle use
int Q[Vehicles];     // Vehicle capacities
int M;               // A large number for logical constraints

// Decision variables
dvar boolean x[Nodes][Nodes][Vehicles];
dvar boolean y[Vehicles];
dvar float+ S[Vehicles];
dvar float+ D[Jobs];
dvar float+ T[Jobs];

// Objective function
minimize
  sum(i in Nodes, j in Nodes, k in Vehicles) c[i][j] * x[i][j][k] + F * sum(k in Vehicles) y[k] + sum(i in Jobs) w[i] * T[i];

// Constraints
subject to {
  // Each job is served by exactly one vehicle
  forall(i in Jobs)
    sum(k in Vehicles, j in Nodes : j != i) x[i][j][k] == 1;

  // Vehicle capacity constraint
  forall(k in Vehicles)
    sum(i in Nodes, j in Nodes : i != j) x[i][j][k] <= Q[k] * y[k];

  // Vehicle use constraint
  forall(k in Vehicles)
    y[k] == sum(j in Nodes) x[0][j][k];

  // Flow conservation for each job and vehicle
  forall(h in Nodes, k in Vehicles)
    sum(i in Nodes) x[i][h][k] == sum(j in Nodes) x[h][j][k];

  // Start time and delivery time constraints for each job
  forall(k in Vehicles)
    forall(i in Jobs)
      forall(j in Jobs : i != j)
        S[k] + p[i] + t[i][j] <= S[k] + M * (1 - x[i][j][k]);

  // Delivery time constraints
  forall(j in Jobs)
    D[j] >= S[j] - M * (1 - sum(k in Vehicles, i in Nodes) x[i][j][k]);

  // Tardiness constraints for each job
  forall(i in Jobs)
    T[i] >= D[i] - d[i];

  // Binary constraints for decision variables
  //forall(i in Nodes, j in Nodes, k in Vehicles)
    //x[i][j][k] in {0,1};

  //forall(k in Vehicles)
    //y[k] in {0,1};

  // Non-negativity constraints
  forall(k in Vehicles)
    S[k] >= 0;

  forall(i in Jobs)
    D[i] >= 0;

  forall(i in Jobs)
    T[i] >= 0;
}
