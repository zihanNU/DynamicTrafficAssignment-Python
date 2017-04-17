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
    networkdata=open('D:\Course2013Spring\Marco\hw3\sfb.1','r')
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
    time=open('D:\Course2013Spring\Marco\hw3\costsf.csv','r')
    lines=time.readlines()
    for i in range(0,len(lines)):
        ta.append(map(int,lines[i].split(',')))
    return (ta)

##def get_cat(): # to get capacity and freeflow time for each link
##    for i in range(1,nlink+1): # from link 1 to link n
##        capacity.append(B[i][2])
##        t0.append(B[i][3]/B[i][4])
##    return

def initial():
    uh=[]
    ph=[]
    for h in range (0,T+1):
        for i in range(0,nnode+1):
            if i!=end:
                uh.append(float('inf'))
                ph.append(float('inf'))
            else:
                ph.append(0)
                uh.append(0)
    uh=array(uh).reshape(T+1,nnode+1)
    ph=array(ph).reshape(T+1,nnode+1)
    return uh,ph

def sphani(start, end):
    uh,ph=initial()
    Q=[end]
    while (len(Q)>0):
        j=Q[0]    # alway take the first
        del Q[0]   # delete node i after taking it out
        for linkij in range(A[j][0],A[j][1]+1):       # from first out link to last
            flag=0
            for h in range(1,T+1):
                cij=ta[linkij-1][h-1] 
                te=min(T,h+cij)
                i=int(B[linkij][0])  
                if uh[te][j]+cij<uh[h][i]:
                    uh[h][i]=uh[te][j]+cij
                    ph[h][i]=linkij         # to store the prelink
                    if flag==0:
                        Q.append(i)
                        flag=1
    cost=uh[1][start]
    k=1
    for h in range (2,T+1):
        if uh[h][start]<cost:
            cost=uh[h][start]
            k=h
    print 'T=',T,'minimum cost is ',int(cost),'start time',k
##    for h in range (1,T+1):
##         print 'cost is ',int(uh[h][start]),'  start time',h
##         sequence(ph,h,start,end)
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
    tic=time.clock()
    A=[0] #initial 0 in A to avoid complex index starting from 0
    B=[0]
    ta=[]
    start=1
    end=24
    nnode,nlink,A,B=read()
    ta=read1()
    T=100
    sphani(start,end)
    toc=time.clock()
    print 'from', start,'to',end
    print 'run time',toc-tic
