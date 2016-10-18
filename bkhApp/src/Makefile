TOP=../..

include $(TOP)/configure/CONFIG

PROD_IOC = bkh

DBD += bkh.dbd
bkh_DBD += base.dbd
bkh_DBD += asyn.dbd
bkh_DBD += drvAsynIPPort.dbd
bkh_DBD += asSupport.dbd
bkh_DBD += drvMBus.dbd
bkh_DBD += drvBkhAsyn.dbd
bkh_DBD += drvBkhAMot.dbd
bkh_DBD += bkhSup.dbd

bkh_LIBS += mBus
bkh_LIBS += bkhAMot
bkh_LIBS += bkhA
bkh_LIBS += autosave
bkh_LIBS += asyn

# bkh_registerRecordDeviceDriver.cpp derives from bkh.dbd
bkh_SRCS += bkh_registerRecordDeviceDriver.cpp
bkh_SRCS += bkh5ASub.c

bkh_SRCS_DEFAULT += bkhMain.cpp
bkh_SRCS_vxWorks += -nil-

bkh_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES

