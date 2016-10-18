#!/bin/bash
# Launch epicsQt GUI for this IOC.
#------------------------------------------------------------------------------
guidir=/afs/slac/g/testfac/tools/display/bkhoffM/ui
macro="P=CHA,N=2,Q1=2531-1,Q2=2531-2,R=3132,T=4132"
cd $guidir
arch-64/motors -m $macro&
