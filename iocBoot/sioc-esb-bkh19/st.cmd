#!../../bin/linux-x86_64/bkh

< envPaths

cd ${TOP}

dbLoadDatabase "dbd/bkh.dbd"
bkh_registerRecordDeviceDriver pdbbase

epicsEnvSet("N",     "19")
epicsEnvSet("P",     "ESB")
epicsEnvSet("LOC",   "Laser Room LSS")
epicsEnvSet("MODLS", "BK9000,3xKL2114,3xKL1104,3xKL2124,3xKL1124")

save_restoreSet_status_prefix( "")
save_restoreSet_IncompleteSetsOk( 1)
save_restoreSet_DatedBackupFiles( 1)
set_savefile_path( "/nfs/slac/g/testfac/esb/$(IOC)","autosave")
set_pass0_restoreFile( "bkh.sav")
set_pass1_restoreFile( "bkh.sav")

drvAsynIPPortConfigure( "BKH$(N)","sioc-esb-bkh$(N):502",0,0,1)

asynSetTraceIOMask( "BKH$(N)",0,4)
#asynSetTraceMask( "BKH$(N)",0,0x9)

modbusInterposeConfig( "BKH$(N)",0,1000)
drvMBusConfig( "BKH$(N)",0,0,125,0,"BKH$(N)",10)

#- drvBkhAsynConfig( id,port,func,addr,len,nch,msec)
# id is a unique driver type identifier: 0 - coupler, 1 - analogSigned,
#   2 - analogUnsigned, 3 - digitalIn, 4 - digitalOut, 5 - motor.
# port is the asyn port name for this driver,
# func is the default modbus function,
# addr is the modbus starting address of the memory image,
# len is the length of the memory image, in bits or 16 bit words,
# nch is the number of channels,
# msec is the delay in msec in the reading poll thread,
#------------------------------------------------------------------------------
drvBkhAsynConfig(0, "DEBUG", 3,     0,125, 2,   0)
drvBkhAsynConfig(0, "B900R", 3,0x1000, 33,33,   0)
drvBkhAsynConfig(0, "B900W", 3,0x110a, 26,26,   0)
drvBkhAsynConfig(4, "A2114", 5,     0, 12,12,1000)
drvBkhAsynConfig(3, "A1104", 2,     0, 12,12,  50)
drvBkhAsynConfig(4, "A2124", 5,    12, 24,12,1000)
drvBkhAsynConfig(3, "A1124", 2,    12, 24,12,  50)

asynSetTraceIOMask( "A2114",0,4)
#asynSetTraceMask( "A2114",0,0x9)

dbLoadRecords( "db/bkh$(N).db","P=$(P),M=$(N),IOC=$(IOC),LOC=$(LOC),MODLS=$(MODLS)")

cd ${AUTOSAVE}
dbLoadRecords( "db/save_restoreStatus.db","P=$(P):")

cd ${TOP}/iocBoot/${IOC}
iocInit

create_monitor_set( "bkh.req",30,"P=$(P),M=$(N)")

dbpf "$(P):BO:900R-$(N):INIT.PROC" 1
dbpf "$(P):LO:DEBUG-$(N):MADDR" 0
dbpf "$(P):LO:DEBUG-$(N):MFUNC" 3
#dbpf $(P):LO:SC:900W-22:REG22,0
epicsThreadSleep(1)
dbpf "$(P):LO:SC:DEBUG-$(N):ALLOW:INLQ" 30
#-------------
date
#-------------
