#!../../bin/linux-x86_64/bkh

< envPaths

cd ${TOP}

# BK9000 + 2xKL1104 + KL2408 + KL3408 + 2xKL4132 + KL9010

dbLoadDatabase "dbd/bkh.dbd"
bkh_registerRecordDeviceDriver pdbbase

epicsEnvSet("N","4")
epicsEnvSet("LOC","ESAA")

save_restoreSet_status_prefix( "")
save_restoreSet_IncompleteSetsOk( 1)
save_restoreSet_DatedBackupFiles( 1)
set_savefile_path( "/nfs/slac/g/testfac/esa/$(IOC)","autosave")
set_pass0_restoreFile( "bkh$(N).sav")
set_pass1_restoreFile( "bkh$(N).sav")

drvAsynIPPortConfigure( "BKH$(N)","sioc-esa-bkh4:502",0,0,1)

#asynSetTraceIOMask( "BKH$(N)",0,4)
#asynSetTraceMask( "BKH$(N)",0,0xf)

modbusInterposeConfig( "BKH$(N)",0,1000)

#- drvMBusConfig( port,slave,addr,len,dtype,name,msec)
# where:
#  port is an octet port name,
#  slave is the modbus slave (0 for Beckhoff),
#  addr is the modbus starting address,
#  len is max memory length,
#  dtype is data type (0 for 2's compliment),
#  name is resource name used in diagnostic prints,
#  msec is poll period in miliseconds.
#-------------------------------------------------------- 
drvMBusConfig( "BKH$(N)",0,0,125,0,"BKH$(N)",10)

#- drvBkhAsynConfig( id,port,func,addr,len,nch,msec)
# id is a unique driver type identifier: 0 - coupler, 1 - analogSigned,
#   2 - analogUnsigned, 3 - digitalIn, 4 - digitalOut, 5 - motor.
# port is the asyn port name for this driver,
# addr is the modbus starting address of the memory image,
# func is the default modbus function,
# len is the length of the memory image, in bits or 16 bit words,
# nch is the number of channels,
# msec is the delay in msec in the reading poll thread,
#------------------------------------------------------------------------------
drvBkhAsynConfig( 0, "DEBUG", 3,     0,125, 2,   0)
drvBkhAsynConfig( 0, "B900R", 3,0x1000, 33,33,   0)
drvBkhAsynConfig( 0, "B900W", 3,0x110a, 26,26,   0)
drvBkhAsynConfig( 1, "A3408", 3,     0, 16, 8, 200)
drvBkhAsynConfig( 1, "A4132", 3,    16,  8, 4,1000)
drvBkhAsynConfig( 3, "A1104", 2,     0,  8, 8, 200)
drvBkhAsynConfig( 4, "A2408", 5,     0,  8, 8,   0)

#asynSetTraceIOMask( "A3408",0,4)
#asynSetTraceMask( "A3408",0,0xf)

dbLoadRecords( "db/bkh0$(N).db","P=$(LOC),M=$(N)")

cd ${AUTOSAVE}
dbLoadRecords( "db/save_restoreStatus.db","P=$(LOC):")

cd ${TOP}/iocBoot/${IOC}
iocInit

create_monitor_set( "bkh$(N).req",30,"P=$(LOC),M=$(N)")

dbpf "$(LOC):BO:900R-$(N):INIT.PROC" 1
dbpf "$(LOC):LO:DEBUG-$(N):MADDR" 0
dbpf "$(LOC):LO:DEBUG-$(N):MFUNC" 3
#dbpf $(LOC):LO:SC:900W-22:REG22,0
epicsThreadSleep(1)
dbpf "$(LOC):LO:SC:DEBUG-$(N):ALLOW:INLQ" 30
#----------
date
#----------
