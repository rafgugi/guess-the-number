Greedy

### A candidate set, from which a solution is created
The candidate is all seed number s = {1,...,M-1}

### A selection function, which chooses the best candidate to be added to the solution
We have four selection functions, they are
 - The most minimum distance
 - The most minimum distance, then the least maximum distance
 - The most (maximum distance - minimum distance)
 - The most minimum distance, then the least min count distance.
All selection functions will be tested and the best selection function will be used as main selection function.

### A feasibility function, that is used to determine if a candidate can be used to contribute to a solution
A candidate can't be used twice, so we skip the used candidates.

### An objective function, which assigns a value to a solution, or a partial solution, and
A selected candidate is assigned to the solution.

### A solution function, which will indicate when we have discovered a complete solution
