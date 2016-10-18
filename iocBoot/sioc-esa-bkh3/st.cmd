#!../../bin/linux-x86_64/bkh

< envPaths

cd ${TOP}

# BK9000+KL3408+KL1104+KL2408+KL1408+KL1498+KL2124+KL3132+KL3314+KL3064+KL9010

dbLoadDatabase "dbd/bkh.dbd"
bkh_registerRecordDeviceDriver pdbbase

epicsEnvSet("N","3")
epicsEnvSet("LOC","ESAA")

save_restoreSet_status_prefix( "")
save_restoreSet_IncompleteSetsOk( 1)
save_restoreSet_DatedBackupFiles( 1)
set_savefile_path( "/nfs/slac/g/testfac/esa/$(IOC)","autosave")
set_pass0_restoreFile( "bkh$(N).sav")
set_pass1_restoreFile( "bkh$(N).sav")

drvAsynIPPortConfigure( "BKH$(N)","192.168.1.193:502",0,0,1)

#asynSetTraceIOMask( "BKH$(N)",0,4)
#asynSetTraceMask( "BKH$(N)",0,0xf)

modbusInterposeConfig( "BKH$(N)",0,1000)

drvMBusConfig( "BKH$(N)",0,0,125,0,"BKH$(N)",10)

#- drvBkhAsynConfig( id,port,func,addr,len,nch,msec)
# id is a unique driver type identifier: 0 - coupler, 1 - analogIn,
#   2 - analogOut, 3 - digitalIn, 4 - digitalOut, 5 - motor.
# port is the asyn port name for this driver,
# addr is the modbus starting address of the memory image,
# func is the default modbus function,
# len is the length of the memory image, in bits or 16 bit words,
# nch is the number of channels,
# msec is the delay in msec in the reading poll thread,
#------------------------------------------------------------------------------
drvBkhAsynConfig(0, "DEBUG", 3,     0,125, 2,   0)
drvBkhAsynConfig(0, "B900R", 3,0x1000, 33,33,   0)
drvBkhAsynConfig(0, "B900W", 3,0x110a, 26,26,   0)
drvBkhAsynConfig(1, "A3408", 3,     0, 16, 8, 200)
drvBkhAsynConfig(1, "A1512", 3,    16,  4, 2, 200)
drvBkhAsynConfig(1, "A3314", 3,    20,  8, 4, 200)
drvBkhAsynConfig(3, "A1104", 2,     0,  4, 4, 200)
drvBkhAsynConfig(3, "A1408", 2,     4,  8, 8, 200)
drvBkhAsynConfig(4, "A1498", 2,    12,  8, 8, 200)
drvBkhAsynConfig(4, "A2408", 5,     0,  8, 8,   0)

#asynSetTraceIOMask( "A3408",0,4)
#asynSetTraceMask( "A3408",0,0xf)

dbLoadRecords( "db/bkh03.db","P=$(LOC),M=$(N),LOC=$(LOC),IOC=$(IOC)")

#cd ${AUTOSAVE}
#dbLoadRecords( "db/save_restoreStatus.db","P=$(LOC):")

cd ${TOP}/iocBoot/${IOC}
iocInit

#create_monitor_set( "bkh$(N).req",30,"P=$(LOC),M=$(N)")
dbpf "$(LOC):BO:900R-$(N):INIT.PROC" 1
dbpf "$(LOC):LO:DEBUG-$(N):MADDR" 0
dbpf "$(LOC):LO:DEBUG-$(N):MFUNC" 3
epicsThreadSleep(1)
dbpf "$(LOC):LO:SC:DEBUG-$(N):ALLOW:INLQ" 30
#----------
date
#----------
