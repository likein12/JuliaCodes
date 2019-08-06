#created by liken12

mutable struct SegmentTree
    ide::Int64          #identity element
    sz::UInt32          #the size of the base array
    n::UInt32           #2n-1 is the number of the created nodes
    s::UInt8            #2^s = n
    node::Array{Int64}  #the array of nodes
    op::Function        #operator : you should select an operator

    #constructor
    function SegmentTree(array::Array{Int64},op::Function,ide::Int64)
        sz::UInt32 = length(array)
        n::UInt32 = 1
        s::UInt8 = 1
        for i=1:1000
            n *= 2
            s += 1
            if n >= sz
                break
            end
        end
        node::Array{Int64} = [ide for i=1:(2*n-1)]        

        for i=1:sz
            node[i+n-1] = array[i]
        end

        for i in n-1:-1:1
            node[i] = op(node[i*2],node[i*2+1])
        end
        new(ide,sz,n,s,node,op)
    end
end

#addition
function add(st::SegmentTree, index::Int, x::Int)
    k::UInt32 = index+st.n-1
    st.node[k] += x
    for i=1:1000
        k = floor(UInt32, k/2)
        st.node[k] = st.op(st.node[2*k], st.node[2*k+1])
        if k <= 1
            break
        end
    end
end

#get an element of the base array
get_one(st::SegmentTree, index::Int) = st.node[index+st.n-1]

#get an interval sum
function get(st::SegmentTree, l::Int, r::Int)
    res::Int64 = st.ide
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

#test code
println("create a SegmentTree with the code:")
println("\tst = SegmentTree([1,2,3,4,5,6,7,8,9,10],+,0)")
st = SegmentTree([1,2,3,4,5,6,7,8,9,10],+,0)
println("index 1, index 2, index 3")
println(string(get_one(st,1))*" "*string(get_one(st,2))*" "*string(get_one(st,3)))
println("sum from index 1 to index 3")
println(get(st,1,3))
println("add 2 to index 1")
add(st,1,2)
println("index 1, index 2, index 3")
println(string(get_one(st,1))*" "*string(get_one(st,2))*" "*string(get_one(st,3)))
println("sum from index 1 to index 3")
println(get(st,1,3))
println("sum from index 3 to index 7")
println(get(st,3,7))

println("")

println("choose max as an operator")
int64_min = -2^63
println("\tst = SegmentTree([1,2,3,4,5,6,7,8,9,10],max,int64_min)")
println("the identity element is -inf, but now we use -2^63 as the identity operator because it is the minimum number of Int64")
st_max = SegmentTree([1,2,3,4,5,6,7,8,9,10],max,int64_min)
println("max from index 3 to index 7")
println(get(st_max,3,7))
println("add 5 to index 4")
add(st_max,4,5)
println("now the base array is [1,2,3,9,5,6,7,8,9,10]")
println("index 4")
println(get_one(st_max,4))
println("max from index 3 to index 7")
println(get(st_max,3,7))