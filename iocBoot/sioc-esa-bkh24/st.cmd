#!../../bin/linux-x86_64/bkh

< envPaths

cd ${TOP}

# BK9000 + KL3132 + KL2531 + KL2541 + KL3172 + KL4001 + KL1498 + KL2114 + KL9010

dbLoadDatabase "dbd/bkh.dbd"
bkh_registerRecordDeviceDriver pdbbase

epicsEnvSet("N","24")
epicsEnvSet("LOC","ESA")
epicsEnvSet("MOT1","2531")
epicsEnvSet("MOT2","2541")

save_restoreSet_status_prefix( "")
save_restoreSet_IncompleteSetsOk( 1)
save_restoreSet_DatedBackupFiles( 1)
set_savefile_path( "/nfs/slac/g/testfac/esa/$(IOC)","autosave")
set_pass0_restoreFile( "bkh$(N).sav")
set_pass1_restoreFile( "bkh$(N).sav")

drvAsynIPPortConfigure( "BKH$(N)","sioc-esa-bkh24:502",0,0,1)
#drvAsynIPPortConfigure( "BKH$(N)","192.168.1.194:502",0,0,1)

#asynSetTraceIOMask( "BKH$(N)",0,4)
#asynSetTraceMask( "BKH$(N)",0,0xf)

modbusInterposeConfig( "BKH$(N)",0,1000)

# drvMBusConfig( port,slave,addr,len,dtype,name,msec
#  port is octet port as in drvAsynIPPortConfigure
#  slave is modbus slave (0 for Beckhoff),
#  addr is modbus starting address,
#  len is modbus memory length in units of bit or 16 bit word,
#  dtype is data type (0 if two's complement),
#  name is used in print statements,
#  msec is poll routine timeout in mili seconds.
#-----------------------------------------------------------------
drvMBusConfig( "BKH$(N)",0,0,125,0,"BKH$(N)",10)

#- drvBkhAsynConfig( id,port,func,addr,len,nch,msec)
#- drvBkhAMotConfig( port,func,addr,len,nch,msec,roffs)
# id is a unique driver type identifier: 0 - coupler, 1 - analogSigned,
#   2 - analogUnsigned, 3 - digitalIn, 4 - digitalOut, 5 - motor.
# port is the asyn port name for this driver,
# addr is the modbus starting address of the memory image,
# func is the default modbus function,
# len is the length of the memory image, in bits or 16 bit words,
# nch is the number of channels,
# msec is the delay in msec in the reading poll thread,
# roffs is added to addr to get hidden register number
#------------------------------------------------------------------------------
drvBkhAsynConfig(0,  "DEBUG", 3,     0,125, 2,   0)
drvBkhAsynConfig(0,  "B900R", 3,0x1000, 33,33,   0)
drvBkhAsynConfig(0,  "B900W", 3,0x110a, 26,26,   0)
drvBkhAsynConfig( 1, "A3132", 3,     0,  4, 2, 200)
drvBkhAMotConfig(  "$(MOT1)", 3,     4,  3, 1, 200, 0)
drvBkhAMotConfig( "$(MOT1)B", 3,     4,  3, 1,   0, 0)
drvBkhAMotConfig( "$(MOT1)C", 3,     4,  3, 1,   0,32)
drvBkhAMotConfig(  "$(MOT2)", 3,     7,  3, 1, 200, 0)
drvBkhAMotConfig( "$(MOT2)B", 3,     7,  3, 1,   0, 0)
drvBkhAMotConfig( "$(MOT2)C", 3,     7,  3, 1,   0,32)
drvBkhAsynConfig( 1, "A4132", 3,    10,  4, 2,   0)
drvBkhAsynConfig( 3, "A1498", 2,     0,  8, 8, 200)
drvBkhAsynConfig( 4, "A2114", 5,     0,  8, 4,   0)

#asynSetTraceIOMask( "A3132",0,4)
#asynSetTraceMask( "A3132",0,0xf)

dbLoadRecords( "db/bkh$(N).db","P=$(LOC),M=$(N),IOC=$(IOC),LOC=$(LOC)")
dbLoadRecords( "db/bkhMot$(N).db","P=$(LOC),M=$(N)")

cd ${AUTOSAVE}
dbLoadRecords( "db/save_restoreStatus.db","P=$(LOC):")

cd ${TOP}/iocBoot/${IOC}
iocInit

create_monitor_set( "bkh$(N).req",30,"P=$(LOC),M=$(N)")

dbpf "$(LOC):BO:900R-$(N):INIT.PROC" 1
dbpf "$(LOC):LO:DEBUG-$(N):MADDR" 0
dbpf "$(LOC):LO:DEBUG-$(N):MFUNC" 3
dbpf "$(LOC):BO:$(MOT1)-$(N):CH1:MOT:ENABL" 0
dbpf "$(LOC):BO:$(MOT2)-$(N):CH1:MOT:ENABL" 0

dbpf "$(LOC):BO:$(MOT1)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT1)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT1)-$(N):INIT:A" 1
dbpf "$(LOC):BO:$(MOT2)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT2)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT2)-$(N):INIT:A" 1

epicsThreadSleep(5)
dbpf "$(LOC):AO:$(MOT1)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT1)-$(N):CH1:SET:INC:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT2)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT2)-$(N):CH1:SET:INC:MM.PROC" 1
epicsThreadSleep(2)
dbpf "$(LOC):LO:SC:DEBUG-$(N):ALLOW:INLQ" 30
#---------
date
#---------
