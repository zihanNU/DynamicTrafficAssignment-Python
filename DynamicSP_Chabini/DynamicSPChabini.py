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
import time
from numpy import *

def read():
    networkdata=open('sfb.1','r')
    lines=networkdata.readlines()
    nn=int(lines[0])
    for i in range(1,nn+1):
        linearray=lines[i].split( )
        A.append(map(int,lines[i].split()))
    na=int(lines[nn+1])
    for i in range(nn+2,2+nn+na):
        B.append(map(float,lines[i].split()))
    return (nn, na, A, B)

def read1():
    time=open('costsf.csv','r')
    lines=time.readlines()
    for i in range(0,len(lines)):
        ta.append(map(int,lines[i].split(',')))
    return (ta)

def initialdyna():
    uh=[]
    ph=[]
    for h in range (0,T):
        for i in range(0,nnode+1):
            if i!=end:
                uh.append(float('inf'))
                ph.append(float('inf'))
            else:
                ph.append(0)
                uh.append(0)
    uh=array(uh).reshape(T,nnode+1)
    ph=array(ph).reshape(T,nnode+1)
    uT,pT=sp(start,end)
    uh=list(uh)
    ph=list(ph)
    uh.append(uT)
    ph.append(pT)
    return uh,ph

def initialst():
    u=[-1] # initial -1 for node 0 
    p=[-1] # initial -1 for node 0
    prenode=[-1]      #innitial -1 for node 0 
    for i in range(1,nnode+1):
        p.append(-1)
        prenode.append(1)
        if i!=end:
            u.append(float('inf'))
        else:
            u.append(0)
    return u,p,prenode

def sp(start, end):
    u,p,prenode=initialst()
    Q=[end]
    while (len(Q)>0):
        j=Q[0]    # alway take the first
        del Q[0]   # delete node i after taking it out
        for linkij in range(A[j][0],A[j][1]+1):       # from first out link to last
            i=int(B[linkij][0])
            cij=ta[linkij-1][T-1]   #because python start from 0. So if T-1 is T in cost matrix
            if u[j]+cij<u[i]:
                u[i]=u[j]+cij
                p[i]=linkij         # to store the prelink
                if i not in Q:
                    Q.append(i)
    return u,p

def spcha(start, end):
    uh,ph=initialdyna()
    h=T-1
    while (h>=1):
        for linkij in range(1,nlink+1):       # from all links
            cij=ta[linkij-1][h-1] 
            te=min(T,h+cij)
            i=int(B[linkij][0])
            j=int(B[linkij][1])
            if uh[h][i]>uh[te][j]+cij:
                uh[h][i]=uh[te][j]+cij
                ph[h][i]=linkij         # to store the prelink
        h=h-1
    cost=uh[1][start]
    k=1
##    for h in range (2,T+1):
##        if uh[h][start]<cost:
##            cost=uh[h][start]
##            k=h
##    print 'T=',T, 'minimum cost is ',int(cost),'start time',k
    for h in range (1,11):
         print 'cost is ',int(uh[h][start]),' for time interval',h
##         sequence(ph,h,start,end)
         print ph
    return  
                    
def sequence(ph,h,start,end):    
    ite=1
    i=start
    nodesequence=[start]
    while(ite<=nnode):
        linkij=int(ph[h][i])
        j=int(B[linkij][1])
        if j!=end:
            nodesequence.append(j)
            i=j
            ite=ite+1
            te=min(h+ta[linkij-1][h-1],T)
            h=te
        else:
            break
    nodesequence.append(end)
    print ('node sequence is'), nodesequence


if __name__=='__main__':
    global nnode, nlink,A,B,ta,T
    A=[0] #initial 0 in A to avoid complex index starting from 0
    B=[0]
    ta=[]
    start=1
    end=24
    nnode,nlink,A,B=read()
    ta=read1()
    T=100
    tic=time.clock()
    spcha(start,end)
    toc=time.clock()
    print 'from', start,'to',end
    print 'run time',toc-tic
        
