#!../../bin/linux-x86_64/bkh

< envPaths

cd ${TOP}

# BK9000 + 6xKL2531 + KL3162 + KL4032 + KL9010

dbLoadDatabase "dbd/bkh.dbd"
bkh_registerRecordDeviceDriver pdbbase

epicsEnvSet("N","15")
epicsEnvSet("LOC","ESB")
epicsEnvSet("MOT1","2531-1")
epicsEnvSet("MOT2","2531-2")
epicsEnvSet("MOT3","2531-3")
epicsEnvSet("MOT4","2531-4")
epicsEnvSet("MOT5","2531-5")
epicsEnvSet("MOT6","2531-6")

save_restoreSet_status_prefix( "")
save_restoreSet_IncompleteSetsOk( 1)
save_restoreSet_DatedBackupFiles( 1)
set_savefile_path( "/nfs/slac/g/testfac/esb/$(IOC)","autosave")
set_pass0_restoreFile( "bkh$(N).sav")
set_pass1_restoreFile( "bkh$(N).sav")

drvAsynIPPortConfigure( "BKH$(N)","sioc-esb-bkh15:502",0,0,1)

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
drvBkhAsynConfig(0,   "DEBUG", 3,     0,125, 2,   0)
drvBkhAsynConfig(0,   "B900R", 3,0x1000, 33,33,   0)
drvBkhAsynConfig(0,   "B900W", 3,0x110a, 26,26,   0)
drvBkhAMotConfig(  "A$(MOT1)", 3,     0,  3, 1, 200, 0)
drvBkhAMotConfig( "A$(MOT1)B", 3,     0,  3, 1,   0, 0)
drvBkhAMotConfig( "A$(MOT1)C", 3,     0,  3, 1,   0,32)
drvBkhAMotConfig(  "A$(MOT2)", 3,     3,  3, 1, 200, 0)
drvBkhAMotConfig( "A$(MOT2)B", 3,     3,  3, 1,   0, 0)
drvBkhAMotConfig( "A$(MOT2)C", 3,     3,  3, 1,   0,32)
drvBkhAMotConfig(  "A$(MOT3)", 3,     6,  3, 1, 200, 0)
drvBkhAMotConfig( "A$(MOT3)B", 3,     6,  3, 1,   0, 0)
drvBkhAMotConfig( "A$(MOT3)C", 3,     6,  3, 1,   0,32)
drvBkhAMotConfig(  "A$(MOT4)", 3,     9,  3, 1, 200, 0)
drvBkhAMotConfig( "A$(MOT4)B", 3,     9,  3, 1,   0, 0)
drvBkhAMotConfig( "A$(MOT4)C", 3,     9,  3, 1,   0,32)
drvBkhAMotConfig(  "A$(MOT5)", 3,    12,  3, 1, 200, 0)
drvBkhAMotConfig( "A$(MOT5)B", 3,    12,  3, 1,   0, 0)
drvBkhAMotConfig( "A$(MOT5)C", 3,    12,  3, 1,   0,32)
drvBkhAMotConfig(  "A$(MOT6)", 3,    15,  3, 1, 200, 0)
drvBkhAMotConfig( "A$(MOT6)B", 3,    15,  3, 1,   0, 0)
drvBkhAMotConfig( "A$(MOT6)C", 3,    15,  3, 1,   0,32)
drvBkhAsynConfig(2,   "A3162", 3,    18, 12, 6, 200)
drvBkhAsynConfig(1,   "A4032", 3,    30, 12, 6,   0)

#asynSetTraceIOMask( "A3162",0,4)
#asynSetTraceMask( "A3162",0,0xf)

dbLoadRecords( "db/bkh$(N).db","P=$(LOC),M=$(N),IOC=$(IOC),LOC=B062-54 (SLED)")
dbLoadRecords( "db/bkhMot$(N).db","P=$(LOC),M=$(N)")
dbLoadRecords( "db/bkhSledSaveRestore.db","P=$(LOC),M=$(N)")

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
dbpf "$(LOC):BO:$(MOT3)-$(N):CH1:MOT:ENABL" 0
dbpf "$(LOC):BO:$(MOT4)-$(N):CH1:MOT:ENABL" 0
dbpf "$(LOC):BO:$(MOT5)-$(N):CH1:MOT:ENABL" 0
dbpf "$(LOC):BO:$(MOT6)-$(N):CH1:MOT:ENABL" 0

dbpf "$(LOC):BO:$(MOT1)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT1)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT1)-$(N):INIT:A" 1

dbpf "$(LOC):BO:$(MOT2)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT2)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT2)-$(N):INIT:A" 1

dbpf "$(LOC):BO:$(MOT3)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT3)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT3)-$(N):INIT:A" 1

dbpf "$(LOC):BO:$(MOT4)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT4)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT4)-$(N):INIT:A" 1

dbpf "$(LOC):BO:$(MOT5)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT5)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT5)-$(N):INIT:A" 1

dbpf "$(LOC):BO:$(MOT6)-$(N):INIT:B" 1
dbpf "$(LOC):BO:$(MOT6)-$(N):INIT:C" 1
dbpf "$(LOC):BO:$(MOT6)-$(N):INIT:A" 1

epicsThreadSleep(5)
dbpf "$(LOC):AO:SC:$(MOT1)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:SC:$(MOT2)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:SC:$(MOT3)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:SC:$(MOT4)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:SC:$(MOT5)-$(N):CH1:SET:POS:MM.PROC" 1
dbpf "$(LOC):AO:SC:$(MOT6)-$(N):CH1:SET:POS:MM.PROC" 1

dbpf "$(LOC):AO:$(MOT1)-$(N):CH1:SET:INC:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT2)-$(N):CH1:SET:INC:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT3)-$(N):CH1:SET:INC:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT4)-$(N):CH1:SET:INC:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT5)-$(N):CH1:SET:INC:MM.PROC" 1
dbpf "$(LOC):AO:$(MOT6)-$(N):CH1:SET:INC:MM.PROC" 1
epicsThreadSleep(2)
dbpf "$(LOC):LO:SC:DEBUG-$(N):ALLOW:INLQ" 30
#-------------------
date
#-------------------
