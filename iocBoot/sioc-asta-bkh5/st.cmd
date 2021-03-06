#!../../bin/linux-x86_64/bkh

< envPaths

cd ${TOP}

dbLoadDatabase "dbd/bkh.dbd"
bkh_registerRecordDeviceDriver pdbbase

epicsEnvSet("N","5")
epicsEnvSet("LOC","ASTA")

save_restoreSet_status_prefix( "")
save_restoreSet_IncompleteSetsOk( 1)
save_restoreSet_DatedBackupFiles( 1)
set_savefile_path( "/nfs/slac/g/testfac/asta/$(IOC)","autosave")
set_pass0_restoreFile( "bkh$(N).sav")
set_pass1_restoreFile( "bkh$(N).sav")

#drvAsynIPPortConfigure( "BKH$(N)","sioc-asta-bk05:502",0,0,1)
drvAsynIPPortConfigure( "BKH$(N)","172.27.249.10:502",0,0,1)

asynSetTraceIOMask( "BKH$(N)",0,4)
#asynSetTraceMask( "BKH$(N)",0,0x9)

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
drvBkhAsynConfig(1, "A3182", 3,    16, 32,16, 200)
drvBkhAsynConfig(1, "A1512", 3,    48,  4, 2, 200)
drvBkhAsynConfig(1, "A3464", 3,    52,  8, 4, 200)
drvBkhAsynConfig(3, "A1408", 2,     0,  8, 8, 200)

#asynSetTraceIOMask( "A3408",0,4)
#asynSetTraceMask( "A3408",0,0xf)

dbLoadRecords( "db/bkh05.db","P=$(LOC),M=$(N),LOC=$(LOC),IOC=$(IOC)")

cd ${AUTOSAVE}
dbLoadRecords( "db/save_restoreStatus.db","P=ASTA:")

cd ${TOP}/iocBoot/${IOC}
iocInit

create_monitor_set( "bkh$(N).req",30,"P=ASTA,M=$(N)")

dbpf "$(LOC):BO:900R-$(N):INIT.PROC" 1
dbpf "$(LOC):LO:DEBUG-$(N):MADDR" 0
dbpf "$(LOC):LO:DEBUG-$(N):MFUNC" 3
epicsThreadSleep(1)
dbpf "$(LOC):LO:SC:DEBUG-$(N):ALLOW:INLQ" 30
#----------
date
#----------
