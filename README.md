### A single-origin manufacturer must deliver multiple customer orders through a capacitated vehicle network. Each job has a processing time, travel time/cost, vehicle-capacity requirement, and a strict due-date penalty. The challenge is to assign jobs to vehicles, sequence their routes, and schedule departures so total cost—transport, fixed vehicle cost, and late-delivery penalties—is minimized.

### Goal
Create and test an optimization model that produces the lowest‐cost, on-time distribution plan, while revealing how factors like vehicle count, capacity, and due-date tightness drive cost and feasibility. 

### Solution Approach

MILP formulation – Defined decision variables, cost objective, and 10 constraints (flow balance, capacity, sequencing, tardiness) to capture the integrated routing-and-scheduling problem.

CPLEX implementation – Coded the model in an OPL .mod/.dat pair and solved six progressively harder datasets (2–14 customers, 2–4 vehicles, varied capacities & due dates).

Scenario analysis – Systematically tweaked due dates, penalty weights, vehicle capacity, and matrix size to quantify their impact on total cost (objective values rose from 156 → 2 188 across runs).

Runtime management – Introduced a time-limit flag for the largest 15 × 15 instance, obtaining a near-optimal heuristic in 300 s when exact search proved prohibitive.
