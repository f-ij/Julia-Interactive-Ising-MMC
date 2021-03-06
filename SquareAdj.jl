"""
Stuff for initialization of adjacency matrix
"""
__precompile__()

module SquareAdj

export fillAdjList!

# Returns the indices of all the spins a particular spin is connected with
function coupleIndices(i,j,N)
    
    # Left right up down
    # Sets any of the above to false if spins are at the edge of lattice
    # Representing that there are no spins to that side anymore
    l,r,u,d = (true,true,true,true)
    if j == 1 
        l = false 
    end
    if j == N
        r = false 
    end
    if i == 1 
        u = false 
    end
    if i == N 
        d = false 
    end
    
    # Filters nearest neighbors that are outside of grid
    """lu u ru r rd d dl l"""
    idxs = [l && u, u , r && u , r , r && d, d, d && l , l]
    cn = (y, x) -> coordToIdx(y,x,N)
    nn = [cn(i-1,j-1),cn(i-1,j),cn(i-1,j+1),cn(i,j+1),cn(i+1,j+1),cn(i+1,j),cn(i+1,j-1),cn(i,j-1)]
    return nn[idxs]                    
end
       
# Fills adjacency list for a square grid
function fillAdjList!(cd,N)
    size = N*N
    
    @inbounds for idx in 1:size
        cd[idx] = []
    end

    @inbounds for idx in 1:size
        i,j = idxToCoord(idx,N)
        cd[idx] = coupleIndices(i,j,N)
    end
end



# Connection rule for lattice, not used right now
function conn_rule(i,j, N)
    i1,j1 = idxToCoord(i,N)
    i2,j2 = idxToCoord(j,N)
    
    # If any of the distances is greater than 1, not nearest neighbor
    if max(abs(i1-i2),abs(j1-j2)) > 1 || i==j
        return False
    end
    
    return True

end

# Matrix Coordinates to vector Coordinates
@inline  function coordToIdx(i,j,N)
    return (i-1)*N+j
end

coordToIdx((i,j),N) = coordToIdx(i,j,N)
# Go from idx to lattice coordinates
@inline function idxToCoord(idx::Int,N)
    return ((idx-1)÷N+1,(idx-1)%N+1)
end

end