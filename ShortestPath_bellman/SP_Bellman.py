# CEE Course 2013winter
# nnode(nn) - number of nodes
# nlink(na) - number of links
# A - matrix for node attribute
# B - matrix for link attribute
# start - origin
# end - destination
# u - cost from current node to origin
# p - linkid to current node
# prenode - nodeid for the link to current node 
#
# p.s. list, array, matrix index starts from 0 in python
# written by Zihan HONG, Northwestern Univeristy

from numpy import *

def read():
    networkdata=open('D:\COURSE 2013winter\MARCO\matlab code\sf.1','r')
    lines=networkdata.readlines()
    nn=int(lines[0])
    for i in range(1,nn+1):
        linearray=lines[i].split( )
        A.append(map(int,lines[i].split()))
    na=int(lines[nn+1])
    for i in range(nn+2,2+nn+na):
        B.append(map(float,lines[i].split()))
    return (nn, na, A, B)

def initial():
    u=[-1] # initial -1 for node 0 
    p=[-1] # initial -1 for node 0
    prenode=[-1]      #innitial -1 for node 0 
    for i in range(1,nnode+1):
        p.append(-1)
        prenode.append(1)
        if i!=start:
            u.append(float('inf'))
        else:
            u.append(0)
    return u,p,prenode

def sp(start, end):
    u,p,prenode=initial()
    Q=[start]
    while (len(Q)>0):
        i=Q[0]    # alway take the first
        del Q[0]   # delete node i after taking it out
        for linkij in range(A[i][0],A[i][1]+1):       # from first out link to last
            j=int(B[linkij][1])  # get outnode of linkij
            cij=B[linkij][3]  # get cost/ length, if cost is time, we should involve speed
            if u[j]>u[i]+cij:
                u[j]=u[i]+cij
                p[j]=linkij         # to store the prelink
                prenode[j]=i        # to store prenode 
                if j not in Q:
                    Q.append(j)
    print ('distance is'), u[end]
    return (prenode)
                    
def sequence(prenode,start,end):    
    ite=1
    resequence=[end]
    nodesequence=[]
    i=end
    while(prenode[i]!=start and ite<=nnode):
        resequence.append(prenode[i])
        i=prenode[i]
        ite=ite+1
    resequence.append(start)
    for i in range(len(resequence)):
        nodesequence.append(resequence[len(resequence)-i-1])
        i=i+1
    print ('nodesequence is'), nodesequence   

if __name__=='__main__':
    global nnode, nlink,A,B
    A=[0] #initial 0 in A to avoid complex index starting from 0
    B=[0]
    start=12
    end=7
    nnode,nlink,A,B=read()
    prenode=sp(start,end)
    sequence(prenode,start,end)
##    print nnode,nlink,len(A),len(B)
