/* file: bkhASub.c
 * EPICS asub routines.
 * This asub is used to convert an array of longs to an array chars.
 *----------------------------------------------------------------------------*/
#include <stdio.h>
#include <string.h>
#include <dbDefs.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <epicsExport.h>

#ifndef MIN
#define MIN(a,b)        (((a)<(b))?(a):(b))
#endif

static long bkhInit( aSubRecord* pr){
  printf( "bkhInit: %s\n",pr->name);
  return(0);
}
static long bkhConvert( aSubRecord* pr){
/*------------------------------------------------------------------------------
 * This routine simply transfers all data from input a to output a.
 *----------------------------------------------------------------------------*/
  int ni=pr->noa;
  long* pinp=(long*)pr->a;
  char* pout=(char*)pr->vala;
  int i; char* pb;

  for( i=0; i<ni; i++,pinp++){
    pb=(char*)pinp;
    *pout=(*pb);
    pout++; pb++;
    *pout=(*pb);
    pout++; pb++;
  }
  return(0);
}
epicsRegisterFunction( bkhInit);
epicsRegisterFunction( bkhConvert);
