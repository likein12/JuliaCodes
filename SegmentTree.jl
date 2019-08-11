#created by liken12

mutable struct SegmentTree{T}
    op::Function        #operator : you should select an operator
    ide::T              #identity element
    node::Array{T}      #the array of nodes
    sz::UInt32          #the size of the base array
    n::UInt32           #2n-1 is the number of the created nodes
    s::UInt8            #2^s = n

    #constructor
    function SegmentTree{T}(array::Array{T},op::Function,ide::T) where T
        sz::UInt32 = length(array)
        n::UInt32 = 1
        s::UInt8 = 1
        while n < sz 
            n *= 2
            s += 1
        end
        node::Array{T} = [ide for i=1:(2*n-1)]        

        for i=1:sz
            node[i+n-1] = array[i]
        end

        for i in n-1:-1:1
            node[i] = op(node[i*2],node[i*2+1])
        end
        new{T}(op,ide,node,sz,n,s)
    end
end

#addition
function update!(st::SegmentTree{T}, index::Int, x::T) where T
    k::UInt32 = index+st.n-1
    st.node[k] += x
    while k > 2
        k = floor(UInt32, k/2)
        st.node[k] = st.op(st.node[2*k], st.node[2*k+1])
    end
end

#get an element of the base array
get_one(st::SegmentTree{T}, index::Int) where T = st.node[index+st.n-1]

#get an interval sum
function get(st::SegmentTree{T}, l::Int, r::Int) where T
    res::T = st.ide
    n::UInt32 = st.n
    if st.sz < r || 1 > l
        println("ERROR: the indice are wrong.")
        return false
    end

    right::UInt32 = 0
    left::UInt32 = 0
    cnt::UInt8 = 1
    for i=1:st.s
        count::UInt32 = 2^(i-1)
        a = floor(Int64,r/n)
        b = floor(Int64,(l-2)/n)
        if a-b == 3
            res = st.op(st.node[count+b+1],res)
            res = st.op(st.node[count+b+2],res)
            right = a*n+1
            left = (b+1)*n
            break
        end
        if a-b == 2
            res = st.op(st.node[count+b+1],res)
            right = a*n+1
            left = (b+1)*n
            break
        end
        n = floor(UInt32,n/2)
        cnt += 1
    end
    #left
    n1::UInt32 = floor(UInt32,n/2)
    for j=cnt+1:st.s
        count::UInt32 = 2^(j-1)
        a = floor(Int64,left/n1)
        b = floor(Int64,(l-2)/n1)
        if a-b == 2
            res = st.op(st.node[count+b+1],res)
            left = (b+1)*n1
        end
        n1 = floor(UInt32,n1/2)
    end
    #right
    n1 = floor(UInt32,n/2)
    for j=cnt+1:st.s
        count::UInt32 = 2^(j-1)
        a = floor(Int64,r/n1)
        b = floor(Int64,(right-2)/n1)
        if a-b == 2
            res = st.op(st.node[count+b+1],res)
            right = a*n1+1
        end
        n1 = floor(UInt32,n1/2)
    end
    res
end
